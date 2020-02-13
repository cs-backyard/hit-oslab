! setup
! be installed to 0x07e0
entry _start
_start:
	! init ss:sp --> 07a0:0200
	mov ax, #0x07a0
	mov ss, ax	
	mov sp, #0x0200


	mov bh, #0
	mov ah,	#3
	int 0x10
	
	mov ax, cs
	mov es, ax
	mov bp, #message
	
	mov cx, #18
	mov bh, #0
	mov al, #1
	mov bl, #4
	mov ah, #0x13
	int 0x10

	! read hard info to 0x90000
	! init ds
	mov ax, #0x9000
	mov ds, ax
	
	! read light point
	mov bh, #0
	mov ah, #3
	int 0x10
	mov [0], dx
	
	! read memory size
	mov ah, #0x88
	int 0x15
	mov [2], ax

	! read disk info
	mov ax, #0
	mov ds, ax
	mov si, [4*0x41]           ! there also can use: lds si, [4*0x41]
	mov ax, [4*0x41+2]
	mov ds, ax
	mov ax, #0x9000
	mov es, ax
	mov di, #4	! di is 4, not 0, because memory and point at font
	mov cx, #16
	cld
	rep 
	movsb
	
	! ready to print computer info
	mov ax, #0x9000
	mov ds, ax
	mov ax, cs
	mov es, ax
	

	! print light point position
	mov bh, #0
	mov ah, #3
	int 0x10
	mov bp, #cursor
	mov cx, #20
	mov bh, #0
	mov al, #1
	mov bl, #2
	mov ah, #0x13
	int 0x10
	mov dx, [0]
	call print_num 
	
	call println
	
	! print memory
	mov bh, #0
	mov ah, #3
	int 0x10
	mov bp, #memory
	mov cx, #20
	mov al, #1
	mov bl, #2
	mov ah, #0x13
	int 0x10
	mov dx, [2]
	call print_num
	call println
	
	! print cyls
	mov bh, #0
	mov ah, #3
	int 0x10
	mov bp, #cyls
	mov cx, #20
	mov al, #1
	mov bl, #2
	mov ah, #0x13
	int 0x10
	mov dx, [4]
	call print_num
	call println
	
	! print head
	mov bh, #0
	mov ah, #3
	int 0x10
	mov bp, #head
	mov cx, #20
	mov al, #1
	mov bl, #2
	mov ah, #0x13
	int 0x10
	mov dl, [6]
	mov dh, #0
	call print_num 
	call println
	
	! print sector
	mov bh, #0
	mov ah, #3
	int 0x10
	mov bp, #sector
	mov cx, #20
	mov al, #1
	mov bl, #2
	mov ah, #0x13
	int 0x10
	mov dx, [18]
	mov dh, #0
	call print_num
	call println		

loopforver:
	jmp loopforver

! dx=number
print_num:
	mov bl, #4
	mov ah, #0x0e
	mov cx, #4
_loopprint:
	rol dx, #4      ! the most high 4 --> the most low 4
	mov al, dl
	and al, #15
	add al, #0x30
	cmp al, #0x3a
	jb _output
	add al, #0x07
_output:
	int 0x10
	loop _loopprint
	
	ret

println:
	mov bl, #4
	mov ax, #0x0e0d
	int 0x10
	mov al, #10
	int 0x10
	ret




message:
	.ascii "Now we in setup!"
	.byte  13, 10

cursor:
	.byte  13, 10
	.ascii "Cursor position : " 
memory:
	.byte  13, 10
	.ascii "Memory size     : "
cyls:
	.byte  13, 10
	.ascii "Cyls number     : "
head:
	.byte  13, 10
	.ascii "Head number     : "
sector:
	.byte  13, 10
	.ascii "Sector number   : "
