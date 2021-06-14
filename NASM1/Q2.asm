section .data
msg: db 'Write your name : ',10 
l1: equ $-msg 
section .bss
name: resb 4
section .text

global _start:
_start :
	mov EAX, 4
	mov EBX, 1
	mov ECX, msg
	mov EDX, l1
	int 80h
	
	mov EAX, 3
	mov EBX, 0 
	mov ECX, name
	mov EDX, 4
	int 80h
	
	mov EAX, 4
        mov EBX, 1
        mov ECX, name
        mov EDX, 4
        int 80h	

	mov EAX, 1 
	mov EBX, 0 
	int 80h

	
