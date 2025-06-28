#!/bin/bash

# /etc/hosts : 도메인 이름과 IP 주소의 매핑을 수동으로 정의하는 파일

# 각 서비스를 도메인으로 분리
# - 프록시 서버가 트래픽을 라우팅하기 쉬움
# - 서비스 구분 명확화

# 1. 백업: 실수로 시스템 파일을 망가뜨릴 수 있으므로 원본을 백업
cp /etc/hosts /etc/hosts.bak

# 2. 매핑할 도메인과 IP 주소를 배열로 선언
#    여기서는 모든 도메인을 127.0.0.1 (본인 컴퓨터)로 연결
HOST_ENTRIES=(
"127.0.0.1 jupyter.mlops.io"            # 주피터 노트북 서비스 도메인
"127.0.0.1 gitlab.mlops.io"             # GitLab 저장소 도메인
"127.0.0.1 docker-registry.mlops.io"    # 도커 레지스트리 (이미지 저장소) 도메인
"127.0.0.1 airflow.mlops.io"            # Airflow 스케줄러 도메인
"127.0.0.1 airflow-worker.mlops.io"     # Airflow 워커 노드 도메인
)

# 3. 배열에 담긴 각 도메인에 대해 /etc/hosts 파일을 수정
#    이미 있는 도메인 라인은 삭제하고, 새로운 내용을 추가
for entry in "${HOST_ENTRIES[@]}"; do
  # entry = "127.0.0.1 jupyter.mlops.io" 와 같은 형식
  DOMAIN=$(echo $entry | awk '{print $2}')   # 도메인 이름만 추출

  # 기존에 같은 도메인이 있을 경우 삭제 (중복 방지)
  sudo sed -i.bak "/$DOMAIN/d" /etc/hosts

  # 새로운 IP-도메인 매핑을 /etc/hosts 파일의 끝에 추가
  echo "$entry" | sudo tee -a /etc/hosts > /dev/null
done

# 4. 완료 메시지 출력
echo "✅ /etc/hosts 업데이트 완료 - 도메인 이름을 브라우저에서 사용할 수 있습니다."

# 파일 실행
# chmod +x update_hosts.sh
# sudo ./update_hosts.sh

# 실행 확인
# cat /etc/hosts

# 백업 파일로 복원
# sudo cp /etc/hosts.bak /etc/hosts