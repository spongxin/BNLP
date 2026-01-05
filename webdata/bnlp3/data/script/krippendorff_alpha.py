import krippendorff
import sys
import json
import numpy as np
from scipy.sparse import csr_matrix
from joblib import Parallel, delayed

# 检查每一列的类别多样性，过滤掉只有一个类别的列
def filter_single_value_columns(matrix):
    filtered_matrix = []
    for col in matrix.T:  # 遍历每一列
        unique_values = np.unique(col)
        if len(unique_values) > 1:  # 保留类别多样性大于1的列
            filtered_matrix.append(col)

    # 如果没有可用列，返回一个空的 2D 数组
    if len(filtered_matrix) == 0:
        return np.empty((matrix.shape[0], 0))

    return np.array(filtered_matrix).T  # 转置回原矩阵格式

# 计算 Krippendorff's Alpha
def compute_alpha(matrix_chunk):
    # 先过滤掉只有单一类别的列
    filtered_chunk = filter_single_value_columns(matrix_chunk)

    if filtered_chunk.shape[1] == 0:  # 如果没有可用列，返回 None
        return None

    try:
        return krippendorff.alpha(reliability_data=filtered_chunk.T, level_of_measurement='nominal')
    except Exception as e:
        # print(f"Error in alpha computation: {e}")
        return None

# 主函数
def main(large_matrix, num_chunks=1):
    # 使用稀疏矩阵表示，减少内存占用
    sparse_matrix = csr_matrix(large_matrix)

    # 将稀疏矩阵转回稠密矩阵
    dense_matrix = sparse_matrix.toarray()

    # 输出矩阵信息以便调试
    # print(f"Original matrix shape: {dense_matrix.shape}")

    # 将大矩阵分块处理
    matrix_chunks = np.array_split(dense_matrix, num_chunks)

    # 检查分块结果
    # for idx, chunk in enumerate(matrix_chunks):
    # print(f"Chunk {idx+1} shape: {chunk.shape}")

    # 使用 joblib 并行处理计算 Krippendorff's Alpha
    results = Parallel(n_jobs=-1)(delayed(compute_alpha)(chunk) for chunk in matrix_chunks)

    # 过滤掉 None 的结果，计算有效结果的平均值
    valid_results = [result for result in results if result is not None]

    if len(valid_results) == 0:
        return None

    return np.mean(valid_results)

def calculate_num_chunks(matrix_size, base_size=800):
    num_chunk = 1

    # 根据不同的倍数条件设置分块数量
    if matrix_size > base_size:
        num_chunk = 4
    if matrix_size > 2 * base_size:
        num_chunk = 8
    if matrix_size > 4 * base_size:
        num_chunk = 16
    if matrix_size > 8 * base_size:
        num_chunk = 32

    return num_chunk

if __name__ == "__main__":

    # 从文件读取 JSON 格式的矩阵
    input_file = sys.argv[1]
    with open(input_file, 'r') as f:
        json_matrix = f.read()

    # 从 JSON 字符串解析出矩阵
    matrix = json.loads(json_matrix)
    # print(matrix)
    large_matrix = np.array(matrix)

    # 计算分块数量
    num_chunk = calculate_num_chunks(large_matrix.shape[0])

    # 调用主函数，指定矩阵分成N个块
    alpha_values = main(large_matrix, num_chunks=num_chunk)

    # 输出计算结果
    print(alpha_values)
