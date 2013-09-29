#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This is a class to make a representation of a graph.
class Graph(object):

    def __init__(self, AdjMtrxFP):

        self.size = int(AdjMtrxFP.readline().strip())

        self.mtrx = [ i.strip() for i in AdjMtrxFP.readlines() ]

class TreeDecomposition(object):

    # A Tree Decomposition is a set of sets, each of which has some vertices of
    # the original graph. An object was creeated to represent the graph.

    #XXX: Graph must be an object, as the subset must.

    def __init__(self, graph, subset):



