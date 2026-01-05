# BNLP：系统化的大语言模型辅助协同标注平台

[English Documentation](README.md) | [部署指南](DEPLOYMENT_zh.md)

**BNLP** 是一个自然语言标注平台，旨在将大语言模型（LLMs）系统化地嵌入到可控、可评估、可复现的人机协同工作流中。通过将 LLM 输出作为人工精炼的中间状态，BNLP 弥合了原始 AI 生成结果与高质量"黄金标准"数据之间的差距。

![](resources/image.jpg)
![](resources/image-2.jpg)


## 🚀 核心特性

* **质量感知的 LLM 工作流**：集成 LLM 预标注与多角色人工验证。
* **"标注–训练–评估"闭环**：随着黄金数据的积累，支持从通用 LLM 演化到领域专用小模型（如 BioBERT）。
* **复杂语义支持**：原生支持不连续实体、重叠/嵌套命名实体识别、有向关系三元组和属性绑定。
* **集成质量控制**：实时计算 **Fleiss' Kappa** 和 **Krippendorff's Alpha** 标注者间一致性（IAA）指标。
* **无缝数据管道**：直接兼容 Excel（用于人工管理）和 JSON（用于模型训练）。

---

## 🛠 系统架构

BNLP 采用现代化解耦架构，确保可扩展性和易部署性：

* **前端**：Vue.js + Element UI（响应式、基于角色的视图）。
* **后端**：Spring Boot（RESTful API，Spring Security）。
* **存储**：
  * **MongoDB**：灵活存储复杂的 JSON 文档标注。
  * **MySQL**：结构化管理用户、权限和项目元数据。
  * **Redis**：缓存和会话管理。


* **部署**：通过 **Docker Compose** 完全容器化。

---

## 📊 性能一览

在针对"药食同源"知识抽取的案例研究中：

| 指标 | 人工标注 | 仅 LLM | **BNLP（LLM + 人工）** |
| --- | --- | --- | --- |
| **F1 分数** | 80.16% | 70.42% | **97.92%** |
| **速度提升** | 基准线 | 98.1% ↑ | **64% ↑** |
| **质量** | 基准线 | -9.74% ↓ | **22.15% ↑** |

> **注意**：与 Brat、YEDDA 和 INCEpTION 等工具相比，BNLP 平均标注时间减少 **22.5% 到 38.9%**。

---

## 📖 功能对比

| 功能 | Brat | Doccano | TeamTat | **BNLP** |
| --- | --- | --- | --- | --- |
| **LLM 预标注** | ❌ | ⚠️ (外部) | ❌ | ✅ |
| **不连续实体** | ✅ | ❌ | ✅ | ✅ |
| **Excel 上传/导出** | ❌ | ❌ | ❌ | ✅ |
| **IAA 统计（Kappa）** | ❌ | ❌ | ✅ | ✅ |
| **模型演化闭环** | ❌ | ❌ | ❌ | ✅ |

---

## 💻 快速开始

### 前置要求

* Docker & Docker Compose
* OpenAI API Key（或本地 LLM 端点）

### 安装步骤

1. 克隆仓库：
```bash
git clone https://github.com/YourRepo/BNLP.git
cd BNLP

```


2. 在 `.env` 文件中配置环境变量。
3. 使用 Docker 启动：
```bash
docker-compose up -d

```


4. 在浏览器中访问 `http://localhost:8080`。

---

## 📜 引用

如果您在研究中使用 BNLP，请引用我们的工作：

```bibtex
@article{BNLP2026,
  title={BNLP: A Systematic LLM-Assisted Platform for High-Quality Natural Language Annotation},
  author={Zhuang, Xinhao and Tian, Qiongyu and et al.},
  year={2026}
}

```
