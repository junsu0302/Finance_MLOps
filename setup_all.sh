#!/bin/bash

echo "1. /etc/hosts 설정 중..."
sudo ./update_hosts.sh || { echo "❌ update_hosts.sh 실패"; exit 1; }

echo "2. Docker Compose 서비스 시작 중..."
docker compose up -d --build || { echo "❌ docker-compose 실행 실패"; exit 1; }

echo "3. GitLab 기동 대기 중... (sleep 60)"
sleep 60

echo "4. GitLab 데이터베이스 초기화(setup) 중..."
sudo ./set_gitlab_db.sh || { echo "❌ set_gitlab_db.sh 실행 실패"; exit 1; }

echo "✅ 모든 설정 완료! 브라우저에서 http://gitlab.mlops.io:8929 로 접속해보세요."