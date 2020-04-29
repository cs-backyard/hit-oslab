#define __LIBRARY__

#include<stdio.h>
#include<unistd.h>

_syscall1(int, iam, const char *, name);

int main(int argc, char *argv[]){
	if(argc != 2){
		return 0;
	}
	iam(argv[1]);	
	return 0;
}
