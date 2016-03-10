//Brandon S. Parker
//April 18, 2003    
//generator.cc     
//=========================
//**************************************************************
//*               Graph Adj. Matrix Generator:                 *
//*                                                            *
//* Source file: generator.cc   Vers. 1.0                      *
//*                                                            *
//* Input: command line arguments                              *
//*                                                            *
//* Output: console and ASCII file                             *
//*                                                            *
//* Compile with: g++ -o generator generator.cc                *
//*                                                            *
//* Objective: Provide complete graphs for analysis            *
//*                                                            *
//* License: GPL - http://www.gnu.org/copyleft/gpl.html        *
//*                                                            *
//* For more information, see http://www.brandonparker.net     *
//*                                                            *
//* Author:                                                    *
//*  Brandon S. Parker                                         *
//*  (c) 2003 by Brandon S. Parker                             *
//*                                                            *
//**************************************************************

#include <iostream>
#include <stdio.h>
#include <fstream>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>


#define VERSION "1.0"
#define COPYRIGHT "(c)2003 Brandon Parker"

#define INFINITE 65535
#define MAXDIM 60000

//***Prototypes:
int CmdParse(int argv, char *argc[], char filename[], bool *QUIET, int *TYPE, int *MAX_W, int *n);
double getNOWTime();
double getCPUTime();

// Tive que inserir esta linha para funcionar nas versoes mais atuais do g++
using namespace std;

//************
//*** MAIN ***
//************

int main(int argv, char *argc[])
{

//*** Definitions:

srand((unsigned int)getCPUTime()); //*** seed randomize with currect time for uniqueness

char filename[88]; //*** Output filename
strcpy(filename, "AdjMatrix.mtx");

bool QUIET = false; //*** true = print to file, false = print to STDOUT only
int TYPE = 1; 	    //*** graph type: (1) Sparse, (2) Dense, (3) Mid/Random (4) Complete
int MAX_W = 60000; //*** Max weight allowed in the graph. Set to '1' for unweighted
int n = 25; //*** number of graph nodes/ matrix dimension
CmdParse(argv, argc, filename, &QUIET, &TYPE, &MAX_W, &n);
ofstream FILE(filename); //*** ASCII output file



if (!QUIET) FILE<<n<<endl;
cout<<endl<<"Size = "<<n<<endl;

unsigned int AdjMatrix[n][n]; //*** The Adjacency Matrix to be output
for (int i = 0; i < n; i++)
	for (int j = 0; j < n; j++)
		AdjMatrix[i][j] = 0;

//*** create a minimum edge connected graph (sparse)
//*** (See proof in footnote #1)
for (int i = 1; i < n; i++) 
       AdjMatrix[int(rand()%i)][i] = rand()%MAX_W + 1;

switch(TYPE)
	{ // *** Place at least one edge per node
	  // Note: above is the insurance of a connected graph... so the following cases are already connected:
	case 1: //Sparse where Edges << n(n-1)/2
		for(int i,j,k = 0; k <= (n); k++)
                        {
                        i = int(rand()%(n-1) + 1);
                        j = int(rand()%i);
                        AdjMatrix[j][i] = rand()%MAX_W + 1;
                        }

		break;
	case 2: // Dense  where Edges >> n(n-1)/2
		for(int i,j,k = 0; k <= (4 * n * n / 5); k++)
			{
			i = int(rand()%(n-1) + 1);
			j = int(rand()%i);
			AdjMatrix[j][i] = rand()%MAX_W + 1;
			}		
		break;
	case 3: // Mid/Random where Edges ~= n(n-1)/2
		for(int i,j,k = 0; k <= (n * n / 2); k++)
                        {
                        i = int(rand()%(n-1) + 1);
                        j = int(rand()%i);
                        AdjMatrix[j][i] = rand()%MAX_W + 1;
                        }
		break;
	case 4: // Complete where Edges = n
	default:
		 for (int i = 1; i < n; i++)
		    for (int j = 0; j < i; j++)
                        AdjMatrix[j][i] = rand()%MAX_W + 1;
	}

//*** Print it out.
for (int i = 0; i < n; i++)
	{
	for (int j = 0; j < n; j++)
		{
		if (!QUIET) FILE<<AdjMatrix[i][j]<<" ";
		}
	if (!QUIET) FILE<<endl;
	}
cout<<"Finished "<<filename<<"."<<endl;
FILE.close();
return 1;
}

//***************************************
//***		Sub-Routines	     * **
//***************************************



int CmdParse(int argv, char *argc[], char filename[], bool *QUIET, int *TYPE, int *MAX_W, int *n)
{
if (argv < 2)
	{
	cout<<endl<<"Usage: "<<argc[0]<<" <dimensions> [<filename>]"<<endl<<endl;
	exit(1);
	}
for (int i =  0; i < argv; i++)
	{
	if (argc[i][0] == '-')
		switch(argc[i][1])
		{
		  case 'f':
			if((argv > (i+1)) && (argc[i+1][0] != '-'))
				strcpy(filename, argc[i+1]);
			break;
		  case 'v': 
			cout<<endl<<argc[0]<<" Vers. "<<VERSION<<endl<<COPYRIGHT<<endl<<endl;
		  case 'q':
			*QUIET = true;
			break;
		  case 's':
			*TYPE = 1;
			break;
		  case 'd':
			*TYPE = 2;	
			break;
		  case 'r': 
			*TYPE = 3;
			break;
		  case 'c':
			*TYPE = 4;	
			break;
		  case 'w':
			*MAX_W = 1;
			break; 
		  case '?':
		  case 'h':
		  default:
			cout<<endl<<"Usage: "<<argc[0]<<" <dimensions> [-f <filename>] [-vhq]"<<endl;
			cout<<"Version: "<<VERSION<<" "<<COPYRIGHT<<endl<<endl;
			cout<<"  -c	Create a Complete graph."<<endl;
			cout<<"  -d	Create a Dense graph."<<endl;
			cout<<"  -f	Specify filename to write adjacency matrix to."<<endl;
			cout<<"  -h 	Display usage information."<<endl;
			cout<<"  -r	Create a random graph, (Sparse < graph < Dense)."<<endl;
			cout<<"  -s	Create a Sparse graph."<<endl;
			cout<<"  -q 	Print Adjacency Matrix to STDOUT only."<<endl;
			cout<<"  -w	Create an Unweighted graph."<<endl;
			cout<<"  -v 	Displays version information."<<endl;
			cout<<endl<<" Note: Maximum dimension for matrix is "<<MAXDIM<<"."<<endl; 
			cout<<" Output is a randomly generated, weighted (unless the -w flag is used)"<<endl;
			cout<<" adjacency matrix for a graph in ASCII format."<<endl<<endl;

		}
	else if ((i > 0) && (argc[i-1][1] != 'f'))
		 *n = atoi(argc[i]); 
	}
return 1;
}

//************************************************

double getCPUTime()
{
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_usec;
}

//************************************************

double getNOWTime() {
  struct timeval tv;
   gettimeofday(&tv, NULL);
   return tv.tv_sec*1e+06 + tv.tv_usec;
   }

//***************************************
//***              Foot-Notes         ***
//***************************************
//
// ----------------------------------------------------
// 1.) Proof of Connected minimum edge graph algorithm:
// ----------------------------------------------------
// Proof by induction:
// LET:
//	a.) G be a graph of n nodes
//	b.) M[n][n] be the Adjacency Matrix for G.
//	
// Note:
//	a.) For any i such that 0<i<n  M[i][i] is Infinity
//	b.) For any i,j such that 0<i,j<n  M[i][j] = M[j][i]
//		As such, any M[i][j>i] can be disregarded as the
//		contained value is a duplicate.
//
// Algorithm:
//	For each i = 1 to n
//	  choose a value of j such that 0<j<i
//	  Assign a connection and weight to M[i][j]	   
// Proof:
//
// (1) Let n = 2
//	The only edge possible is M[1][0], and a weight and connection
//	is placed at that location by the algorithm. Therefore, the
//	resulting graph is the minimum edge connected graph.
//
// (2) Let n = n + 1;
//	The new node must connect to one of the previous n nodes,
//	and therefore is connected to the rest of the graph maintaining
//	the minimum edge conneceted graph 
//     
// (3) Therefore, by induction, any G of size n will be a connected,
// 	minimum edge graph following the algorithm.
//

