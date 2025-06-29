#!/bin/bash

REAL_USER="${SUDO_USER:-$(logname 2>/dev/null || echo $USER)}"
AIRFLOW_UID=$(id -u "$REAL_USER")

# .env 파일 없으면 생성
touch .env

# 줄 삭제: AIRFLOW_UID= 으로 시작하는 줄만 정확히 삭제 (POSIX 호환)
grep -vE '^AIRFLOW_UID=' .env > .env.tmp && mv .env.tmp .env

# 새 UID 추가
echo "AIRFLOW_UID=${AIRFLOW_UID}" >> .env
