section .data
msg1 : db 'Enter the 10 numbers ',010,0
l1 : equ $-msg1 
;arr : db 22 , 32
space : db ' ',0

section .bss
arr : resb 10
c : resb 1
b : resb 1
jnk :resb 1
d : resb 1

section .text

global _start:
_start:
	pusha
	push  arr	

	mov EAX, 1
	mov EBX, 0
	int 80h
	
	call read
	call print
	
	add ESP, 4
	popa
	
	mov EAX, 1
	mov EBX, 0
	int 80h

read :
	push EBP
	mov EBP, ESP
	mov byte[c],0
	.loop :
	mov ECX,0	
	mov CL,byte[c]
	cmp CL ,2
	jae .exit

	add ECX,dword[EBP + 8]
	
	mov EAX, 3
	mov EBX, 0
	mov EDX, 1
	int 80h	
		
	mov EAX, 3
        mov EBX, 0
        mov ECX ,b
	mov EDX, 1
        int 80h	
	
	mov EAX, 3; reading junk
        mov EBX, 0
        mov ECX ,jnk
        mov EDX, 1
        int 80h	

	mov ECX,0	
	mov CL,byte[c]
	add ECX , dword[EBP+8]      	
	
	mov EAX, 4
        mov EBX, 1
        mov ECX ,ECX
	mov EDX, 1
        int 80h		
			
	mov EAX ,0
	mov AL, byte[ECX]
	sub AL, 30h
	mov BL,10
	mul BL
	mov byte[ECX],AL		
		
	mov AL,byte[b]
	sub AL,30h
	add byte[ECX],AL
		
	inc byte[c]
		
	jmp .loop
	.exit :
		add ESP,4
		ret 
	
	
print:
	mov byte[c],0
	push EBP
	mov EBP, ESP
	
	.loop :
	cmp byte[c],2
	jae .exit
	mov EAX,dword[EBP+8]
	add AL,byte[c]
	mov AL,byte[EAX]
	mov AH,0	
	mov BL,10
	div BL
	
	add AL,30h
	mov byte[b],AL
	
	add AH,30h
        mov byte[d],AH	
	
	mov EAX, 4
        mov EBX, 1
        mov ECX ,b
        mov EDX, 1
        int 80h

        mov EAX, 4
        mov EBX, 1
        mov ECX ,d
        mov EDX, 1
        int 80h
		
	mov EAX, 4
        mov EBX, 1
        mov ECX ,space
        mov EDX, 1
        int 80h
		
	inc byte[c]
	jmp .loop
	.exit :
	
	add ESP ,4
	ret


