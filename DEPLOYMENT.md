# BNLP Deployment Documentation

## 1. System Requirements

### 1.1 Hardware Requirements

- CPU: 4 cores or more
- Memory: 8GB or more
- Disk Space: 50GB or more (for storing data and logs)

### 1.2 Software Requirements

- Operating System: Linux (Ubuntu 20.04+ recommended)
- Docker: 26.0.0 or higher
- Docker Compose: 2.26.0 or higher

### 1.3 Network Requirements

- Ensure server firewall has port 8081 open (Nginx service port)
- Ensure server can access the internet (for pulling Docker images)

## 2. Prerequisites

### 2.1 Install Docker and Docker Compose

Please refer to the following official documentation according to your operating system:

#### Docker Installation

- **Ubuntu**: https://docs.docker.com/engine/install/ubuntu/
- **Other Linux Distributions**: https://docs.docker.com/engine/install/

#### Docker Compose Installation

- **Docker Compose Plugin (Recommended)**: https://docs.docker.com/compose/install/linux/
- **Standalone Docker Compose**: https://docs.docker.com/compose/install/standalone/

**Note**:

- Docker Compose 2.26.0 or higher requires Docker Engine 26.0.0 or higher
- It is recommended to install the Docker Compose plugin version (as a subcommand of Docker CLI `docker compose`)
- After installation, ensure Docker service is started and set to auto-start on boot

### 2.2 Verify Installation

```bash
# Verify Docker installation
docker --version

# Verify Docker Compose installation
docker compose version

# Test if Docker is running normally
docker run hello-world
```

## 3. Installation Steps

### 3.1 Prepare Deployment Directory

```bash
# Navigate to deployment directory
cd /path/to/bnlp-server/deploy/bnlp-app
```

### 3.2 Configuration Files

#### 3.2.1 docker-compose.yml

This file defines the following services:

- **bnlp-nginx**: Nginx reverse proxy server, port 8081
- **bnlp-redis**: Redis cache service, port 6379
- **bnlp-mysql**: MySQL database service, port 3306
- **bnlp-mongo**: MongoDB database service, port 27017
- **bnlp-tomcat**: Tomcat application server, port 8080

#### 3.2.2 Database Configuration

- MySQL database name: bnlp
- MySQL root password: bnlp123456
- MongoDB root username: root
- MongoDB root password: root123456

#### 3.2.3 Data Persistence

The following directories will be automatically created for data persistence:

- `./mysql/db`: MySQL data files
- `./mysql/logs`: MySQL log files
- `./redis/data`: Redis data files
- `./mongo/data`: MongoDB data files
- `./mongo/backup`: MongoDB backup files
- `./webdata/data`: Application data files (attachments, scripts, etc.)

### 3.3 Configure Application Parameters (Optional)

If you need to modify application configuration, you can edit the following files:

After modification, you need to repackage the application and update the war package.

#### Directly Modify Configuration Files in War Package

```bash
# Navigate to tomcat webapps directory
cd ./tomcat/webapps

# Extract war package
unzip bnlp-api.war -d bnlp-api

# Modify configuration files (including JWT keys, email service, etc.)
vi bnlp-api/WEB-INF/classes/application.yml
vi bnlp-api/WEB-INF/classes/application-docker.yml

# Repackage (optional)
cd bnlp-api
zip -r ../bnlp-api.war *
cd ..
rm -rf bnlp-api
```

### 3.4 Set Script Execution Permissions

```bash
# Add execution permission to start script
chmod +x start_docker_compose.sh

# Add execution permission to stop script
chmod +x stop_remove_compose.sh
```

### 3.5 Prepare Application Files

Ensure the following directories and files exist:

- `./tomcat/webapps/`: Place application war package
- `./nginx/conf/conf.d/`: Nginx configuration files
- `./nginx/conf/nginx.conf`: Nginx main configuration file
- `./nginx/html/`: Static resource files
- `./mysql/init/`: MySQL initialization scripts

## 4. Startup Instructions

### 4.1 Start All Services

```bash
# Execute startup script
./start_docker_compose.sh
```

The startup script will:

1. Start all Docker Compose services in the background
2. Redirect output logs to `compose-run.log` file
3. Save process ID to `compose-run.pid` file

### 4.2 View Startup Logs

```bash
# View startup logs
tail -f compose-run.log

# Or use Docker Compose to view all service logs
docker compose logs -f
```

### 4.3 Check Service Status

```bash
# View all container status
docker compose ps

# View specific service status
docker compose ps bnlp-mysql
docker compose ps bnlp-mongo
docker compose ps bnlp-tomcat
```

### 4.4 Wait for Services to Fully Start

Service startup order: MySQL → Redis → MongoDB → Tomcat → Nginx

**Important Note**:

- MySQL and MongoDB may take 1-2 minutes to initialize on first startup
- If Tomcat starts before MySQL or MongoDB is fully initialized, it may fail to connect to the database
- If Tomcat fails to start or cannot access the database, wait 1-2 minutes and then restart the Tomcat service

Method to restart Tomcat service:

```bash
# Restart Tomcat container
docker compose restart bnlp-tomcat

# View logs after restart
docker compose logs -f bnlp-tomcat
```

### 4.5 Verify Services are Running Normally

#### 4.5.1 Check Container Status

```bash
docker compose ps
```

All services' Status should show "Up".

#### 4.5.2 Test Database Connection

```bash
# Test MySQL connection
docker exec -it bnlp-mysql mysql -uroot -pbnlp123456 -e "SHOW DATABASES;"

# Test MongoDB connection
docker exec -it bnlp-mongo mongo -uroot -proot123456 --eval "db.adminCommand('listDatabases')"
```

#### 4.5.3 Test Redis Connection

```bash
docker exec -it bnlp-redis redis-cli ping
# Should return PONG
```

#### 4.5.4 Access Application

Access in browser: `http://ServerIP:8081/bnlp-v3/login`

#### 4.5.5 User Credentials

**System Built-in Default Users**:

| User Role | Username | Password | Description |
|-----------|----------|----------|-------------|
| Super Administrator | admin | 123456 | Has all system permissions |
| Project Manager/Annotator | test1 | 123456 | Can perform project management, annotation, review, etc. |
| Project Manager/Annotator | test2 | 123456 | Can perform project management, annotation, review, etc. |

**Security Notice**:

- Change default passwords immediately after first login
- It is recommended to change passwords regularly to ensure system security
- Test accounts should be deleted or disabled in production environment

## 5. Stop and Uninstall Process

### 5.1 Stop All Services

```bash
# Execute stop script
./stop_remove_compose.sh
```

The stop script will:

1. Stop all running services
2. Remove stopped containers

### 5.2 Stop Services Only (Without Removing Containers)

```bash
docker compose stop
```

### 5.3 Restart Services

```bash
# Restart all services
docker compose restart

# Restart specific service
docker compose restart bnlp-tomcat
```

### 5.4 Complete Uninstall (Including Data)

**Warning**: The following operations will delete all data, proceed with caution!

```bash
# Stop and remove all containers and networks
docker compose down

# Remove all volumes (will delete all data)
docker compose down -v

# Remove all images (optional)
docker rmi nginx:1.24 redis:6.2 mysql:5.7.44 mongo:4.4 tomcat:8.5-jdk8-temurin-jammy

# Manually delete data directories
rm -rf ./mysql/db ./mysql/logs
rm -rf ./redis/data
rm -rf ./mongo/data ./mongo/backup
rm -rf ./webdata/data
```

## 6. Troubleshooting

### 6.1 Container Startup Failure

#### Issue: Container fails to start

```bash
# View container logs
docker compose logs [service_name]

# Example: View Tomcat logs
docker compose logs bnlp-tomcat
```

#### Common Causes and Solutions:

1. **Port Already in Use**
   ```bash
   # Check port usage
   netstat -tlnp | grep 8081
   # Modify port mapping in docker-compose.yml
   ```

2. **Insufficient Disk Space**
   ```bash
   # Check disk space
   df -h
   # Clean up unused Docker resources
   docker system prune -a
   ```

3. **Insufficient Memory**
   ```bash
   # Check memory usage
   free -h
   # Stop unnecessary containers
   docker stop [container_name]
   ```

### 6.2 Database Connection Failure

#### Issue: Application cannot connect to MySQL or MongoDB

**Cause**: Database service not fully started

**Solution**:

```bash
# Check database container status
docker compose ps bnlp-mysql bnlp-mongo

# View database startup logs
docker compose logs bnlp-mysql
docker compose logs bnlp-mongo

# Wait 1-2 minutes and restart Tomcat
docker compose restart bnlp-tomcat
```

### 6.3 Application Not Accessible

#### Issue: Browser cannot access http://ServerIP:8081

**Troubleshooting Steps**:

1. Check Nginx container status
   ```bash
   docker compose ps bnlp-nginx
   ```

2. Check Nginx logs
   ```bash
   docker compose logs bnlp-nginx
   ```

3. Check firewall settings
   ```bash
   # Ubuntu/Debian
   sudo ufw status
   sudo ufw allow 8081/tcp

   # CentOS/RHEL
   sudo firewall-cmd --list-all
   sudo firewall-cmd --permanent --add-port=8081/tcp
   sudo firewall-cmd --reload
   ```

4. Check Nginx configuration files
   ```bash
   cat ./nginx/conf/conf.d/*.conf
   ```

### 6.4 Tomcat Startup Failure

#### Issue: Tomcat container stops immediately after starting

**Troubleshooting Steps**:

1. View Tomcat logs
   ```bash
   docker compose logs bnlp-tomcat
   ```

2. Check if war package exists
   ```bash
   ls -la ./tomcat/webapps/
   ```

3. Check Tomcat configuration files
   ```bash
   cat ./tomcat/conf/server.xml
   ```

4. Check application logs
   ```bash
   tail -f ./tomcat/logs/catalina.out
   ```

### 6.5 Data Persistence Issues

#### Issue: Data lost after restarting containers

**Cause**: Volumes not properly mounted

**Solution**:

1. Check volume mount configuration
   ```bash
   docker inspect bnlp-mysql | grep -A 10 Mounts
   ```

2. Ensure data directories exist with correct permissions
   ```bash
   ls -la ./mysql/db ./redis/data ./mongo/data
   ```

3. Check data directory contents
   ```bash
   ls -la ./mysql/db/bnlp/
   ```

### 6.6 Performance Issues

#### Issue: Application responds slowly

**Troubleshooting Steps**:

1. Check container resource usage
   ```bash
   docker stats
   ```

2. Check database performance
   ```bash
   # MySQL slow queries
   docker exec -it bnlp-mysql mysql -uroot -pbnlp123456 -e "SHOW VARIABLES LIKE 'slow_query%';"

   # Check Redis performance
   docker exec -it bnlp-redis redis-cli info stats
   ```

3. Check disk I/O
   ```bash
   iostat -x 1 5
   ```

4. Check network connections
   ```bash
   netstat -an | grep ESTABLISHED | wc -l
   ```

### 6.7 Large Log Files

#### Issue: Log files consuming too much disk space

**Solution**:

1. Clean Docker logs
   ```bash
   # Clean all container logs
   docker compose down
   docker system prune -a

   # Or manually clean log files
   rm -f ./tomcat/logs/*.log
   rm -f ./nginx/log/*.log
   ```

2. Configure log rotation (recommended)
   ```bash
   # Add log configuration in docker-compose.yml
   services:
     bnlp-tomcat:
       logging:
         driver: "json-file"
         options:
           max-size: "10m"
           max-file: "3"
   ```

## 7. Maintenance Recommendations

### 7.1 Regular Backups

```bash
# Backup MySQL data
docker exec bnlp-mysql mysqldump -uroot -pbnlp123456 bnlp > backup_$(date +%Y%m%d).sql

# Backup MongoDB data
docker exec bnlp-mongo mongodump -uroot -proot123456 --archive=/backup/mongo_backup_$(date +%Y%m%d).archive

# Backup application data
tar -czf data_backup_$(date +%Y%m%d).tar.gz ./webdata/data
```

### 7.2 Monitor Service Status

```bash
# Create monitoring script
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

### 7.3 Regular Updates

```bash
# Pull latest images
docker compose pull

# Recreate containers
docker compose up -d
```

## 8. Technical Support

If you encounter other issues, please:

1. Review relevant log files
2. Check Docker and system logs
3. Refer to the troubleshooting section of this documentation

---

**Document Version**: 1.0

