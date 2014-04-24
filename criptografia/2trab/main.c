#include <stdio.h>
#include <stdlib.h>

/*  O programa assume que:
 *  1. As matrizes sao de ordem 3;
 *  2. A matriz informada no codigo possui inversa;
 *  3. O texto cifrado sera informado pela stdin, e nao pelo *argv[1].
 */

/* Considere a matriz como uma linha unica, cada 3 elementos compoe 1 linha. E
 * todos os numeros devem ser menores q 26 */
int matriz[9] = {
                  17,17,5,
                  21,18,21,
                  2,2,19
                };

char abc[26]  = {
                  'a','b','c','d','e','f','g','h','i','j','k','l','m',
                  'n','o','p','q','r','s','t','u','v','w','x','y','z'
                };

int main () {

  printf("ae %c-%c\n",abc[0],abc[25]);
  exit(0);
}
