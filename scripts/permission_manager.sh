#!/bin/bash

# ==============================================================================
# SCRIPT: Gestão de Permissões e Grupos (Hardening)
# DESCRIÇÃO: Cria um ambiente isolado para execução dos scripts de rede.
# ==============================================================================

PROJECT_DIR="./lab_data"
GROUP_NAME="netadmins"
USER_NAME="maria_lab"

echo "Configurando permissões do ambiente"

# 1. Criação de diretório de dados se não existir
if [ ! -d "$PROJECT_DIR" ]; then
    mkdir -p "$PROJECT_DIR"
    echo "Diretório $PROJECT_DIR criado."
fi

# 2. Definição de Bits Especiais (Sticky Bit)
# O Sticky Bit (chmod +t) garante que apenas o dono do arquivo possa deletá-lo,
# mesmo que outros tenham permissão de escrita na pasta.
chmod +t "$PROJECT_DIR"
echo "Sticky Bit ativado em $PROJECT_DIR (Segurança contra deleção acidental)"

# 3. Auditoria de Permissões (Simulação)
# Lista arquivos com permissão '777' (insegura) e alerta
echo "Auditando arquivos com permissão 777 (Perigo)..."
find . -type f -perm 777 -exec ls -l {} \; 

# 4. Ajuste Recursivo (Exemplo Prático)
# Define: Dono lê/escreve/executa (7), Grupo lê/executa (5), Outros nada (0)
chmod -R 750 scripts/
echo "Permissões de scripts ajustadas para 750 (rwxr-x---)"
