#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This is a class to make a representation of a graph.

# Here is where all the magic happens ;)

# Main class, where `graph' is a representation of a graph, and k is the value
# for the maximum desired treewidth.
class TreeDecomposition(object):

    # A Tree Decomposition is a set of sets, each of which has some vertices of
    # the original graph. An object was creeated to represent the graph.

    #XXX: Graph must be an object, as the subset must.

    def __init__(self, graph, k = None):

        if not k:
            self.simpleDecomposition (graph)

        else:
            self.kDecomposition (graph)

        # A list to represent the graph
        self.DecomposedTree = []


