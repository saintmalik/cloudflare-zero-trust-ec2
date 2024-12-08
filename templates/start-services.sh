#!/bin/bash
set -e

handle_error() {
   echo "Error occurred in script at line: $1"
   exit 1
}
trap 'handle_error $LINENO' ERR

echo "Ensuring services are enabled..."
sudo systemctl enable amazon-ssm-agent docker || true
sudo systemctl start amazon-ssm-agent docker || true

if ! command -v docker-compose &> /dev/null; then
  echo "Installing Docker Compose..."
  DOCKER_COMPOSE_VERSION="v2.23.0"
  sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

sudo su apps && sudo chown -R apps:apps /home/apps/

echo "Logging into ECR..."
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${container_image_url}

start_environment() {
  local max_retries=3
  local retry_count=0
  while [ $retry_count -lt $max_retries ]; do
    echo "Starting environment (attempt $(($retry_count + 1)))"
    if (docker-compose -f /home/apps/docker-compose.yml down || true) && \
        docker-compose -f /home/apps/docker-compose.yml up -d --remove-orphans; then
        echo "Environment started successfully"
        return 0
    fi
    retry_count=$(($retry_count + 1))
    [ $retry_count -lt $max_retries ] && sleep 10
  done
  echo "Failed to start environment after $max_retries attempts"
  return 1
}

echo "Starting environment..."
start_environment

echo "All services started successfully"