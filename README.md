# Docker Swarm with Prisma and Docker Secrets

This repository provides an example of how to securely pass your `DATABASE_URL` to a Prisma backend using Docker Swarm and Docker Secrets.

## Article Details
- **Author:** Adeleke Joshua A.
- **Date:** 2024/05/27
- **Medium Article Link:** [Link](https://lekejosh.medium.com/building-a-scalable-node-js-backend-separating-request-handling-and-background-jobs-eca17209fbcb)

## Quick Start

### 1. Initialize Docker Swarm

```sh
docker swarm init
```

### 2. Create Docker Secret

```sh
echo -n "postgresql://postgres:postgres@localhost:5432/main" | docker secret create db_url -
```

### 3. Create a Bash Script (`entry.sh`)

```sh
#!/bin/sh

read_secret() {
  local secret_name=$1
  local env_var_name=$2
  local secret_path="/run/secrets/${secret_name}"
  
  if [ -f "${secret_path}" ]; then
    export ${env_var_name}=$(cat "${secret_path}")
  else
    echo "Secret file ${secret_path} not found"
    exit 1
  fi
}

read_secret "db_url" "DATABASE_URL"
# Add other secrets as needed

npm run start
```

### 4. Create Dockerfile

```Dockerfile
FROM node:alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm install -g typescript
RUN tsc || true  
RUN npx prisma generate && npm run build

COPY entry.sh /usr/src/app/entry.sh
RUN chmod +x /usr/src/app/entry.sh

CMD ["/usr/src/app/entry.sh"]
```

### 5. Create Docker Compose File

```yaml
version: '3.7'

services:
  backend:
    image: backend:v2
    secrets:
      - db_url
    ports:
      - '4000:4000'
    deploy:
      restart_policy:
        condition: on-failure
      replicas: 1
    healthcheck:
      test: wget --no-verbose --tries=1 --spider http://localhost:4000/health || exit 1
      interval: 30s
      retries: 5
      start_period: 20s
      timeout: 30s

secrets:
  db_url:
    external: true
```

### 6. Deploy the Stack

```sh
docker stack deploy -c docker-compose.yml demo
```

For detailed instructions, visit the [full article on Medium](https://medium.com/).

---

This minimal setup will get you started with securely passing your `DATABASE_URL` to a Prisma backend using Docker Swarm and Docker Secrets. For a comprehensive guide, please refer to the [full article on Medium](https://medium.com/).