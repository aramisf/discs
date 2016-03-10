#ifndef _AvlTree_H
#define _AvlTree_H

#include <stdio.h>
#include <stdlib.h>

typedef double ElementType;
typedef struct AvlNode *Position;
typedef struct AvlNode *AvlTree;

typedef struct AvlNode {

    int quant;
	ElementType Element;
	AvlTree  Left;
	AvlTree  Right;
	int      Height;
} AvlNode;

AvlTree MakeEmpty( AvlTree T );
Position Find( ElementType X, AvlTree T );
Position FindMin( AvlTree T );
Position FindMax( AvlTree T );
AvlTree Insert( ElementType X, AvlTree T );
void printTree( AvlTree T, unsigned int *cont );
double Retrieve( Position P );

#endif

