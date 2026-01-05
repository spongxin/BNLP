# BNLP 部署文档

## 一、环境要求

### 1.1 硬件要求

- CPU: 4核及以上
- 内存: 8GB及以上
- 磁盘空间: 50GB及以上（用于存储数据和日志）

### 1.2 软件要求

- 操作系统: Linux（推荐 Ubuntu 20.04+）
- Docker: 26.0.0 及以上版本
- Docker Compose: 2.26.0 及以上版本

### 1.3 网络要求

- 确保服务器防火墙开放 8081 端口（Nginx 服务端口）
- 确保服务器可以访问外网（用于拉取 Docker 镜像）

## 二、前置条件

### 2.1 安装 Docker 和 Docker Compose

请根据您的操作系统，参考以下官方文档进行安装：

#### Docker 安装

- **Ubuntu**: https://docs.docker.com/engine/install/ubuntu/
- **其他 Linux 发行版**: https://docs.docker.com/engine/install/

#### Docker Compose 安装

- **Docker Compose 插件（推荐）**: https://docs.docker.com/compose/install/linux/
- **独立版 Docker Compose**: https://docs.docker.com/compose/install/standalone/

**注意**：

- Docker Compose 2.26.0 及以上版本要求 Docker Engine 26.0.0 或更高版本
- 建议安装 Docker Compose 插件版本（作为 Docker CLI 的子命令 `docker compose`）
- 安装完成后，请确保 Docker 服务已启动并设置为开机自启

### 2.2 验证安装

```bash
# 验证 Docker 安装
docker --version

# 验证 Docker Compose 安装
docker compose version

# 测试 Docker 是否正常运行
docker run hello-world
```

## 三、安装步骤

### 3.1 准备部署目录

```bash
# 进入部署目录
cd /path/to/bnlp-server/deploy/bnlp-app
```

### 3.2 配置文件说明

#### 3.2.1 docker-compose.yml

该文件定义了以下服务：

- **bnlp-nginx**: Nginx 反向代理服务器，端口 8081
- **bnlp-redis**: Redis 缓存服务，端口 6379
- **bnlp-mysql**: MySQL 数据库服务，端口 3306
- **bnlp-mongo**: MongoDB 数据库服务，端口 27017
- **bnlp-tomcat**: Tomcat 应用服务器，端口 8080

#### 3.2.2 数据库配置

- MySQL 数据库名: bnlp
- MySQL root 密码: bnlp123456
- MongoDB root 用户名: root
- MongoDB root 密码: root123456

#### 3.2.3 数据持久化

以下目录将自动创建并用于数据持久化：

- `./mysql/db`: MySQL 数据文件
- `./mysql/logs`: MySQL 日志文件
- `./redis/data`: Redis 数据文件
- `./mongo/data`: MongoDB 数据文件
- `./mongo/backup`: MongoDB 备份文件
- `./webdata/data`: 应用数据文件（附件、脚本等）

### 3.3 配置应用参数（可选）

如果需要修改应用配置，可以编辑以下文件：

修改后需要重新打包应用并更新 war 包。

#### 直接修改 war 包中的配置文件

```bash
# 进入 tomcat webapps 目录
cd ./tomcat/webapps

# 解压 war 包
unzip bnlp-api.war -d bnlp-api

# 修改配置文件（包括JWT密钥、邮箱服务等）
vi bnlp-api/WEB-INF/classes/application.yml
vi bnlp-api/WEB-INF/classes/application-docker.yml

# 重新打包（可选）
cd bnlp-api
zip -r ../bnlp-api.war *
cd ..
rm -rf bnlp-api
```

### 3.4 设置脚本执行权限

```bash
# 为启动脚本添加执行权限
chmod +x start_docker_compose.sh

# 为停止脚本添加执行权限
chmod +x stop_remove_compose.sh
```

### 3.5 准备应用文件

确保以下目录和文件存在：

- `./tomcat/webapps/`: 放置应用的 war 包
- `./nginx/conf/conf.d/`: Nginx 配置文件
- `./nginx/conf/nginx.conf`: Nginx 主配置文件
- `./nginx/html/`: 静态资源文件
- `./mysql/init/`: MySQL 初始化脚本

## 四、启动方法

### 4.1 启动所有服务

```bash
# 执行启动脚本
./start_docker_compose.sh
```

启动脚本会：

1. 在后台启动所有 Docker Compose 服务
2. 将输出日志重定向到 `compose-run.log` 文件
3. 将进程 ID 保存到 `compose-run.pid` 文件

### 4.2 查看启动日志

```bash
# 查看启动日志
tail -f compose-run.log

# 或者使用 Docker Compose 查看所有服务日志
docker compose logs -f
```

### 4.3 检查服务状态

```bash
# 查看所有容器状态
docker compose ps

# 查看特定服务状态
docker compose ps bnlp-mysql
docker compose ps bnlp-mongo
docker compose ps bnlp-tomcat
```

### 4.4 等待服务完全启动

服务启动顺序：MySQL → Redis → MongoDB → Tomcat → Nginx

**重要提示**：

- MySQL 和 MongoDB 首次启动可能需要 1-2 分钟进行初始化
- 如果 MySQL 或 MongoDB 未完全启动就启动 Tomcat，可能导致应用连接数据库失败
- 如果发现 Tomcat 启动失败或应用无法访问数据库，请等待 1-2 分钟后重启 Tomcat 服务

重启 Tomcat 服务的方法：

```bash
# 重启 Tomcat 容器
docker compose restart bnlp-tomcat

# 查看重启后的日志
docker compose logs -f bnlp-tomcat
```

### 4.5 验证服务是否正常运行

#### 4.5.1 检查容器状态

```bash
docker compose ps
```

所有服务的 Status 应该显示为 "Up"。

#### 4.5.2 测试数据库连接

```bash
# 测试 MySQL 连接
docker exec -it bnlp-mysql mysql -uroot -pbnlp123456 -e "SHOW DATABASES;"

# 测试 MongoDB 连接
docker exec -it bnlp-mongo mongo -uroot -proot123456 --eval "db.adminCommand('listDatabases')"
```

#### 4.5.3 测试 Redis 连接

```bash
docker exec -it bnlp-redis redis-cli ping
# 应返回 PONG
```

#### 4.5.4 访问应用

在浏览器中访问：`http://服务器IP:8081/bnlp-v3/login`

#### 4.5.5 用户密码

**系统内置默认用户**：

| 用户角色       | 用户名   | 密码     | 说明               |
|------------|-------|--------|------------------|
| 超级管理员      | admin | 123456 | 拥有系统所有权限         |
| 项目管理员/标注员等 | test1 | 123456 | 可进行项目管理、标注、审核等操作 |
| 项目管理员/标注员等 | test2 | 123456 | 可进行项目管理、标注、审核等操作 |

**安全提示**：

- 首次登录后，请立即修改默认密码
- 建议定期更换密码以确保系统安全
- 生产环境中应删除或禁用测试账号

## 五、停止与卸载流程

### 5.1 停止所有服务

```bash
# 执行停止脚本
./stop_remove_compose.sh
```

停止脚本会：

1. 停止所有运行中的服务
2. 删除已停止的容器

### 5.2 仅停止服务（不删除容器）

```bash
docker compose stop
```

### 5.3 重启服务

```bash
# 重启所有服务
docker compose restart

# 重启特定服务
docker compose restart bnlp-tomcat
```

### 5.4 完全卸载（包括数据）

**警告**：以下操作将删除所有数据，请谨慎操作！

```bash
# 停止并删除所有容器、网络
docker compose down

# 删除所有数据卷（会删除所有数据）
docker compose down -v

# 删除所有镜像（可选）
docker rmi nginx:1.24 redis:6.2 mysql:5.7.44 mongo:4.4 tomcat:8.5-jdk8-temurin-jammy

# 手动删除数据目录
rm -rf ./mysql/db ./mysql/logs
rm -rf ./redis/data
rm -rf ./mongo/data ./mongo/backup
rm -rf ./webdata/data
```

## 六、常见问题排查

### 6.1 容器启动失败

#### 问题：容器无法启动

```bash
# 查看容器日志
docker compose logs [服务名]

# 示例：查看 Tomcat 日志
docker compose logs bnlp-tomcat
```

#### 常见原因和解决方案：

1. **端口被占用**
   ```bash
   # 检查端口占用
   netstat -tlnp | grep 8081
   # 修改 docker-compose.yml 中的端口映射
   ```

2. **磁盘空间不足**
   ```bash
   # 检查磁盘空间
   df -h
   # 清理未使用的 Docker 资源
   docker system prune -a
   ```

3. **内存不足**
   ```bash
   # 检查内存使用
   free -h
   # 停止不必要的容器
   docker stop [容器名]
   ```

### 6.2 数据库连接失败

#### 问题：应用无法连接到 MySQL 或 MongoDB

**原因**：数据库服务未完全启动

**解决方案**：

```bash
# 检查数据库容器状态
docker compose ps bnlp-mysql bnlp-mongo

# 查看数据库启动日志
docker compose logs bnlp-mysql
docker compose logs bnlp-mongo

# 等待 1-2 分钟后重启 Tomcat
docker compose restart bnlp-tomcat
```

### 6.3 应用无法访问

#### 问题：浏览器无法访问 http://服务器IP:8081

**排查步骤**：

1. 检查 Nginx 容器状态
   ```bash
   docker compose ps bnlp-nginx
   ```

2. 检查 Nginx 日志
   ```bash
   docker compose logs bnlp-nginx
   ```

3. 检查防火墙设置
   ```bash
   # Ubuntu/Debian
   sudo ufw status
   sudo ufw allow 8081/tcp

   # CentOS/RHEL
   sudo firewall-cmd --list-all
   sudo firewall-cmd --permanent --add-port=8081/tcp
   sudo firewall-cmd --reload
   ```

4. 检查 Nginx 配置文件
   ```bash
   cat ./nginx/conf/conf.d/*.conf
   ```

### 6.4 Tomcat 启动失败

#### 问题：Tomcat 容器启动后立即停止

**排查步骤**：

1. 查看 Tomcat 日志
   ```bash
   docker compose logs bnlp-tomcat
   ```

2. 检查 war 包是否存在
   ```bash
   ls -la ./tomcat/webapps/
   ```

3. 检查 Tomcat 配置文件
   ```bash
   cat ./tomcat/conf/server.xml
   ```

4. 检查应用日志
   ```bash
   tail -f ./tomcat/logs/catalina.out
   ```

### 6.5 数据持久化问题

#### 问题：重启容器后数据丢失

**原因**：数据卷未正确挂载

**解决方案**：

1. 检查数据卷挂载配置
   ```bash
   docker inspect bnlp-mysql | grep -A 10 Mounts
   ```

2. 确保数据目录存在且有正确权限
   ```bash
   ls -la ./mysql/db ./redis/data ./mongo/data
   ```

3. 检查数据目录内容
   ```bash
   ls -la ./mysql/db/bnlp/
   ```

### 6.6 性能问题

#### 问题：应用响应缓慢

**排查步骤**：

1. 检查容器资源使用情况
   ```bash
   docker stats
   ```

2. 检查数据库性能
   ```bash
   # MySQL 慢查询
   docker exec -it bnlp-mysql mysql -uroot -pbnlp123456 -e "SHOW VARIABLES LIKE 'slow_query%';"

   # 检查 Redis 性能
   docker exec -it bnlp-redis redis-cli info stats
   ```

3. 检查磁盘 I/O
   ```bash
   iostat -x 1 5
   ```

4. 检查网络连接
   ```bash
   netstat -an | grep ESTABLISHED | wc -l
   ```

### 6.7 日志文件过大

#### 问题：日志文件占用过多磁盘空间

**解决方案**：

1. 清理 Docker 日志
   ```bash
   # 清理所有容器日志
   docker compose down
   docker system prune -a

   # 或者手动清理日志文件
   rm -f ./tomcat/logs/*.log
   rm -f ./nginx/log/*.log
   ```

2. 配置日志轮转（推荐）
   ```bash
   # 在 docker-compose.yml 中添加日志配置
   services:
     bnlp-tomcat:
       logging:
         driver: "json-file"
         options:
           max-size: "10m"
           max-file: "3"
   ```

## 七、维护建议

### 7.1 定期备份

```bash
# 备份 MySQL 数据
docker exec bnlp-mysql mysqldump -uroot -pbnlp123456 bnlp > backup_$(date +%Y%m%d).sql

# 备份 MongoDB 数据
docker exec bnlp-mongo mongodump -uroot -proot123456 --archive=/backup/mongo_backup_$(date +%Y%m%d).archive

# 备份应用数据
tar -czf data_backup_$(date +%Y%m%d).tar.gz ./webdata/data
```

### 7.2 监控服务状态

```bash
# 创建监控脚本
cat > monitor.sh << 'EOF'
#!/bin/bash
while true; do
    echo "=== $(date) ==="
    docker compose ps
    echo ""
    sleep 60
done
EOF

chmod +x monitor.sh
./monitor.sh
```

### 7.3 定期更新

```bash
# 拉取最新镜像
docker compose pull

# 重新创建容器
docker compose up -d
```

## 八、技术支持

如遇到其他问题，请：

1. 查看相关日志文件
2. 检查 Docker 和系统日志
3. 参考本文档的常见问题排查章节

---

**文档版本**: 1.0
