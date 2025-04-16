# Base image: Ubuntu 22.04 LTS (Jammy Jellyfish) - widely used Linux distribution
FROM ubuntu:22.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set up timezone (prevents hanging on tzdata configuration)
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    apt-get update && apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Update package lists and install essential build tools
RUN apt-get update && \
    apt-get install -y \
    # Build essentials
    build-essential \
    cmake \
    make \
    ninja-build \
    gcc \
    g++ \
    gdb \
    clang \
    # Version control
    git \
    subversion \
    mercurial \
    # Package managers
    curl \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg \
    software-properties-common \
    # Shell & CLI tools
    bash \
    zsh \
    tmux \
    screen \
    vim \
    nano \
    emacs \
    # Network tools
    net-tools \
    iputils-ping \
    telnet \
    netcat \
    nmap \
    # System utilities
    htop \
    sudo \
    zip \
    unzip \
    tar \
    jq \
    tree \
    bear \

    # Languages & runtimes
    nodejs \
    npm \
    # Additional tools
    sqlite3 \
    postgresql-client \
    mysql-client \
    redis-tools \
    # Documentation
    man-db \
    # Anything
    libncurses-dev libssl-dev libelf-dev bison flex liblz4-tool bc debootstrap

# Install Docker CLI (for Docker-in-Docker capabilities if needed)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli

# Install additional dev tools using npm
RUN npm install -g typescript yarn prettier eslint

# Add deadsnakes PPA for multiple Python versions
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update

# Install Python versions from 3.8 to 3.13
RUN apt-get install -y \
    python3.8 \
    python3.8-dev \
    python3.8-distutils \
    python3.8-venv \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3.9-venv \
    python3.10 \
    python3.10-dev \
    python3.10-distutils \
    python3.10-venv \
    python3.11 \
    python3.11-dev \
    python3.11-distutils \
    python3.11-venv \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3.13 \
    python3.13-dev \
    python3.13-venv

# Create python virtual environments for each version
RUN mkdir -p /venvs
RUN python3.8 -m venv /venvs/py38 --prompt 3.8 && \
    python3.9 -m venv /venvs/py39 --prompt 3.9 && \
    python3.10 -m venv /venvs/py310 --prompt 3.10 && \
    python3.11 -m venv /venvs/py311 --prompt 3.11 && \
    python3.12 -m venv /venvs/py312 --prompt 3.12 && \
    python3.13 -m venv /venvs/py313 --prompt 3.13

RUN echo "source /venvs/py311/bin/activate" >> /root/.bashrc

# Create a workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Set a default command to keep the container running
CMD ["/bin/bash"]
