FROM apache/airflow:2.7.3-python3.8

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    libhdf5-dev \
    libblas-dev \
    liblapack-dev \
    gfortran \
    pkg-config \
    curl \
    acl \
    openssh-server \
 && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh
RUN usermod -aG root airflow
RUN apt-get install -y acl
RUN setfacl -Rm d:g:root:rwx,g:root:rwx /var/run/
RUN apt install -y openssh-server
RUN mkdir /run/sshd && chmod 700 /run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' \
            /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' \
            /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' \
            /etc/ssh/sshd_config \
    && sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/g' \
            /etc/ssh/sshd_config
USER airflow

# pip 최신화
RUN pip install --upgrade pip

# pip 패키지 설치 (airflow 사용자 권한 하에서만 가능)
RUN pip install --no-cache-dir \
    "bentoml>=1.0.0a" \
    tensorflow \
    xgboost \
    pandas \
    pydantic \
    keras \
    scikit-learn \
    aequitas-lite
