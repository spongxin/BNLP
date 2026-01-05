# -*- coding: utf-8 -*-
import argparse
import io
import json
import os
import sys
import tiktoken
import time
from langchain_text_splitters import RecursiveCharacterTextSplitter
from loguru import logger  # 日志
from openai import AzureOpenAI
from openai import OpenAI
from tqdm import tqdm

# 导入process模块中的主函数
from process import main as process_main

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# 选择一个编码器，比如 gpt-3.5-turbo / gpt-4 的
encoding = tiktoken.encoding_for_model("gpt-4o")


# 定义 token 计数函数
def count_tokens(text: str) -> int:
    return len(encoding.encode(text))


MODEL_NAME = ''
END_POINT = ''
API_KEY = ''
CHUNK_SIZE = 1000

# 全局变量
DIR_PATH = ''


def write_token_count(prompt_tokens, completion_tokens, total_tokens):
    """将token计数追加写入token_count.txt文件，格式：prompt_tokens\tcompletion_tokens\ttotal_tokens"""
    token_count_file = os.path.join(DIR_PATH, "token_count.txt")
    try:
        with open(token_count_file, 'a', encoding='utf-8') as f:
            f.write(f"{prompt_tokens}\t{completion_tokens}\t{total_tokens}\n")
        logger.info(
            f"Token计数已追加到文件 - Prompt: {prompt_tokens}, Completion: {completion_tokens}, Total: {total_tokens}")
    except Exception as e:
        logger.error(f"写入token计数文件时出错: {e}")


def parse_args():
    parser = argparse.ArgumentParser(description="AI标注处理程序")
    parser.add_argument("--input_dir", type=str, required=True,
                        help="工作目录路径")
    parser.add_argument("--model_name", type=str, required=True,
                        help="模型名称")
    parser.add_argument("--end_point", type=str, required=True,
                        help="模型API Endpoint")
    parser.add_argument("--api_key", type=str, required=True,
                        help="模型API Key")
    parser.add_argument("--max_attempts", type=int, default=5,
                        help="最大尝试次数")
    parser.add_argument("--chunk_size", type=int, default=1000,
                        help="最大尝试次数")
    return parser.parse_args()


# 拼凑当前示例的prompt
def assemble_prompt(article_content, prompt_path):
    # 读取使用的prompt
    with open(prompt_path, 'r', encoding='utf-8') as file:
        prompt_txt = file.read()
    assembled_prompt = f"{prompt_txt}\n{article_content}"
    return assembled_prompt


def run_prompt(article_id, text_list, entity_list, output_file, processed_article_ids_file):
    try:
        # 将 JSON 数组转换为 Python 字典
        entities_dict = {'article_id': article_id, 'text_list': text_list, 'entities': entity_list}
        print(json.dumps(entities_dict, ensure_ascii=False, indent=4))

        # 将结果存入文件
        if not os.path.exists(output_file):
            # 文件不存在
            data = []
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=4)
        else:
            # 文件存在，读取现有内容
            with open(output_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
        data.append(entities_dict)  # 追加新的 JSON 对象到数组中,并将更新后的数组写回文件
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)

        logger.info(f" article_id :{article_id},存入处理后的json内容")

        # 记录已使用 prompt 的article_id
        with open(processed_article_ids_file, 'a') as f:  # 追加模式写入文件
            f.write(f"{article_id}\n")

    except Exception as e:
        logger.error(f"article_id :{article_id}, 发生了一个错误: {e}")
        sys.exit(1)


def extract_id_txt(matched_data, prompt_path, processed_article_ids_file, output_file, api_key, max_attempts):
    # 获取已经处理过的article_id
    processed_article_ids = []
    if os.path.exists(processed_article_ids_file):
        with open(processed_article_ids_file, 'r', encoding='utf-8') as f:
            for line in f:
                data = line.strip()
                processed_article_ids.append(data)

    # 过滤掉已经处理过的article_id
    data = [item for item in matched_data if item['article_id'] not in processed_article_ids]

    for item in tqdm(data, total=len(data)):
        article_id = item['article_id']
        text_list = item['text_list']
        article_content = '\n'.join(text_list)

        # 使用RecursiveCharacterTextSplitter分割文本，按换行符分割
        text_splitter = RecursiveCharacterTextSplitter(
            separators=[
                "\n\n",
                "\n",
                ". ",
                ", ",
                ".",
                ",",
                "\u3002",  # Ideographic full stop
                "\uff0e",  # Fullwidth full stop
                "\uff0c",  # Fullwidth comma#
                "\u3001",  # Ideographic comma
            ],
            chunk_size=CHUNK_SIZE,  # 设置合适的chunk大小
            chunk_overlap=0,  # 设置重叠部分为0
            length_function=count_tokens,
        )
        text_chunks = text_splitter.split_text(article_content)

        # 收集所有chunk的entities结果
        all_chunk_entities = []

        # 遍历每个文本块进行处理
        ask_gpt(all_chunk_entities, api_key, article_id, max_attempts, prompt_path, text_chunks)

        # 如果第一次问的后没有结果就再问一遍
        if not all_chunk_entities and len(article_content.strip()) > 30:
            logger.info(f" article_id :{article_id},第一次处理没有结果，重试一遍")
            ask_gpt(all_chunk_entities, api_key, article_id, max_attempts, prompt_path, text_chunks)

        # 所有chunk处理完成后，将收集的entities传给run_prompt
        run_prompt(article_id, text_list, all_chunk_entities, output_file, processed_article_ids_file)


def ask_gpt(all_chunk_entities, api_key, article_id, max_attempts, prompt_path, text_chunks):
    for chunk_index, chunk_text in enumerate(text_chunks):
        success = False
        attempts = 0
        assembled_prompt = assemble_prompt(chunk_text, prompt_path)  # 拼凑当前示例的prompt
        print(f"Processing article_id: {article_id}, chunk {chunk_index + 1}/{len(text_chunks)}")
        print(assembled_prompt)

        while not success and attempts < max_attempts:  # 最多尝试
            try:
                if MODEL_NAME == 'gpt-4o':
                    client = AzureOpenAI(
                        azure_endpoint=END_POINT,
                        api_key=api_key,
                        api_version="2024-02-01",
                    )
                    chat_completion = client.chat.completions.create(
                        model="gpt-4o",  # model = "deployment_name".
                        messages=[
                            {"role": "user", "content": assembled_prompt}
                        ],
                        max_completion_tokens=16 * 1000,
                        temperature=0.1,
                    )
                elif MODEL_NAME == 'official-deepseek-v3':
                    client = OpenAI(
                        base_url=END_POINT,
                        api_key=api_key
                    )
                    chat_completion = client.chat.completions.create(
                        model="deepseek-chat",  # model = "deployment_name".
                        messages=[
                            {"role": "user", "content": assembled_prompt}
                        ],
                        temperature=0.1,
                    )
                elif MODEL_NAME == 'maas-deepseek-v3':
                    client = OpenAI(
                        base_url=END_POINT,
                        api_key=api_key
                    )
                    chat_completion = client.chat.completions.create(
                        model="DeepSeek-V3",  # model = "deployment_name".
                        messages=[
                            {"role": "user", "content": assembled_prompt}
                        ],
                        temperature=0.1,
                    )
                else:
                    # 写日志不支持的模型，然后整个程序直接停止kill
                    logger.error(f"系统暂未支持的模型：{MODEL_NAME}")
                    sys.exit(1)
                # 记录token使用量并立即写入文件
                if hasattr(chat_completion, 'usage') and chat_completion.usage:
                    prompt_tokens = chat_completion.usage.prompt_tokens
                    completion_tokens = chat_completion.usage.completion_tokens
                    total_tokens = chat_completion.usage.total_tokens
                    write_token_count(prompt_tokens, completion_tokens, total_tokens)

                prompt_result = chat_completion.choices[0].message.content  # 接收LLM生成的内容
                logger.info(f" article_id :{article_id}, chunk {chunk_index + 1},的模型回复是: \n{prompt_result}")

                # 直接解析JSON获取entities
                match = prompt_result.strip().strip('```json').strip('```')
                if match:
                    try:
                        entities = json.loads(match)
                        # 收集当前chunk的entities
                        all_chunk_entities.extend(entities)
                        success = True  # 如果没有异常发生，设置成功标志为True
                    except json.decoder.JSONDecodeError as e:
                        logger.error(f"article_id :{article_id}, chunk {chunk_index + 1}, JSON 解析错误: {e}")
                        attempts += 1
                        time.sleep(20)
                        continue
                else:
                    logger.error(f"article_id :{article_id}, chunk {chunk_index + 1}, 没有找到符合条件的JSON内容")
                    attempts += 1
                    time.sleep(20)
                    continue
            except Exception as e:
                attempts += 1
                time.sleep(20)
                logger.error(e.status_code if hasattr(e, 'status_code') else "")
                logger.error(e.response if hasattr(e, 'response') else str(e))

        if not success:  # 如果最大尝试次数还是没成功，程序推出
            logger.error("Too many failures, stopping the process.")
            sys.exit(1)
            break  # 退出循环


def main(dir_path, api_key, max_attempts):
    """主函数，处理AI标注并在完成后调用process.py进行后处理

    Args:
        dir_path: 工作目录路径
        api_key: Azure OpenAI API密钥
        max_attempts: 最大尝试次数
    """
    # 设置日志
    logger.remove()  # 移除默认处理程序
    log_file = os.path.join(dir_path, "run.log")

    # 添加文件日志处理器（实时输出）
    logger.add(
        log_file,
        format="{time:YYYY-MM-DD HH:mm:ss} | {level} | {message}",
        buffering=1,  # 设置缓冲区大小为1，实现实时输出
        catch=True  # 捕获异常
    )

    # 设置文件路径
    article_json = os.path.join(dir_path, "input_article.json")
    prompt_path = os.path.join(dir_path, "prompt.txt")
    processed_txt = os.path.join(dir_path, "interrupt.txt")
    output_file = os.path.join(dir_path, "gpt_result.json")

    # 读取文章数据
    with open(article_json, 'r', encoding='utf-8') as json_file:
        data = json.load(json_file)

    # 处理数据 - AI标注阶段
    logger.info("开始AI标注阶段")
    extract_id_txt(data, prompt_path, processed_txt, output_file, api_key, max_attempts)
    logger.info("AI标注阶段完成")

    # 处理完成后调用process.py进行后处理
    logger.info("开始数据处理阶段")
    try:
        # 直接调用process.py中的main函数
        process_main(dir_path)
        logger.info("数据处理阶段完成")
    except Exception as e:
        logger.error(f"数据处理阶段出错: {str(e)}")

    logger.info(f"所有处理完成，最终结果保存在: {os.path.join(dir_path, 'processed_result.json')}")


if __name__ == "__main__":
    args = parse_args()
    MODEL_NAME = args.model_name
    END_POINT = args.end_point
    API_KEY = args.api_key
    DIR_PATH = args.input_dir

    main(args.input_dir, API_KEY, args.max_attempts)
