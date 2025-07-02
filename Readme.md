# Azure DevOps Self-Hosted Agent for Django Projects

This repository contains Dockerfiles and scripts to create **Azure DevOps agents** that can execute Docker builds in a Linux environment. These agents are Docker containers that connect to Azure DevOps to run CI/CD pipelines, specifically designed for Django project builds.

## What is an Azure DevOps Agent?

An Azure DevOps Agent is a service that executes a pipeline job. It can be:
- **Self-hosted**: Run on your own infrastructure (like this project)
- **Microsoft-hosted**: Managed by Microsoft

This project creates a **self-hosted** agent using Docker, allowing you to have full control over the build environment and execute Docker builds within containers, perfect for Django application development and deployment.

## Why use Docker for the Agent?

- **Isolation**: Each agent runs in its own container
- **Portability**: Works on any system that supports Docker
- **Consistency**: Same environment in development and production
- **Scalability**: Easy to create multiple agents
- **Docker-in-Docker**: Allows executing Docker builds within the agent itself
- **Django-specific**: Optimized for Python and Django project requirements

## Docker Configuration

### Required Environment Variables

- `AZP_URL`: URL of your Azure DevOps instance
- `AZP_TOKEN`: Personal Access Token (PAT) with appropriate permissions
- `AZP_POOL`: Name of the agent pool
- `AZP_AGENT_NAME`: Agent name (optional, uses hostname by default)

## How to use

### Prerequisites

- Docker installed on Linux system
- Access to Azure DevOps with permissions to create agents
- Personal Access Token (PAT) with appropriate permissions

### Build the Linux image
```bash
docker build --tag "azp-agent:linux" --file "./azp-agent-linux.dockerfile" .
```

### Run the Linux agent
```bash
docker run -e AZP_URL="<Azure DevOps instance>" \
           -e AZP_TOKEN="<Personal Access Token>" \
           -e AZP_POOL="<Agent Pool Name>" \
           -e AZP_AGENT_NAME="Docker Agent - Linux" \
           --name "azp-agent-linux" \
           --privileged \
           -v /var/run/docker.sock:/var/run/docker.sock \
           azp-agent:linux
```

## Azure DevOps Configuration

1. **Create an Agent Pool**:
   - Go to Project Settings > Agent pools
   - Click "Add pool" > "Self-hosted"
   - Give the pool a name (e.g., "Docker Agents")

2. **Configure Permissions**:
   - The PAT must have permissions for "Agent Pools (Read & manage)"

3. **Run the Container**:
   - Use the docker run command above
   - The agent will automatically register in the pool

## Important Notes

1. **--privileged flag**: Required for Docker to work inside the container
2. **Volume mount**: Mounts the Docker socket from the host to allow communication
3. **Automatic initialization**: The Docker daemon is automatically started when the container starts
4. **Permissions**: The `agent` user has appropriate permissions to execute Docker commands

### Manual Docker cleanup

If the cleanup script doesn't resolve issues, execute manually:

```bash
# Stop and remove containers
docker stop azp-agent-linux
docker rm azp-agent-linux

# Complete cleanup
docker system prune -af
```

## Agent Download

The agent is automatically downloaded during execution, but you can download it manually:
https://download.agent.dev.azure.com/agent/4.258.1/vsts-agent-linux-x64-4.258.1.tar.gz
