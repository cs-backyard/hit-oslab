! show str in screen
entry _start
_start:
	mov bh, #0
	mov ah,	#3
	int 0x10
	
	mov ax, #0x07c0
	mov es, ax
	mov bp, #message
	
	mov cx,  #40
	mov bh, #0
	mov al, #1
	mov bl, #4
	mov ah, #0x13
	int 0x10
	
	mov bx, #0x0200
load_setup:
	mov al, #2
	mov ch, #0
	mov cl, #2
	mov dh, #0
	mov dl, #0
	mov ah, #2
	int 0x13
	! read success
	jnc load_setup_success
	! read failed
	mov dl, #0
	mov ah, #0
	int 0x13
	jmp load_setup
	 
load_setup_success:
	jmpi 0, 0x07e0
	
message:
	.ascii "Hello OS World, my name is lambdafate!"
	.byte  13, 10

	.org 510
	.byte 0x55, 0xAA
