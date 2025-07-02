#!/bin/bash

echo "🧹 Script de Limpeza para Azure DevOps Agent Docker"

# Parar e remover containers do agente
echo "🛑 Parando containers do agente..."
docker stop azp-agent-linux 2>/dev/null || true
docker rm azp-agent-linux 2>/dev/null || true

# Remover containers órfãos
echo "🗑️ Removendo containers órfãos..."
docker container prune -f

# Remover imagens não utilizadas
echo "🖼️ Removendo imagens não utilizadas..."
docker image prune -f

# Remover volumes não utilizados
echo "💾 Removendo volumes não utilizados..."
docker volume prune -f

# Remover redes não utilizadas
echo "🌐 Removendo redes não utilizadas..."
docker network prune -f

# Limpeza completa do sistema Docker
echo "🧽 Limpeza completa do sistema Docker..."
docker system prune -af

echo "✅ Limpeza concluída!"

echo ""
echo "📋 Para executar o agente novamente, use:"
echo "docker run -e AZP_URL=\"https://dev.azure.com/rafaelrosenberg-dev/\" \\"
echo "           -e AZP_TOKEN=\"SEU_TOKEN_AQUI\" \\"
echo "           -e AZP_POOL=\"rosenberg\" \\"
echo "           -e AZP_AGENT_NAME=\"Docker Agent - Linux\" \\"
echo "           --name \"azp-agent-linux\" \\"
echo "           --privileged \\"
echo "           -v /var/run/docker.sock:/var/run/docker.sock \\"
echo "           azp-agent:linux" 