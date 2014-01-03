#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


#define ALLOCSIZE 8192
static int perform_stuff() {
	while(1) {
		char *stuff=malloc(ALLOCSIZE);
		if(stuff) {
			stuff[ALLOCSIZE-1]=1;
		} else {
			// NO memory, try again after another one OOM'd
			sleep(1);
		}
	}	
}

int main(int argc, char **argv) {
	int maxforks,i,aPid,status;
	maxforks=atoi(argv[1]);
	for(i=0;i<maxforks;i++) {
		aPid=fork();
		if(!aPid) {
			perform_stuff();
		}	
		printf("Forking %d\n",aPid);
	}	
	while(1) {
		wait(&status);
		aPid=fork();
		if(!aPid) {
			perform_stuff();
		}	
		printf("Forking %d\n",aPid);
	}
	return 0;
}
