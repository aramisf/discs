#!/usr/bin/env python
# -*- coding: utf-8 -*-

# servidor.py

import socket, time
from datetime import datetime

class Servidor(object):

    def __init__(self,ME,MINHA_PORTA,l_hosts,l_ports,logFP):

        self.ME = ME
        self.DATA = ''
        self.PORT = MINHA_PORTA
        self.INDICE = l_hosts.index(self.ME)
        self.MAX_HOSTS = len(l_hosts)
        self.logFile = logFP
        self.l_hosts = l_hosts
        self.l_ports = l_ports


    def log(self,msg,maq='cliente'):

        ''' diferentes niveis de log:
           0 - inicio
           1 - recebimento de mensagem
           2 - envio de mensagem
           3 - tentativa de conexao ipv6
           4 - conexao ipv6 indisponivel, mudando para ipv4
           5 - conexao IPV6 efetuada
           6 - conexao IPV4 efetuada
           7 - conexao perdida
           8 - desligamento do servidor
        '''
        textmsg = [ "\nIniciando "+self.ME+" em modo servidor: "+datetime.now().ctime()+"\n",
                    self.ME+" diz: Recebi "+str(self.DATA)+": "+datetime.now().ctime()+"\n",
                    self.ME+" diz: Enviei "+str(self.DATA)+": "+datetime.now().ctime()+"\n",
                    self.ME+" diz: tentando conectar usando ipv6 -. "+datetime.now().ctime()+"\n",
                    self.ME+" diz: ipv6 falhou, usando ipv4 - "+datetime.now().ctime()+"\n",
                    self.ME+" diz: conexao IPv6 efetuada - "+datetime.now().ctime()+"\n",
                    self.ME+" diz: conexao IPv4 efetuada - "+datetime.now().ctime()+"\n",
                    self.ME+" diz: sem conexao com "+str(maq)+" - "+datetime.now().ctime()+"\n",
                    self.ME+" -> desligando... - "+datetime.now().ctime()+"\n"
                  ]

        self.logFile.write(textmsg[msg])


    def fala(self,para_onde): # para_onde eh um socket

        # Enviando dados e armazenando no log:
        try:
            para_onde.send(self.DATA)

            # Testa aqui se self.DATA nao eh vazio, isso faz diferenca no log.
            if self.DATA:
                self.log(2)


        except socket.error:

            print self.MEU_SERVIDOR+" parece estar desconectado\n"

            # Registrando isso no log:
            self.log(7,self.MEU_SERVIDOR)

            # Registrando saida:
            self.log(8)
            exit(1)



    def escuta(self, de_onde): # de_onde eh um socket

        # Recebe os dados.
        try:
            self.DATA = de_onde.recv(1024)
            if self.DATA:
                self.log(1)

        except socket.error:
            print self.MEU_SERVIDOR+" parece estar desconectado\n"

            # Registrando isso no log:
            self.log(7,self.MEU_SERVIDOR)

            # Registrando saida:
            self.log(8)
            exit(1)



    def start(self):

        # Registra no log o inicio do servidor:
        self.log(0)


        # Caso 3 possui uma unica conexao (1 cliente, 0 servidor):
        if self.INDICE == (self.MAX_HOSTS - 1):

            self.conecta_maquina_N()

            while True:

                # Recebe os dados
                self.escuta(self.clientConn[0])

                # Mostra na tela o que recebeu:
                print "Recebi expressao %s" % self.DATA

                # Efetua a operacao aritmetica, se ela estiver correta:
                try:
                    self.DATA = str(eval(self.DATA))

                except:
                    self.DATA = 'Qual parte do \'aritmetica\' vc nao entendeu?'

                print "Enviando resposta..."
                self.fala(self.clientConn[0])

        # Se nao for o caso 3, pode ser o caso 1 ou 2
        else:

            self.conecta_caso_generico()

            while True:

                # Escuta da maquina anterior:
                self.escuta(self.clientConn[0])
                if not self.DATA: break

                else:
                    self.fala(self.sock_servidor)

                # Aguarda resposta:
                self.escuta(self.sock_servidor)
                if not self.DATA: break

                else:
                    # Envia resposta
                    self.fala(self.clientConn[0])



    # Cria a conexao para o cliente:
    def conecta_cliente(self,PORT):
        ''' Cria a conexao, primeiro tenta fazer ipv6, se falhar faz ipv4
        '''

        # Abrindo socket IPv6:
        try:
            # Criando a conexao para escutar o cliente. Novamente, como na
            # implementacao o modelo eh deterministico, nao eh necessario
            # checar quem eh o cliente, apenas uma maquina tentara acessar esta
            # maquina por esta porta
            self.log(3)
            self.sock_cliente = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
            self.sock_cliente.bind(('', PORT))
            self.log(5)

        except socket.error:
            print "Nao foi possivel abrir o socket para IPv6"
            self.log(4)

            try:
                # Usando IPv4:
                self.sock_cliente = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                self.sock_cliente.bind(('', PORT))
                self.log(6)

            except socket.error:
                print "Conexao IPv4 falhou"
                self.log(7)
                exit(1)

        self.sock_cliente.listen(3)
        self.clientConn = self.sock_cliente.accept()
        print "Meu cliente: ",self.clientConn[0].getsockname()


    # Cria uma conexao com o servidor;
    def conecta_meu_servidor(self,HOST,PORT):

        # Tenta fazer a conexao com IPv6:
        try:
            self.log(3)
            self.sock_servidor = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
            self.sock_servidor.connect((HOST, PORT))
            self.log(5)

        except socket.error:
            self.log(4)

            try:
                # Tenta o IPv4:
                self.sock_servidor = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                self.sock_servidor.connect((HOST, PORT))
                self.log(6)

            except socket.error:
                print HOST+" parece estar desconectado\n"

                # Registrando isso no log:
                self.log(7,HOST)

                # Registrando saida:
                self.log(8)
                exit(1)

        print "Meu servidor: ",self.sock_servidor.getpeername()


    def conecta_caso_generico(self):
        ''' Eh quando o servidor nao eh o ultimo da lista, ou seja, ele deve
        esperar uma conexao vinda de uma maquina qualquer, portanto, ele nao
        define um cliente, apenas um servidor ao qual se conectar.
        '''

        # Definindo caracteristicas da conexao do servidor (basta saber a porta):
        self.PORTA_ESCUTA = self.l_ports[self.l_hosts.index(self.ME)]

        # Conecta com o cliente:
        self.conecta_cliente(self.PORTA_ESCUTA)

        # Conecta com o Servidor:
        self.MEU_SERVIDOR = self.l_hosts[self.l_hosts.index(self.ME)+1]
        self.PORTA_FALA = self.l_ports[self.l_hosts.index(self.ME)+1]

        self.conecta_meu_servidor(self.MEU_SERVIDOR,self.PORTA_FALA)


    def conecta_maquina_N(self):
        ''' Eh quando o servidor eh o ultimo, ele vai apenas ouvir na
        porta dele, efetuar a operacao matematica e devolver o resultado.
        '''

        self.PORTA_ESCUTA = self.l_ports[-1]

        # Conecta com o cliente:
        self.conecta_cliente(self.PORTA_ESCUTA)

        # Usando erroneamente a variavel, na verdade a referencia aqui eh para o
        # meu cliente, e nao para o servidor. Essa linha descobre o nome do
        # cliente, dado o ip.
        self.MEU_SERVIDOR = socket.gethostbyaddr(self.clientConn[1][0])[0].split('.')[0]

