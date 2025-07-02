FROM ubuntu:22.04
ENV TARGETARCH="linux-x64"
# Also can be "linux-arm", "linux-arm64".

RUN apt update && apt upgrade -y \
  && apt install -y curl git jq libicu70 \
  git \
  python3 \
  python3-pip \
  libpq-dev \
  sudo \
  && rm -rf /var/lib/apt/lists/*

# Instalar Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Criar o grupo docker se não existir
RUN groupadd -f docker

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az extension add --name containerapp

WORKDIR /azp/

COPY ./start.sh ./
COPY ./docker-setup.sh ./
RUN chmod +x ./start.sh ./docker-setup.sh

# Configurar usuário agent
RUN useradd -m agent
RUN usermod -aG docker agent
RUN usermod -aG sudo agent
RUN echo "agent ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /home/agent
RUN chown -R agent:agent /azp /home/agent

# Configurar para rodar como root e permitir execução do agent como root
ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./docker-setup.sh" ]