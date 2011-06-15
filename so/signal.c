#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>

void signal_handler_function (int iSignal) {

	if (iSignal == SIGUSR1) {
		if (signal (iSignal,signal_handler_function) == SIG_ERR) {
			fprintf(stderr,"Erro na reinstalacao de signal handler\n");
			fprintf(stderr,"Sinal: %d.\n",iSignal);
		}
		printf ("\nO processo filho digitou um numero par\n");
	}
	else if (iSignal == SIGCHLD) {
		int iStatus;
		printf ("\nO processo filho terminou seu processamento\n");

		wait(&iStatus);
		if (WIFEXITED(iStatus))
			printf ("Termino normal: %d\n",WEXITSTATUS(iStatus));
		else if (WIFSIGNALED(iStatus))
			printf ("Cancelado por sinal: %d\n",WTERMSIG(iStatus));
		exit(0);
	}
}

int main (int argc, char **argv) {

	int iPid;

	if (signal(SIGUSR1, signal_handler_function) == SIG_ERR ||
		signal(SIGCHLD, signal_handler_function) == SIG_ERR) {

		perror (argv[0]);
		exit(errno);
	}

	printf ("Criando um processo filho\n");
	iPid = fork ();
	if (iPid < 0) {
		perror(argv[0]);
		exit(errno);
	}

	if (iPid != 0) { /* Processo pai */
		while (1)
			sleep(2);
	}

	if (iPid == 0) { /* Processo filho */
		int iVlr;
		printf ("Executando um processo filho\n");
		while (1) {
			printf ("Digite um numero: (0 p/ sair) ");
			scanf ("%d", &iVlr);

			if (iVlr == 0)
				break;

			if ((iVlr % 2) == 0) 
				if (kill(getppid(),SIGUSR1) < 0){
					perror(argv[0]);
					exit(errno);
				}
		}
	}

	exit(0);
}

