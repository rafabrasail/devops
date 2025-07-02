# Azure DevOps Agent Docker Images

Este repositório contém Dockerfiles e scripts para criar **agentes do Azure DevOps** que podem executar builds Docker em ambiente Linux. Esses agentes são containers Docker que se conectam ao Azure DevOps para executar pipelines de CI/CD.

## O que é um Azure DevOps Agent?

Um Azure DevOps Agent é um serviço que executa um job de pipeline. Ele pode ser:
- **Self-hosted**: Executado em sua própria infraestrutura (como este projeto)
- **Microsoft-hosted**: Gerenciado pela Microsoft

Este projeto cria um agente **self-hosted** usando Docker, permitindo que você tenha controle total sobre o ambiente de build e execute builds Docker dentro de containers.

## Por que usar Docker para o Agent?

- **Isolamento**: Cada agente roda em seu próprio container
- **Portabilidade**: Funciona em qualquer sistema que suporte Docker
- **Consistência**: Mesmo ambiente em desenvolvimento e produção
- **Escalabilidade**: Fácil de criar múltiplos agentes
- **Docker-in-Docker**: Permite executar builds Docker dentro do próprio agente

## Configurações do Docker

### Variáveis de Ambiente Necessárias

- `AZP_URL`: URL da sua instância do Azure DevOps
- `AZP_TOKEN`: Personal Access Token (PAT) com permissões adequadas
- `AZP_POOL`: Nome do pool de agentes
- `AZP_AGENT_NAME`: Nome do agente (opcional, usa hostname por padrão)

## Como usar

### Pré-requisitos

- Docker instalado no sistema Linux
- Acesso ao Azure DevOps com permissões para criar agentes
- Personal Access Token (PAT) com permissões adequadas

### Build da imagem Linux
```bash
docker build --tag "azp-agent:linux" --file "./azp-agent-linux.dockerfile" .
```

### Executar o agente Linux
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

## Configuração no Azure DevOps

1. **Criar um Pool de Agentes**:
   - Vá para Project Settings > Agent pools
   - Clique em "Add pool" > "Self-hosted"
   - Dê um nome ao pool (ex: "Docker Agents")

2. **Configurar Permissões**:
   - O PAT deve ter permissões para "Agent Pools (Read & manage)"

3. **Executar o Container**:
   - Use o comando docker run acima
   - O agente se registrará automaticamente no pool

## Notas importantes

1. **Flag --privileged**: Necessária para que o Docker funcione dentro do container
2. **Volume mount**: Monta o socket do Docker do host para permitir comunicação
3. **Inicialização automática**: O daemon Docker é iniciado automaticamente quando o container inicia
4. **Permissões**: O usuário `agent` tem permissões adequadas para executar comandos Docker

### Limpeza Manual de docker

Se o script de limpeza não resolver, execute manualmente:

```bash
# Parar e remover containers
docker stop azp-agent-linux
docker rm azp-agent-linux

# Limpeza completa
docker system prune -af
```

## Download do agente

O agente é baixado automaticamente durante a execução, mas você pode baixá-lo manualmente:
https://download.agent.dev.azure.com/agent/4.258.1/vsts-agent-linux-x64-4.258.1.tar.gz