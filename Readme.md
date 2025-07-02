# Azure DevOps Agent Docker Images

Este repositório contém Dockerfiles para criar agentes do Azure DevOps que podem executar builds Docker.

## Configurações do Docker

### Linux Agent (`azp-agent-linux.dockerfile`)

O agente Linux inclui as seguintes configurações do Docker:

1. **Instalação do Docker**: Instala o `docker.io` via apt
2. **Configuração do usuário**: Adiciona o usuário `agent` ao grupo `docker`
3. **Configuração do daemon**: Cria arquivo de configuração `/etc/docker/daemon.json` com:
   - Storage driver: overlay2
   - Log driver: json-file com rotação de logs
4. **Permissões do socket**: Configura permissões adequadas para `/var/run/docker.sock`
5. **Configuração do sudo**: Permite que o usuário `agent` execute comandos Docker sem senha
6. **Inicialização automática**: O script `start.sh` inicia o daemon Docker automaticamente

### Variáveis de Ambiente Necessárias

- `AZP_URL`: URL da sua instância do Azure DevOps
- `AZP_TOKEN`: Personal Access Token (PAT) com permissões adequadas
- `AZP_POOL`: Nome do pool de agentes
- `AZP_AGENT_NAME`: Nome do agente (opcional, usa hostname por padrão)

## Como usar

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

## Notas importantes

1. **Flag --privileged**: Necessária para que o Docker funcione dentro do container
2. **Volume mount**: Monta o socket do Docker do host para permitir comunicação
3. **Inicialização automática**: O daemon Docker é iniciado automaticamente quando o container inicia
4. **Permissões**: O usuário `agent` tem permissões adequadas para executar comandos Docker

## Solução de Problemas

### Erro: "failed to start daemon, ensure docker is not running or delete /var/run/docker.pid"

Este erro indica que há um conflito com o Docker daemon. Execute o script de limpeza:

```bash
./cleanup.sh
```

### Erro: "missing AZP_URL environment variable"

Verifique se todas as variáveis de ambiente estão sendo passadas corretamente:

```bash
docker run -e AZP_URL="https://dev.azure.com/rafaelrosenberg-dev/" \
           -e AZP_TOKEN="SEU_TOKEN_AQUI" \
           -e AZP_POOL="rosenberg" \
           -e AZP_AGENT_NAME="Docker Agent - Linux" \
           --name "azp-agent-linux" \
           --privileged \
           -v /var/run/docker.sock:/var/run/docker.sock \
           azp-agent:linux
```

### Limpeza Manual

Se o script de limpeza não resolver, execute manualmente:

```bash
# Parar e remover containers
docker stop azp-agent-linux
docker rm azp-agent-linux

# Limpeza completa
docker system prune -af
```

## Recursos incluídos

- Docker Engine
- Azure CLI
- Python 3 e pip
- Git
- Sudo configurado
- Agente do Azure DevOps v4.258.1

## Download do agente

O agente é baixado automaticamente durante a execução, mas você pode baixá-lo manualmente:
https://download.agent.dev.azure.com/agent/4.258.1/vsts-agent-linux-x64-4.258.1.tar.gz