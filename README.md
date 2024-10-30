# docker-infrastructure

## Docker Installation

```bash
#!/bin/bash

# Docker 설치를 위한 패키지 업데이트
sudo apt-get update

# HTTPS를 통해 저장소를 사용할 수 있도록 패키지 설치
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Docker의 공식 GPG 키 추가
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Docker 저장소를 APT 소스에 추가
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Docker 패키지 업데이트
sudo apt-get update

# Docker CE(Community Edition) 설치
sudo apt-get install docker-ce

# Docker가 정상적으로 설치되었는지 버전 확인
docker --version

# Docker 그룹에 사용자 추가
sudo usermod -aG docker $USER

# ssh 재접속
```

## `~/.docker/config.json`

host machine의 docker hub 인증 정보를 watchtower 에서도 공유해서 사용합니다.

```json
{
  "auths": {
    "https://index.docker.io/v1/": {
      "auth": "c3VwZXJzZWNyZXQ6c3VwZXJzZWNyZXQ="
    }
  }
}
```

## Docker External Network

다른 docker-compose 에서도 사용할 수 있는 외부 네트워크를 생성합니다.

```bash
docker network create proxy
```
