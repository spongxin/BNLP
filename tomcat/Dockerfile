# dev.biosino.org/bnlp/tomcat:8jre-python-241015
FROM tomcat:8.5.100-jre8-temurin-jammy
LABEL maintainer="BinYang <binyang.it@foxmail.com>"

RUN cat <<'EOF' > /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirror.nju.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirror.nju.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirror.nju.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirror.nju.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirror.nju.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirror.nju.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb https://mirror.nju.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# deb-src https://mirror.nju.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

# deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# # deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirror.nju.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# # deb-src https://mirror.nju.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOF

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -i https://mirrors.cernet.edu.cn/pypi/web/simple krippendorff numpy scipy matplotlib joblib loguru openai tqdm

WORKDIR /usr/local/tomcat

CMD ["catalina.sh", "run"]
