#!/bin/bash
set -euo pipefail
echo "Start program"

#nohup docker compose --compatibility up -d > compose-run.log 2>&1 & echo $! > compose-run.pid
docker compose build bnlp-tomcat
echo "Build bnlp-tomcat finish"
docker compose up -d
docker compose ps
