import argparse
import json
import os
import re
from typing import List, Dict, Any, Tuple

# 变量声明
LABEL_LIST = []
ENTITY_WTIH_ATTR = []
ENTITY_ATTR_TYPE = []


# 从文件读取标签和实体列表的函数
def read_list_from_txt(file_path: str) -> List[str]:
    """从文本文件中读取列表，每行作为一个项目"""
    with open(file_path, "r", encoding="utf-8") as f:
        return [line.strip() for line in f if line.strip()]


def get_json_origin_data(file_path: str):
    with open(file_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    return data


def write_data(data: List[Dict[str, Any]], store_dir: str, file_name: str) -> None:
    if not os.path.exists(store_dir):
        os.makedirs(store_dir)
    file_path = os.path.join(store_dir, file_name)
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f'save data to {file_path}')


def split_entity(entity_str: str) -> Tuple[str, str]:
    data_output_item_list = entity_str.split(':')
    # print(data_output_item_list)
    if len(data_output_item_list) == 2:
        label = data_output_item_list[0]
        entity_name = data_output_item_list[1]
        return label, entity_name
    else:
        label = data_output_item_list[0] + ":" + data_output_item_list[1]
        entity_name = data_output_item_list[2]
        return label, entity_name


def process_entities_list(pred_entity_text: str) -> List[Dict[str, Any]]:
    entities_data_list = []
    entities_list = pred_entity_text.split("\n")
    for entity in entities_list:
        try:
            label, entity_name = split_entity(entity)
            if label in LABEL_LIST:
                data_dict = {
                    "label": label,
                    "content": entity_name
                }
                entities_data_list.append(data_dict)
        except:
            continue
    return entities_data_list


def group_entity_attr(entities_list: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    grouped_entity_list = []
    i = 0
    while i < len(entities_list):
        entity = entities_list[i]
        entity_label = entity['label']

        if entity_label in ENTITY_WTIH_ATTR:
            group_attrs = []
            j = i + 1
            while j < len(entities_list):
                attr_entity = entities_list[j]
                if attr_entity['label'].startswith(entity_label + ":"):
                    group_attrs.append(attr_entity)
                elif attr_entity['label'] in ENTITY_WTIH_ATTR:
                    break
                j += 1
            grouped_entity_list.append({
                "label": entity_label,
                "content": entity['content'],
                **({"attr_list": group_attrs} if group_attrs else {})
            })
            i += 1
        else:
            is_duplicate = False
            for grouped_entity in grouped_entity_list:
                if 'attr_list' in grouped_entity:
                    if entity in grouped_entity['attr_list']:
                        is_duplicate = True
                        break
            if is_duplicate:
                i += 1
                continue
            grouped_entity_list.append(entity)
            i += 1
    return grouped_entity_list


def match_article_id(json_data, article_id_text_dict):
    match_data_list = []
    for item in json_data:
        article_id = item['article_id']
        if article_id in article_id_text_dict:
            text_list = article_id_text_dict[article_id]
            entities_list = process_entities_list(item['entities'])
            group_entity_list = group_entity_attr(entities_list)
            match_data_list.append({
                "article_id": article_id,
                "text_list": text_list,
                "entities": group_entity_list
            })

    return match_data_list


def match_data(json_data: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    match_data_list = []
    for index, item in enumerate(json_data):
        article_id = item['article_id']
        # text_list = item['text']
        # print(article_id)
        # entities_list = process_entities_list(item['pred_entities_text'])

        text_list = item['text_list']
        entities_list = item['entities']
        group_entity_list = group_entity_attr(entities_list)
        match_data_list.append({
            "article_id": article_id,
            "text_list": text_list,
            # "pred_entities_text": item['pred_entities_text'],
            "entities": group_entity_list
        })
    return match_data_list


def process_attr_list(attr_list: List[Dict[str, Any]]) -> List[Tuple[str, str]]:
    processed_attr_list = []
    for attr_dict in attr_list:
        attr_label = attr_dict['label']
        attr_content = attr_dict['content']
        split_attr = attr_label.split(":")
        if len(split_attr) == 2:
            attr_label = split_attr[1]
        processed_attr_list.append((attr_label, attr_content))
    return processed_attr_list


def process_pred_entities(entity_dict: Dict[str, Any]) -> Tuple[str, str, List]:
    entity_label = entity_dict['label']
    entity_content = entity_dict['content']
    entity_attr = entity_dict.get('attr_list', [])
    if entity_attr:
        processed_attr_list = process_attr_list(entity_attr)
        return entity_label, entity_content, processed_attr_list
    return entity_label, entity_content, []


def BNLP_templete_json(is_attr: bool, **kwargs):
    if is_attr:
        key_attribute_data_dict = {
            "attr_name": f"{kwargs['attr_name']}",
            "attrs": [
                {
                    "entity": [
                        {
                            "text_id": 'body-' + str(kwargs['text_id']),
                            "start": kwargs['attr_start'],
                            "end": kwargs['attr_end'],
                            "content": f"{kwargs['attr_value']}"
                        }
                    ]
                }
            ]
        }
        return key_attribute_data_dict
    else:
        key_entity_data_dict = {
            "label": f"{kwargs['label']}",
            "entity": [
                {
                    "text_id": 'body-' + str(kwargs['text_id']),
                    "start": kwargs['start'],
                    "end": kwargs['end'],
                    "content": f"{kwargs['entity_name']}",
                }
            ]
        }
        return key_entity_data_dict


def entity_match_to_text(text: str, entity_content: str) -> List[tuple]:
    matches = re.finditer(re.escape(entity_content), text)
    ## plain text
    # positions = [(match.start(), match.end()) for match in matches]
    ## list transform string -- "[]"
    positions = [(match.start(), match.end()) for match in matches]
    return positions


def entity_to_json(data: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    all_data_list = []
    for item in data:
        entities_result_list = []
        article_id = item['article_id']
        text_list = item['text_list']
        predicted_entity_list = item['entities']
        entity_positon_recorded_list = []
        attr_positon_recorded_list = []

        for label_and_entity_dict in predicted_entity_list:
            for text_index, text_ in enumerate(text_list):
                entity_label, entity_content, attr_list = process_pred_entities(label_and_entity_dict)
                entity_position_index = 0
                text_id = text_index + 1

                if attr_list:
                    entity_postions_list = entity_match_to_text(text_, entity_content)
                    if not entity_postions_list:
                        continue

                    while entity_position_index < len(entity_postions_list):
                        entity_position_start = entity_postions_list[entity_position_index][0]
                        entity_position_end = entity_postions_list[entity_position_index][1]
                        if (
                                entity_content, entity_position_start,
                                entity_position_end) not in entity_positon_recorded_list:
                            break
                        entity_position_index += 1

                    if entity_position_index >= len(entity_postions_list):
                        continue

                    entity_positon_recorded_list.append((entity_content, entity_position_start, entity_position_end))
                    key_attribute_data_list = []

                    for attr_label, attr_content in attr_list:
                        attr_postions_list = entity_match_to_text(text_, attr_content)
                        if not attr_postions_list:
                            continue

                        attr_position_index = 0
                        while attr_position_index < len(attr_postions_list):
                            attr_position_start = attr_postions_list[attr_position_index][0]
                            attr_position_end = attr_postions_list[attr_position_index][1]
                            if (attr_content, attr_position_start, attr_position_end) not in attr_positon_recorded_list:
                                break
                            attr_position_index += 1

                        if attr_position_index >= len(attr_postions_list):
                            continue

                        attr_positon_recorded_list.append((attr_content, attr_position_start, attr_position_end))
                        attr_data_dict = BNLP_templete_json(True, attr_name=attr_label, text_id=text_id,
                                                            attr_start=attr_position_start, attr_end=attr_position_end,
                                                            attr_value=attr_content)
                        key_attribute_data_list.append(attr_data_dict)

                    entity_data_dict = {
                        "label": entity_label,
                        "entity": [
                            {
                                "text_id": "body-" + str(text_id),
                                "start": entity_position_start,
                                "end": entity_position_end,
                                "content": entity_content
                            }
                        ],
                        "attribute": key_attribute_data_list
                    }
                    entities_result_list.append(entity_data_dict)
                else:
                    entity_postions_list = entity_match_to_text(text_, entity_content)
                    if not entity_postions_list:
                        continue

                    while entity_position_index < len(entity_postions_list):
                        entity_position_start = entity_postions_list[entity_position_index][0]
                        entity_position_end = entity_postions_list[entity_position_index][1]
                        if (
                                entity_content, entity_position_start,
                                entity_position_end) not in entity_positon_recorded_list:
                            break
                        entity_position_index += 1

                    if entity_position_index >= len(entity_postions_list):
                        continue

                    entity_positon_recorded_list.append((entity_content, entity_position_start, entity_position_end))
                    entity_data_dict = BNLP_templete_json(False, label=entity_label, text_id=text_id,
                                                          start=entity_position_start, end=entity_position_end,
                                                          entity_name=entity_content)
                    entities_result_list.append(entity_data_dict)

        data_dict = {
            "article_id": article_id,
            "entities": entities_result_list
        }
        all_data_list.append(data_dict)

    return all_data_list


def remove_wrong_dict(data: List[Dict[str, Any]]) -> list[dict[str, Any]]:
    for item in data:
        item['entities'] = [
            data_dict for data_dict in item.get('entities', [])
            if data_dict.get('label') not in ENTITY_ATTR_TYPE
        ]
    return data


def parse_args():
    parser = argparse.ArgumentParser(description="处理AI标注数据")
    parser.add_argument("--dir", type=str, required=True,
                        help="工作目录路径")
    return parser.parse_args()


def main(dir_path):
    """主函数，处理AI标注的输出数据

    Args:
        dir_path: 工作目录路径
    """
    # 设置文件路径
    label_list_path = os.path.join(dir_path, "label_list.txt")
    entity_with_attr_path = os.path.join(dir_path, "entity_with_attr.txt")
    output_json_path = os.path.join(dir_path, "gpt_result.json")
    final_json_path = os.path.join(dir_path, "processed_result.json")

    global LABEL_LIST, ENTITY_WTIH_ATTR, ENTITY_ATTR_TYPE

    # 从文件加载列表
    LABEL_LIST = read_list_from_txt(label_list_path)
    ENTITY_WTIH_ATTR = read_list_from_txt(entity_with_attr_path)

    # 计算ENTITY_ATTR_TYPE
    ENTITY_ATTR_TYPE = []
    for e in ENTITY_WTIH_ATTR:
        for it in LABEL_LIST:
            # 如果e包含it 且it不等于e
            # 则将it添加到ENTITY_ATTR_TYPE
            if e in it and it != e:
                ENTITY_ATTR_TYPE.append(it)

    # 处理数据
    source_json_data = get_json_origin_data(output_json_path)
    match_data_list = match_data(source_json_data)
    entity_json = entity_to_json(match_data_list)

    json_without_wrong = remove_wrong_dict(entity_json)

    write_data(json_without_wrong, dir_path, "processed_result.json")
    print(f"处理完成，结果保存至: {final_json_path}")


if __name__ == "__main__":
    args = parse_args()
    main(args.dir)
