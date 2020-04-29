#define __LIBRARY__
#include<unistd.h>
#include<asm/segment.h>
#include<errno.h>

#define NAME_MAX_SIZE	23

char my_name[NAME_MAX_SIZE];
int name_length = 0;

int sys_iam(const char *name){
	char buffer[NAME_MAX_SIZE+1];
	int num = 0;
	while(get_fs_byte(name) && num < NAME_MAX_SIZE){
		buffer[num++] = get_fs_byte(name++);
	}

	if(get_fs_byte(name)){
		return -EINVAL;
	}
	buffer[num] = '\0';
	strcpy(my_name, buffer);
	name_length = num;
	return num;
}


int sys_whoami(char *name, unsigned int size){
	if(name_length > size){
		return -EINVAL;
	}
	int i = 0;
	while(i < name_length){
		put_fs_byte(my_name[i++], name++);	
	}
	return name_length;
}
