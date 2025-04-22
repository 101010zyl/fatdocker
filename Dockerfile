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
    gzip \
    bzip2 \
    xz-utils \
    lzop \
    findutils \
    cpio \
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

# Create a non-root user with sudo privileges
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Add sudo support
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Create workspace directory
RUN mkdir -p /home/$USERNAME/workspace && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/workspace

# Create python virtual environments directly in the user's home directory
RUN mkdir -p /home/$USERNAME/venvs && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/venvs

# Create the venvs as the user (avoids permission issues)
USER $USERNAME
RUN python3.8 -m venv /home/$USERNAME/venvs/py38 --prompt 3.8 && \
    python3.9 -m venv /home/$USERNAME/venvs/py39 --prompt 3.9 && \
    python3.10 -m venv /home/$USERNAME/venvs/py310 --prompt 3.10 && \
    python3.11 -m venv /home/$USERNAME/venvs/py311 --prompt 3.11 && \
    python3.12 -m venv /home/$USERNAME/venvs/py312 --prompt 3.12 && \
    python3.13 -m venv /home/$USERNAME/venvs/py313 --prompt 3.13

# Switch back to root for remaining setup
USER root

# Set up environments for both root and the user
RUN echo "source /home/$USERNAME/venvs/py311/bin/activate" >> /root/.bashrc
RUN echo "source ~/venvs/py311/bin/activate" >> /home/$USERNAME/.bashrc
RUN echo "cd ~/workspace" >> /home/$USERNAME/.bashrc

# Set default working directory to user's workspace
WORKDIR /home/$USERNAME/workspace

# Switch back to the user for container runtime
USER $USERNAME