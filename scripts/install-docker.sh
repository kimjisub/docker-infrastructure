#!/bin/bash

# Docker 설치를 위한 패키지 업데이트
sudo apt-get update

# HTTPS를 통해 저장소를 사용할 수 있도록 패키지 설치
sudo apt-get install -y \
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
sudo apt-get install -y docker-ce

# Docker가 정상적으로 설치되었는지 버전 확인
docker --version

# Docker 그룹에 사용자 추가
sudo usermod -aG docker $USER


touch ~/.docker/config.json
echo "{}" > ~/.docker/config.json

# ssh 재접속
