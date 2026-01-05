#!/bin/bash

#停止并删除所有容器、网络
docker compose down

# 删除所有数据卷（注意：会删除所有数据）
#docker compose down -v