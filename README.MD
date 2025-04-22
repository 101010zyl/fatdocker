# fatdocker

---
Docker with anything I use. Never reduce package and clean cache.

## Features

- Ubuntu 22.04 LTS base with common development tools
- Multiple Python versions (3.8-3.13) with virtual environments
- Non-root user with sudo privileges
- Docker-in-Docker capability
- Easy setup with docker-compose

## Usage

```bash
git clone https://github.com/101010zyl/fatdocker.git
cd fatdocker
```

### Option 1: Using Docker Compose (Recommended)

1. Use the provided setup script to create a `.env` file with your host user information:

```bash
# Make the script executable
chmod +x setup-env.sh

# Run the setup script
./setup-env.sh
```

This will create a `.env` file that automatically uses your host username, UID, and GID.

2. Run with docker-compose:

```bash
# Start the container
docker-compose up -d

# Enter the container
docker-compose exec dev bash
```

3. Verify that you're running as your host user inside the container:

```bash
# Inside the container
whoami
id
```

3. For GPU support, uncomment the GPU section in `docker-compose.yml`

4. To stop the container, run:

```bash
docker-compose down
```

### Option 2: Using Docker Directly

1. Build the image
```bash
docker build -t fatdocker:1.0 .
```

2. Run the image
```bash
export PORT1=1111
export PORT2=2222
export WORKSPACE=/path/to/your/workspace
export USERNAME=$(whoami)
export USER_UID=$(id -u)
export USER_GID=$(id -g)

docker run -p $PORT1:$PORT1 -p $PORT2:$PORT2 \
  -v $WORKSPACE:/home/$USERNAME/workspace \
  --user $USERNAME \
  --name <project_name> \
  --build-arg USERNAME=$USERNAME \
  --build-arg USER_UID=$USER_UID \
  --build-arg USER_GID=$USER_GID \
  -it fatdocker:1.0 /bin/bash
```

3. For GPU support, add `--gpus all` to the command above

4. Run the container
```bash
docker exec -it <project_name> /bin/bash
```

## Environment Details

- Default user: Your host username with sudo privileges
- Workspace directory: `/home/<username>/workspace` (mounted from host)
- Python virtual environments: `/home/<username>/venvs`
- Python 3.11 activated by default
- Upon login, you're automatically in your workspace directory

## Customization

- By default, the container will use your host user's username, UID, and GID
- You can manually modify the `.env` file if you need different values
- To use a different Python version, modify the `.bashrc` source line in the Dockerfile
- If you're using this container on multiple machines, the user in the container will automatically match the host user on each machine