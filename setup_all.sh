#!/bin/bash

echo "1. Airflow 초기화 중..."
./set_airflow.sh || { echo "❌ set_airflow.sh 실패"; exit 1; }

echo "2. /etc/hosts 설정 중..."
sudo ./update_hosts.sh || { echo "❌ update_hosts.sh 실패"; exit 1; }

echo "3. Docker Compose 서비스 실행 중..."
docker compose up -d --build || { echo "❌ docker-compose 실행 실패"; exit 1; }

echo "4. GitLab DB 세팅 중..."
sudo ./set_gitlab_db.sh || { echo "❌ set_gitlab_db.sh 실패"; exit 1; }

echo "5. GitLab 기동 대기 중 (2분)..."
sleep 120

echo "✅ 모든 구성 완료!"
echo "🔗 GitLab:   http://gitlab.mlops.io:8929"
echo "🔗 Airflow:  http://airflow.mlops.io:8080"
