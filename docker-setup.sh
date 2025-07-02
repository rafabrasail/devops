#!/bin/bash

# Script para configurar Docker no container Azure Pipelines Agent

echo "🐳 Configurando Docker no Azure Pipelines Agent..."

# Verificar se estamos rodando como root ou com privilégios
if [ "$EUID" -eq 0 ]; then
    echo "✅ Executando como root"
    
    # Verificar se o Docker já está rodando
    if [ -f /var/run/docker.pid ]; then
        echo "⚠️ Docker PID file encontrado, removendo..."
        rm -f /var/run/docker.pid
    fi
    
    # Verificar se há processos Docker rodando
    if pgrep -f dockerd > /dev/null; then
        echo "⚠️ Processo Docker já está rodando, aguardando..."
        sleep 5
    else
        # Iniciar o daemon do Docker
        echo "🚀 Iniciando daemon do Docker..."
        dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2376 &
        DOCKER_PID=$!
    fi
    
    # Aguardar o Docker estar pronto
    echo "⏳ Aguardando Docker estar pronto..."
    timeout=30
    while [ $timeout -gt 0 ]; do
        if docker info >/dev/null 2>&1; then
            echo "✅ Docker daemon iniciado com sucesso"
            break
        fi
        sleep 1
        timeout=$((timeout-1))
    done
    
    if [ $timeout -eq 0 ]; then
        echo "❌ Timeout ao aguardar Docker daemon"
        exit 1
    fi
    
    # Configurar permissões do socket
    chmod 666 /var/run/docker.sock
    
    # Mudar para o usuário agent
    exec su - agent -c "cd /azp && ./start.sh $@"
else
    echo "⚠️ Executando como usuário não-root"
    
    # Verificar se o Docker está disponível
    if docker --version >/dev/null 2>&1; then
        echo "✅ Docker CLI encontrado"
        if docker info >/dev/null 2>&1; then
            echo "✅ Docker daemon funcionando"
        else
            echo "❌ Docker daemon não está funcionando"
            echo "💡 Execute o container com --privileged ou monte o socket do Docker"
        fi
    else
        echo "❌ Docker CLI não encontrado"
    fi
    
    # Continuar com o script original
    exec ./start.sh "$@"
fi 