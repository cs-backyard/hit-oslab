#define __LIBRARY__

#include<stdio.h>
#include<unistd.h>

#define buffer_size 23

_syscall2(int, whoami, char *, name, unsigned int, size);

int main(int argc, char *argv[]){
	char buffer[buffer_size];
	whoami(buffer, buffer_size);
	
	printf("%s\n", buffer);
	return 0;
}
