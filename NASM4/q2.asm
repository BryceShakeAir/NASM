section .text
msg1 : db 'str :',10,0
l1 : equ $-msg1
msg2 : db 'The most freq is : ',0
l2 : equ $-msg2
len : dd 0
f1 : db '%s',0
f2 : db '%s',10
space : db ' ' 
new : db 10

section .bss
str : resb 100

section .text

extern scanf
extern printf
global main

readStr:
	push EBP
	mov EBP,ESP
	
	push str
	push f1
	call scanf
	add ESP,8
	
	pop EBP
	ret
printStr:
	push EBP
	mov EBP,ESP
	
	push dword 10
	push dword 0	
	.loop:
		mov AL,byte[EBP-4]
		cmp AL,0
		je .exit
							
		mov ECX ,str
		add ECX ,dword[EBP-8]
		mov AL,byte[ECX]
		mov byte[EBP-4],AL		
		mov EAX ,4
		mov EBX ,1
		;mov ECX ,space
		mov EDX ,1
		int 80h
	
		inc dword[EBP-8]
		jmp .loop	
		
	.exit:
	
	mov EAX, 4
	mov EBX,1
	mov ECX ,new		
	mov EDX ,1
	int 80h
	
	add ESP,8
	pop EBP
	ret
	
main:
	mov EAX,4
	mov EBX,1
	mov ECX,msg1
	mov EDX,l1
	int 80h
	
	call readStr
	call printStr
	
	mov EAX,1
	mov EBX,0
	int 80h

