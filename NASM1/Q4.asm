section .data
msg1 : db 'Enter the 1st number : ',10
l1 :equ $-msg1
msg2 : db 'Enter the 2nd number : ',10
l2 :equ $-msg2

section .bss
a : resb 2
b : resb 2
c : resb 1
d : resb 1
section .text

global _start
_start :

	mov EAX, 4
	mov EBX, 1
	mov ECX, msg1
	mov EDX,l1
	int 80h
	
	mov EAX ,3
	mov EBX ,0
	mov ECX ,a
	mov EDX ,2
	int 80h 
		
	mov EAX, 4
        mov EBX, 1
        mov ECX, msg2
        mov EDX,l2
        int 80h
	
	mov EAX ,3
        mov EBX ,0
        mov ECX ,b
        mov EDX ,2
        int 80h
	
	sub byte[a],30h
	sub byte[b],30h
	
	mov AL, byte[a];
	mov AH, byte[b];
	add AH, AL
	
	cmp AH, 10
	jb else
	
	mov AL , 10	
	sub AH,AL
	mov byte[c],AH
        add byte[c], 30h

	mov byte[d],49	
	mov EAX, 4
        mov EBX, 1
        mov ECX,d
        mov EDX,1
        int 80h	
	
        mov EAX, 4
        mov EBX, 1
        mov ECX, c
        mov EDX,1
        int 80h

        mov EAX,1
        mov EBX,0
        int 80h


	else :
	mov byte[c],AH
        add byte[c], 30h

        mov EAX, 4
        mov EBX, 1
        mov ECX, c
        mov EDX,1
        int 80h
	
	mov EAX,1
	mov EBX,0
	int 80h



