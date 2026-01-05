import json
import sys

import matplotlib.pyplot as plt
import numpy as np
from scipy.cluster.hierarchy import linkage, dendrogram
from scipy.spatial.distance import squareform


def main(similarity_map, filePath):
    # 将列表转换为集合以计算Jaccard相似性
    annotators = list(similarity_map.keys())
    n = len(annotators)
    similarity_matrix = np.zeros((n, n))

    # 将数据填充到相似性矩阵中
    for i, annotator1 in enumerate(annotators):
        for j, annotator2 in enumerate(annotators):
            if annotator2 in similarity_map[annotator1]:
                similarity_matrix[i, j] = similarity_map[annotator1][annotator2]
            elif i == j:
                similarity_matrix[i, j] = 1.0  # 自身相似性为1

    # print(similarity_matrix)
    # 将相似性矩阵转换为距离矩阵
    distance_matrix = 1 - similarity_matrix

    # 使用 squareform 将距离矩阵转换为压缩格式
    condensed_distance_matrix = squareform(distance_matrix)

    # 使用层次聚类生成聚类树
    Z = linkage(condensed_distance_matrix, method='average')

    # 绘制聚类树
    plt.figure(figsize=(10, 8))
    dendro = dendrogram(Z, labels=annotators,
                        leaf_rotation=15,
                        leaf_font_size=12)

    # 在树图上显示聚类高度数值
    for i, d in zip(dendro['icoord'], dendro['dcoord']):
        x = 0.5 * sum(i[1:3])  # 计算分支中心位置
        y = d[1] - 0.03  # 获取聚类高度
        plt.text(x, y, f'{y + 0.03:.2f}', va='bottom', ha='center')

    # # 固定纵坐标范围为 [0, 1]
    plt.ylim(0, 1)

    plt.title("Annotator Clustering Dendrogram")
    plt.xlabel("Annotators")
    plt.ylabel("Distance")
    plt.savefig(filePath)

if __name__ == "__main__":
    # 从文件读取 JSON 格式的矩阵
    input_file = sys.argv[1]
    with open(input_file, 'r') as f:
        json_matrix = f.read()

    matrix = json.loads(json_matrix)
    filePath = sys.argv[2]

    main(matrix, filePath)
