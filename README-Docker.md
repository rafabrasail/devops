# Azure Pipelines Agent com Docker

Este container inclui um Azure Pipelines Agent com Docker configurado para funcionar dentro do container.

## Como Executar

### Opção 1: Com Docker-in-Docker (Recomendado)

```bash
docker run -d \
  --name azp-agent \
  --privileged \
  -e AZP_URL=https://dev.azure.com/YOUR_ORGANIZATION \
  -e AZP_TOKEN=YOUR_PAT_TOKEN \
  -e AZP_POOL=YOUR_POOL_NAME \
  -e AZP_AGENT_NAME=YOUR_AGENT_NAME \
  azp-agent-linux
```

### Opção 2: Montando o Socket do Docker do Host

```bash
docker run -d \
  --name azp-agent \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e AZP_URL=https://dev.azure.com/YOUR_ORGANIZATION \
  -e AZP_TOKEN=YOUR_PAT_TOKEN \
  -e AZP_POOL=YOUR_POOL_NAME \
  -e AZP_AGENT_NAME=YOUR_AGENT_NAME \
  azp-agent-linux
```

### Opção 3: Usando Service Principal (Azure)

```bash
docker run -d \
  --name azp-agent \
  --privileged \
  -e AZP_URL=https://dev.azure.com/YOUR_ORGANIZATION \
  -e AZP_CLIENTID=YOUR_CLIENT_ID \
  -e AZP_CLIENTSECRET=YOUR_CLIENT_SECRET \
  -e AZP_TENANTID=YOUR_TENANT_ID \
  -e AZP_POOL=YOUR_POOL_NAME \
  -e AZP_AGENT_NAME=YOUR_AGENT_NAME \
  azp-agent-linux
```

## Variáveis de Ambiente

- `AZP_URL`: URL da sua organização Azure DevOps
- `AZP_TOKEN`: Personal Access Token (PAT) com permissões adequadas
- `AZP_POOL`: Nome do pool de agentes
- `AZP_AGENT_NAME`: Nome do agente (opcional, usa hostname por padrão)
- `AZP_WORK`: Diretório de trabalho (opcional, usa `_work` por padrão)

### Para Service Principal:
- `AZP_CLIENTID`: ID do cliente do service principal
- `AZP_CLIENTSECRET`: Secret do service principal
- `AZP_TENANTID`: ID do tenant do Azure

## Como Funciona

1. O container inicia como root
2. O script `docker-setup.sh` inicia o daemon do Docker
3. Configura as permissões adequadas
4. Muda para o usuário `agent` e executa o Azure Pipelines Agent

## Troubleshooting

### Docker não está funcionando

Se você ver a mensagem "Docker encontrado mas não está funcionando", verifique:

1. Se está usando `--privileged` ou montando o socket do Docker
2. Se o daemon do Docker foi iniciado corretamente
3. Se as permissões estão configuradas adequadamente

### Logs

Para ver os logs do container:

```bash
docker logs azp-agent
```

### Acessar o container

```bash
docker exec -it azp-agent bash
```

## Build da Imagem

```bash
docker build -f azp-agent-linux.dockerfile -t azp-agent-linux .
``` 