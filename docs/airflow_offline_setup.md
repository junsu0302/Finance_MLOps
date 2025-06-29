# Airflow 오프라인 개발 환경 구축 가이드

---

## 목적

- 보안상 인터넷 접속이 제한된 환경에서 Airflow + Celery 기반 워크플로우 관리 시스템 구축
- GitLab과 연동 가능한 오프라인 DAG 개발 환경 제공
- ML 패키지 및 데이터 배열 라이브러리까지 사전 설치한 이미지 구성

---

## 전체 구조

- `docker-compose.yml`: Airflow 구성 요소 init, scheduler, webserver, worker, triggerer 등 하위 서비스 구현
- `Dockerfile`: ML/AI 패키지를 포함한 컨스턴 Airflow 이미지
- `.env`: DB 및 Web UI 계정 설정 분리
- `setup_all.sh`: GitLab과 함께 전체 환경 자동 구체
- `set_airflow.sh`: 사용자 UID 기반 권한 자동 설정
- `update_hosts.sh`: `/etc/hosts` 자동 등록

---

## 주요 파일 역할

### `docker-compose.yml`

- Airflow 구성 요소:

  - `airflow-init`: Airflow 시스템 초기화, 데이터베이스 마이그레이션 수행, 기본 관리자 계정 생성, UID 설정 반영 등 초기 환경 설정 수행
  - `airflow-scheduler`: 등록된 DAG들의 스케줄을 주기적으로 확인하고 실행 조건이 충족되면 작업을 큐에 전달
  - `airflow-webserver`: 웹 기반 UI 제공, DAG 확인, 로그 조회, 작업 수동 실행 및 관리 기능 지원
  - `airflow-worker`: 스케줄러가 전달한 작업(Task Instance)을 실제로 실행, CeleryExecutor를 사용하는 분산 실행 환경의 핵심
  - `airflow-triggerer`: Trigger Rule 기반으로 비동기 이벤트를 기다리는 작업(Deferrable Operators)을 감지하고 처리

- 건강 체크, 포트 매핑, depends_on 조건 설정
- UID 및 executor 설정 자동화

```yaml
airflow-webserver:
  ports:
    - "8080:8080"
  healthcheck:
    test: ["CMD", "curl", "--fail", "http://localhost:8080/health"]
```

---

### `Dockerfile`

- `apache/airflow:2.7.3-python3.8` 기반
- ML 패키지 포함: `tensorflow`, `xgboost`, `bentoml`, `scikit-learn`, `pandas`, 등
- `gosu`, `build-essential`, `libpq-dev` 등 비불 파택지 설치 포함

---

### `set_airflow.sh`

- 현재 사용자의 UID를 `.env`에 반영하여 Docker 내 권한 충돌 방지

---

### `setup_all.sh`

- `set_airflow.sh` → `/etc/hosts` 업데이트 → `docker compose up` → GitLab 설정 순서로 실행

---

## 실행 방법

### 최초 실행

```bash
chmod +x *.sh
sudo ./setup_all.sh
```

### 재시작

```bash
docker compose up -d
```
