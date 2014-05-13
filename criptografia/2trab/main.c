#include <stdio.h>

/*  O programa assume que:
 *  1. As matrizes sao de ordem 3;
 *  2. A matriz informada no codigo possui inversa;
 *  3. O texto claro sera informado pelo argv[1];
 *  4. O programa funciona direito com letras minusculas.
 */

/* Matriz de ordem 3, seguem os elementos */

/* Linha 1 */
int k11 = 17;
int k12 = 17;
int k13 = 5;

/* Linha 2 */
int k21 = 21;
int k22 = 18;
int k23 = 21;

/* Linha 3 */
int k31 = 2;
int k32 = 2;
int k33 = 19;

void cifra (char a1, char a2, char a3) {

  int c1,c2,c3;

  //printf("cifra: %d %d %d\n",a1,a2,a3);

  c1  = (k11*a1 + k12*a2 + k13*a3) % 26;
  c2  = (k21*a1 + k22*a2 + k23*a3) % 26;
  c3  = (k31*a1 + k32*a2 + k33*a3) % 26;

  //printf("%d %d %d\n",c1,c2,c3);
  printf("%c %c %c\n",c1+97,c2+97,c3+97);
}

int main (int argc, char **argv, char **envp) {

  char s[3];
  FILE *arq;

  arq   = fopen(argv[1],"r");

  while (fscanf(arq,"%3c[a-z]",s) > 0) {
    if (s[0] != '\n' &&
        s[1] != '\n' &&
        s[2] != '\n') {

      //printf("s: %c %c %c\n",s[0],s[1],s[2]);
      cifra(s[0]-97,s[1]-97,s[2]-97);

    } // /if
  }

  return(0);
}
