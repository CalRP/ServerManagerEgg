FROM debian:bookworm-slim

# Path: Dockerfile

# Update and install required packages
RUN apt-get update && apt upgrade -y && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    pkg-config \
    tar \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Add a user for the container
RUN useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

# Copy entrypoint and start scripts
COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh

# Ensure Node.js is in the PATH
ENV PATH="/usr/local/bin:$PATH"

CMD         [ "/bin/bash", "/entrypoint.sh" ]
