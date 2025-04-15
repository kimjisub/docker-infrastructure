# docker-infrastructure

1. let's encrypt 인증서를 http 서버에 연결하여 https 통신이 가능하도록 합니다.
2. watchtower 를 사용하여 컨테이너를 자동으로 업데이트 합니다.
3. 컨테이너 로그가 디스크를 꽉 채우지 않도록 최대 3개의 파일을 유지합니다.

## Docker Installation

```bash
./scripts/docker-install.sh
```

## Registry Login (ghcr.io)

GitHub의 Personal access token을 사용하여 GitHub Container Registry(ghcr.io)에 Docker로 로그인하려면 다음 단계를 따르세요:

> Fine-Grained Personal Access Token(FGPAT)는 Package 권한을 제어할 수 없어서, Classic PAT를 사용합니다.

### 1. Classic PAT 생성

 1. GitHub에서 로그인 후 Settings로 이동.
 2. Developer settings > Personal access tokens > Generate new token 버튼 클릭.
 3. `read:packages` 권한 체크.
 4. 생성된 토큰을 복사하여 저장(나중에 확인 불가).

### 2. Docker 로그인

터미널에서 다음 명령어 실행:

```bash
echo "<YOUR_FINE_GRAINED_PAT>" | docker login ghcr.io -u <YOUR_GITHUB_USERNAME> --password-stdin
```

- <YOUR_FINE_GRAINED_PAT>: 생성한 Fine-Grained Personal Access Token.
- <YOUR_GITHUB_USERNAME>: GitHub 사용자 이름.

### 3. Docker 이미지 Pull 또는 Push

- 이미지 Pull:

```bash
docker pull ghcr.io/<YOUR_USERNAME>/<IMAGE_NAME>:<TAG>
```

## Github Login

```bash
git config --global credential.helper store
```

## `~/.docker/config.json`

host machine의 docker hub 인증 정보를 watchtower 에서도 공유해서 사용합니다.

```json
{
 "auths": {
  "https://index.docker.io/v1/": {
    "auth": "<Docker Hub 인증 토큰>"
  },
  "000000000000.dkr.ecr.ap-northeast-2.amazonaws.com": {
   "auth": "<ECR 인증 토큰>"
  },
  "ghcr.io": {
   "auth": "<Github Container Registry 인증 토큰>"
  }
 }
}
```

## Docker External Network

다른 docker-compose 에서도 사용할 수 있는 외부 네트워크를 생성합니다.

```bash
docker network create proxy
```

## Run

```bash
docker compose up -d
```

## docker-compose.yml example


[docker-compose.yml](./example/docker-compose.yml)

