#!/bin/bash

# Create .env file with host user information
cat > .env << EOF
# Project name for the container
PROJECT_NAME=${PROJECT_NAME:-fatdocker_dev}

# Host user information
USER=$(whoami)
UID=$(id -u)
GID=$(id -g)

# Path to your workspace directory on the host machine
# This will be mounted to /workspace in the container
WORKSPACE=${WORKSPACE:-$(pwd)/workspace}

# Ports to expose from the container to the host
PORT1=${PORT1:-8080}
PORT2=${PORT2:-8081}
EOF

echo "Created .env file with your user information: $(whoami) (UID: $(id -u), GID: $(id -g))"
echo "You can now run 'docker-compose up -d' to start the container"

# Ensure the workspace directory exists
mkdir -p ${WORKSPACE:-$(pwd)/workspace}

echo "Workspace will be mounted to /home/$(whoami)/workspace inside the container"
echo "Python virtual environments will be in /home/$(whoami)/venvs"