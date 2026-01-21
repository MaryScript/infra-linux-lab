# ==============================================================================
# PROJETO: Servidor de Monitoramento de Conexões (Socket TCP)
# AUTOR: Maria Paula Ferreira
# DESCRIÇÃO: 
#   Implementação de um servidor TCP raw socket em Python.
#   O objetivo é estudar o handshake (SYN/ACK) e persistência de conexão.
#   Este servidor deve ser testado utilizando o comando 'netcat' no cliente.
# ==============================================================================

import socket
import threading
import datetime

# Configurações do Servidor
HOST = '0.0.0.0'  # Escuta em todas as interfaces de rede
PORT = 8888       # Porta alta para evitar necessidade de root

def handle_client(client_socket, addr):
    """Gerencia a thread de conexão com um cliente específico"""
    print(f"[NOVA CONEXÃO] {addr} conectado às {datetime.datetime.now()}")
    
    try:
        # Envia banner de boas-vindas (Protocolo Customizado)
        banner = "--- UNB/UnDF LAB SERVER v1.0 ---\nDigite 'STATUS' ou 'SAIR': \n"
        client_socket.send(banner.encode('utf-8'))

        while True:
            # Recebe dados do cliente (Buffer de 1024 bytes)
            request = client_socket.recv(1024).decode('utf-8').strip()
            
            if not request:
                break
            
            print(f"[{addr}] COMANDO: {request}")

            # Lógica de resposta simples
            if request.upper() == 'STATUS':
                response = "SERVER OK - RUNNING\n"
            elif request.upper() == 'SAIR':
                client_socket.send("Desconectando...\n".encode('utf-8'))
                break
            else:
                response = f"Comando desconhecido: {request}\n"
            
            client_socket.send(response.encode('utf-8'))
            
    except Exception as e:
        print(f"[ERRO] {addr}: {e}")
    finally:
        client_socket.close()
        print(f"[DESCONECTADO] {addr}")

def start_server():
    """Inicia o bind e listen do socket"""
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((HOST, PORT))
    server.listen(5) # Fila de até 5 conexões
    print(f"[*] Ouvindo em {HOST}:{PORT}")

    while True:
        client, addr = server.accept()
        # Cria uma thread para cada cliente (Concorrência)
        client_handler = threading.Thread(target=handle_client, args=(client, addr))
        client_handler.start()

if __name__ == "__main__":
    start_server()
