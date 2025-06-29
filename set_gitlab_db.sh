#!/bin/bash

echo "GitLab 설정 초기화 중..."
docker compose exec -T gitlab gitlab-ctl reconfigure || { echo "❌ reconfigure 실패"; exit 1; }

echo "GitLab DB 세팅 중..."
yes yes | docker compose exec -T gitlab gitlab-rake gitlab:setup || { echo "❌ gitlab:setup 실패"; exit 1; }
