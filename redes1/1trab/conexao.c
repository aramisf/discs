#include <stdio.h>
#include <string.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>

#include <netpacket/packet.h>
#include <net/ethernet.h>
#include <net/if.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "conexao.h"

int abreSocket(conexao *conn) {

   //abre o socket
	conn->sock = socket(PF_PACKET, SOCK_RAW, 0);
	if(conn->sock == -1) {
		perror("socket");
		return 0;
	}

	struct ifreq ifr;
	int deviceid;

	memset(&ifr, 0, sizeof(struct ifreq));
	memcpy(ifr.ifr_name, conn->placa_rede,sizeof(conn->placa_rede));
	if(ioctl(conn->sock, SIOCGIFINDEX, &ifr) == -1) {
		perror("ioctl");
		close(conn->sock);
		return 0;
	}
	deviceid = ifr.ifr_ifindex;

   //associacao do dispositivo com o socket
   	struct sockaddr_ll sll;

	memset(&sll, 0, sizeof(sll));

	sll.sll_family = AF_PACKET;
	sll.sll_ifindex = deviceid;
	sll.sll_protocol = htons(ETH_P_ALL);

	if(bind(conn->sock, (struct sockaddr *) &sll, sizeof(sll)) == -1) {
		perror("bind");
		close(conn->sock);
		return 0;
	}

	
	struct packet_mreq mr;

	memset(&mr, 0, sizeof(mr));

	mr.mr_ifindex = deviceid;
	mr.mr_type = PACKET_MR_PROMISC;

	if (setsockopt(conn->sock, SOL_PACKET, PACKET_ADD_MEMBERSHIP, &mr, sizeof(mr)) == -1) {
		perror("setsockopt");
		close(conn->sock);
		return 0;
	}

	return 1;
}

int fechaSocket (conexao *conn) {
	if (close(conn->sock) == -1) {
		perror("close");
		return 0;
	}

	return 1;
}
