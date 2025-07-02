# CURSOR-NOTE: This is the base image for the agent.
FROM ubuntu:22.04
ENV TARGETARCH="linux-x64"
# Also can be "linux-arm", "linux-arm64".

# CURSOR-TODO: Install the dependencies for the agent build a django project
RUN apt update && apt upgrade -y \
  && apt install -y curl git jq libicu70 \
  python3 \
  python3-pip \
  libpq-dev \
  sudo \
  && rm -rf /var/lib/apt/lists/*

# CURSOR-NOTE: Install Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# CURSOR-TODO: Create the docker group if it doesn't exist and add the agent to the group
# docker must be installed in the host machine
RUN groupadd -f docker

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az extension add --name containerapp


WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh
RUN ls -la ./start.sh

# CURSOR-NOTE: Configure the agent user
RUN useradd -m agent
RUN usermod -aG docker agent
RUN usermod -aG sudo agent
RUN echo "agent ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /home/agent
RUN chown -R agent:agent /azp /home/agent

# CURSOR-NOTE: Configure to run as root and allow the agent to run as root
ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "/azp/start.sh" ]