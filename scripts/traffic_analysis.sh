#!/bin/bash

# ==============================================================================
# SCRIPT: Monitoramento de Tráfego de Rede (Network Analysis)
# FERRAMENTAS: ss (Socket Statistics), netstat, grep
# CONTEXTO: Monitorar conexões ativas na porta do Socket Server (8888)
# ==============================================================================

LOG_FILE="network_traffic.log"
TARGET_PORT=8888

echo "Iniciando monitoramento de tráfego na porta $TARGET_PORT..."
echo "Pressione [CTRL+C] para parar."

# Loop infinito de monitoramento
while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # O comando 'ss' substitui o netstat em sistemas Linux modernos (Debian 13)
    # -t (tcp) -n (numeric) -p (process)
    CONNECTIONS=$(ss -tnp | grep ":$TARGET_PORT")

    if [ ! -z "$CONNECTIONS" ]; then
        echo "[$TIMESTAMP] ⚠️ ATIVIDADE DETECTADA:" | tee -a $LOG_FILE
        echo "$CONNECTIONS" | tee -a $LOG_FILE
        echo "----------------------------------------------------" | tee -a $LOG_FILE
    fi

    sleep 5 # Verifica a cada 5 segundos
done
