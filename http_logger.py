#!/bin/env python3

import socket

HOST = '127.0.0.1'
PORT = 5000

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen()
    print(f'Server is listening on {HOST}:{PORT}')

    try:
        while True:
            conn, addr = s.accept()

            with conn:
                print(f'Connected by {addr}')
                data = conn.recv(1024)
                if not data:
                    break

                # Декодируем данные запроса
                request_data = data.decode('utf-8', errors='replace')

                # Логируем в stdout заголовки и тело запроса
                print("Request Headers and Body:")
                print(request_data)

                # Ответ 200 OK
                response_header = (
                    "HTTP/1.1 200 OK\r\n"
                    "Content-type: text/plain\r\n"
                    "Connection: close\r\n"
                    "\r\n"
                )

                conn.sendall(response_header.encode('utf-8'))
    except KeyboardInterrupt:
        print("\nServer is shutting down...")
        s.close()
        exit(1)
