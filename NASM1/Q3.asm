section .data

i : db '0'
msg : db 'n is', 10
l :equ $-msg

section .bss

n : resb 1

section .text

global _start:
_start :
	mov EAX, 4
	mov EBX, 1
	mov ECX, msg
	mov EDX, l
	int 80h
	
	mov EAX, 3
        mov EBX, 0
	mov ECX, n
	mov EDX, 1 
	int 80h
	
	mov EAX, 4
        mov EBX, 1
        mov ECX, n
        mov EDX, 1
        int 80h
		
        sub byte[n], 30h
	mov AH,byte[n]
	mov EAX, 4
        mov EBX, 1
        mov ECX, n
        mov EDX, 1
        int 80h

	mov EAX, 1
        mov EBX, 0
        int 80h
	


 
