# CURSOR-NOTE: Multi-stage Dockerfile otimizado para build e deploy de projetos React
# Stage 1: Base image with essential tools
FROM ubuntu:22.04 AS base
ENV TARGETARCH="linux-x64"
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        curl \
        git \
        jq \
        libicu70 \
        sudo \
        wget \
        unzip \
        build-essential \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean

# Stage 2: Node.js and React build tools
FROM base AS node-tools
# Install Node.js 18 LTS (stable for React projects)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install global npm packages for React development
RUN npm install -g \
    yarn \
    @angular/cli \
    create-react-app \
    serve \
    pm2 \
    && npm cache clean --force

# Stage 3: Docker and Azure tools
FROM node-tools AS azure-tools
# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh --dry-run \
    && rm get-docker.sh

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az extension add --name containerapp --yes \
    && az extension add --name azure-devops --yes

# Stage 4: Final optimized image
FROM azure-tools AS final
WORKDIR /azp/

# Copy and configure start script
COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create and configure agent user
RUN useradd -m agent \
    && usermod -aG docker agent \
    && usermod -aG sudo agent \
    && echo "agent ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/agent \
    && chown -R agent:agent /azp /home/agent

# Configure environment for React builds
ENV AGENT_ALLOW_RUNASROOT="true"
ENV NODE_ENV="production"
ENV CI="true"

# Create cache directories for better performance
RUN mkdir -p /home/agent/.npm /home/agent/.yarn /home/agent/.cache \
    && chown -R agent:agent /home/agent

# Install additional build tools for React projects
RUN apt-get update && apt-get install -y --no-install-recommends \
        # For image optimization
        imagemagick \
        # For compression
        gzip \
        # For SSL certificates
        openssl \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean

# Set up npm and yarn configurations for better performance
RUN npm config set cache /home/agent/.npm --global \
    && yarn config set cache-folder /home/agent/.yarn

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

ENTRYPOINT [ "/azp/start.sh" ]