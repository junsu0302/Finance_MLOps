# 🧱 GitLab 오프라인 개발 환경 구축 가이드

---

## 🎯 목적

- 외부 인터넷과 완전히 단절된 환경에서도 **GitLab을 온전히 활용**할 수 있도록 구축
- 금융/보안 프로젝트와 같이 **폐쇄망 내에서 Git 기반 CI/CD 운영**
- Docker-out-of-Docker(DooD) 환경을 고려한 **컨테이너 간 연결 방식 학습**

---

## 📦 전체 구성 개요

- `docker-compose.yml`: GitLab + Postgres + Redis + GitLab Runner 정의
- `setup_all.sh`: 전체 자동 설치 스크립트
- `set_gitlab_db.sh`: GitLab DB 초기화 자동 응답 처리
- `update_hosts.sh`: 도메인 수동 매핑
- `./docker-data/`: GitLab/DB/Redis 영속 데이터 저장소

---

## 📘 선행 개념 정리

### ✅ Docker Compose
- 여러 컨테이너 서비스를 한 번에 정의하고 실행할 수 있는 툴

### ✅ GitLab Omnibus
- GitLab 서비스, DB, Redis 등을 하나로 통합한 All-in-One 이미지

### ✅ DooD (Docker-out-of-Docker)
- GitLab Runner가 **호스트 Docker 데몬을 직접 사용**하도록 구성
- `/var/run/docker.sock`을 컨테이너에 마운트하여 사용

### ✅ /etc/hosts
- 도메인 주소를 IP로 수동 매핑하여 내부 서비스 접속 가능

---

## ⚙️ 파일별 역할 요약

### `docker-compose.yml`

```yaml
services:
  gitlab:
    image: gitlab/gitlab-ce:latest
    ports:
      - "8929:8929"
      - "9022:22"
    volumes:
      - ./docker-data/gitlab/config:/etc/gitlab
      - ./docker-data/gitlab/logs:/var/log/gitlab
      - ./docker-data/gitlab/data:/var/opt/gitlab
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.mlops.io:8929'
        ...
    depends_on:
      - postgres
      - redis
```

- 외부 포트: 8929 (웹), 9022 (SSH)
- 내부 DB, Redis 연결 설정 포함

---

### `update_hosts.sh`

- 도메인을 수동으로 `/etc/hosts`에 등록 (e.g. `gitlab.mlops.io`)
- 로컬에서 도메인 이름으로 접속 가능하게 함

```bash
127.0.0.1 gitlab.mlops.io
```

---

### `setup_all.sh`

- 전체 자동 실행 스크립트
1. `/etc/hosts` 설정
2. `docker compose up`
3. `sleep`으로 GitLab 기동 대기
4. DB 자동 초기화 (`set_gitlab_db.sh` 호출)

---

### `set_gitlab_db.sh`

- GitLab 최초 실행 시 필요한 DB 초기화를 자동으로 수행
- `yes yes | gitlab-rake gitlab:setup`으로 수동 입력 방지

---

## 🚀 실행 방법

### 🔹 최초 1회

```bash
sudo chmod +x *.sh
sudo ./setup_all.sh
```

### 🔁 이후 재시작

```bash
docker compose up -d
```

---

## 🛠 컨테이너 유지보수

- 중지: `docker compose down`
- 완전 제거 + 데이터 삭제:

```bash
docker compose down -v
rm -rf ./docker-data
```

---

## 💾 Git 커밋 예시

```bash
git init
git add .
git commit -m "[infra] GitLab 오프라인 개발 환경 구축"
```

---

## 📚 추가 학습 주제

- GitLab CI/CD 파이프라인 구성
- GitLab Runner 등록 및 태그 전략
- `gitlab.rb`를 통한 세부 설정
- GitLab 백업 및 복구
- GitLab 내부 Docker Registry 설정
- 사용자 초기 비밀번호 확인

```bash
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```
