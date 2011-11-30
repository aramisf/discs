#!/usr/bin/env python

# The intent of this file is to have some useful functions. The ones that comes
# to my mind right now are reading a graph, check for a (in)?valid graph.

# Receives a file with a matrix representation of a graph
def readGraph (GraphFileFP):

    f = open(GraphFileFP, 'r')
    aux_list = [ i.strip() for i in f.readlines() ]

    # A big list, chosen to represent the graph. The degree of a vertex x is:
    # - myGraph[x].count('1').
    myGraph = [ i.split() for i in aux_list ]

    f.close()
    return myGraph
