#!/usr/bin/env python

from math import *
import sys

class ponto(object):

    def __init__(self,l):

        # Definindo classe e valores de caracteristicas
        self.classe = l[132]
        self.caracts = l[:-1]

        for p in range(len(self.caracts)):
            self.caracts[p] = float(self.caracts[p])


class cavizinhos(object):
# Pulta estruturaLindaMeu! Essa classe armazena o ponto e os seus k vizinhos,
# bem como a classe de cada um, numa lista de tuplas!

    def __init__(self,ponto,lista_de_pontos,k):

        # Guarda a classe do candidato
        self.classe_candidato = ponto.classe

        # Armazena os k vizinhos
        self.kv = []

        # Armazena a dist euclidiana e a classe de um possivel vizinho
        self.k_viz_tmp= []
        self.dist_euclid_tmp = 0.0

        # Calcula a distancia entre o ponto a e o ponto b
        for i in range(len(lista_de_pontos)):
            self.calcula_dists(ponto,lista_de_pontos[i])

        # Classifica:
        self.avaliacao = self.classifica(self.classe_candidato,self.kv)


    def calcula_dists(self,pa,pb):

        # Reinicia com zero:
        self.dist_euclid_tmp = 0.0


        for i in range(len(pa.caracts)):
            self.dist_euclid_tmp += pow((pa.caracts[i]-pb.caracts[i]),2)

        self.k_viz_tmp = [sqrt(self.dist_euclid_tmp),pb.classe]

        if len(self.kv) < k:
            self.kv.append(self.k_viz_tmp)
            self.kv.sort()

        else:
            for j in range(len(self.kv)):
                if self.kv[j][0] > self.k_viz_tmp[0]:
                    self.kv.insert(j,self.k_viz_tmp)
                    self.kv.pop()
                    break

    # Recebe como parametro a classe do candidato e os k vizinhos, retorna uma
    # lista com as coordenadas do ponto na matriz. Escolhendo a maior classe
    # como eleita
    def classifica(self,classe_candidato,kv):

        count_temp = []
        lista_temp = [ kv[i][1] for i in range(len(kv)) ]

        for i in range(10):
            count_temp.append([lista_temp.count(str(i)),i])
        count_temp.sort()

        #print "return: ",count_temp
        return [classe_candidato,count_temp[-1][1]]

# Imprime a matriz de confusao, que contem os valores calculados dos vizinhos de
# cada ponto e suas classes. Contem tb a classe do ponto avaliado.
# Recebe como parametro o objeto resultante de cavizinhos, que contem classe do
# candidato e seus vizinhos.
def matriz_confusao(k_viz):

    mt=[]
    for i in range(10):
        mt.append([])
        for j in range(10):
            mt[i].append(0)

    def atualiza_matriz(coordenadas):

        mt[int(coordenadas[0])][int(coordenadas[1])] += 1

    # Conta a classe q mais apareceu. As classes vao de 0 a 9:
    for i in k_viz:
        atualiza_matriz(i.avaliacao)

    for i in range(len(mt)):
        print mt[i]


treino = open("training",'r')
base_de_treino = [ i.strip() for i in treino ]

teste = open("testing",'r')
base_de_teste = [ f.strip() for f in teste ]

# Removendo a primeira linha, que contem apenas 2 colunas:
del base_de_treino[0]
del base_de_teste[0]

# len(l_pontos) == 1000
l_pontos = [ a.split() for a in base_de_treino ]
l_candidatos = [ b.split() for b in base_de_teste ]


# Duas listas para armazenar os pontos
base_aprendida = []
base_candidata = []


# Criando a base com os pontos aprendidos, transformados de str para float
for i in range(len(l_pontos)):
    base_aprendida.append(ponto(l_pontos[i]))


# Criando a base com os pontos candidatos [2]
for i in range(len(l_candidatos)):
    base_candidata.append(ponto(l_candidatos[i]))


if len(sys.argv) == 2:
    k = int(sys.argv[1])
else:
    k = int(raw_input("Digite o valor de K desejado "))

k_vizinhos = []

for i in range(len(base_candidata)):
    k_vizinhos.append(cavizinhos(base_candidata[i],base_aprendida,k))

# Imprime matriz de confusao
matriz_confusao(k_vizinhos)

#    print "Classe: "+kv.classe_candidato,
#    print "\nClasse dos vizinhos: "
#    for i in range(len(kv.kv)):
#       #result.write(kv.kv[i][1])
#        print kv.kv[i][1],
#    print
#   #result.write("\n")
#   #result.write(taxa_de_acerto(kv))
#result.close()


