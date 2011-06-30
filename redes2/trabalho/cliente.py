#!/usr/bin/env python
#-*- encoding: utf-8 -*-

# cliente.py

import socket, time
from datetime import datetime


class Cliente(object):

    def __init__(self,ME,l_hosts,l_ports,logFP):

        self.HOST = ''
        self.logFile = logFP
        self.ME = ME

        # Atribuindo valor a self.HOST
        self.escolhe_servidor(l_hosts)
        self.PORT = int(l_ports[l_hosts.index(self.HOST)])

    def log(self,msg,data='nada'):

        ''' diferentes niveis de log:
           0 - Inicio da execucao do cliente
           1 - Recebimento de dados
           2 - Envio de dados
           3 - Tentativa de conexao usando IPv6
           4 - IPv6 falho, tentando IPv4
           5 - IPv6 conectado com sucesso
           6 - IPv4 conectado com sucesso
           7 - Sem conexao
           8 - Desligando cliente
        '''
        textmsg = [ "\nIniciando "+self.ME+" em modo cliente: "+datetime.now().ctime()+"\n",
                    self.ME+" diz: recebi "+str(data)+" de "+self.HOST+" em: "+datetime.now().ctime()+"\n",
                    self.ME+" diz: enviei "+str(data)+" para "+self.HOST+" em: "+datetime.now().ctime()+"\n",
                    self.ME+" tentando conectar-se usando IPv6: "+datetime.now().ctime()+"\n",
                    self.ME+" diz: nao foi possivel conectar via IPv6, usando IPv4.\n",
                    self.ME+" diz: conectado via IPv6 - "+datetime.now().ctime()+"\n",
                    self.ME+" diz: conectado via IPv4 - "+datetime.now().ctime()+"\n",
                    self.ME+" diz: servidor aparenta estar desconectado: "+datetime.now().ctime()+"\n",
                    self.ME+" -> desligando em "+datetime.now().ctime()+"\n",
                  ]

        self.logFile.write(textmsg[msg])

    def escolhe_servidor(self,l_hosts):

        while True:
            # Lista as maquinas disponiveis para o cliente se conectar.
            for i,j in enumerate(l_hosts):
                print i,j

            maq = raw_input("Escolha uma das maquinas acima: ")

            try:
                indice = int(maq)
                if l_hosts[indice]:
                    self.HOST = l_hosts[indice]
                    break

            except IndexError:
                print
                continue

            except ValueError:
                if maq in l_hosts:
                    self.HOST = maq
                    break

                else:
                    print
                    continue

    def conecta(self):

        # Abrindo um socket IPv6
        try:
            self.log(3)
            self.sock = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
            self.sock.connect((self.HOST, self.PORT))
            self.log(5)

        except socket.error:

            # IPv6 FAIL, tentando IPv4:
            self.log(4)

            try:
                # Abrindo socket IPv4:
                self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                self.sock.connect((self.HOST, self.PORT))
                self.log(6)

            except socket.error:

                # Falhou o IPv4 tb... provavelmente perdeu-se a conexao
                self.log(7)
                exit(1)


    def start(self):

        # Registra o inicio do cliente:
        self.log(0)

        # Criando a conexao:
        self.conecta()


        # Conexao feita, eh hora de aguardar a entrada do usuario.
        while True:

            # Recebendo dados do usuario:
            try:
                data = raw_input("Digite a expressao aritmetica: ")

            # Isso aqui acontece qdo o bixo aperta ctrl+d
            except EOFError:
                print "Saindo..."
                self.log(8)
                exit(0)


            # Enviando dados e armazenando no log:
            try:
                self.sock.send(data)
                self.log(2,data)

            except socket.error:
                print "Meu servidor caiu 4"
                self.log(7)
                exit(1)

            # Recebendo dados do servidor e atualizando o log
            data = self.sock.recv(1024)
            print "R: %s" % str(data)
            self.log(1,data)

