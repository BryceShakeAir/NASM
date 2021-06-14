section .data
msg1 : db 'Enter the string ',10,0
l1 : equ $-msg1
msg2 : db 'The string is :',10,0
l2 : equ $-msg2
msg3 : db 'The str len is : ',10,0
l3 : equ $-msg3
newline :db 10
section .bss
str : resb 50
n : resd 1

section .text

global _start:
_start:
	push EBP
	mov EBP,ESP
	
	mov EAX,4
	mov EBX,1
	mov ECX,msg1
	mov EDX,l1
	int 80h

	push n 
	push str
	call readStr
	add ESP,8	

	mov EAX,4
        mov EBX,1
        mov ECX,msg2
        mov EDX,l2
        int 80h
	
	push str
	call printStr
	add ESP,4
	
	pop EBP
	mov EAX ,1
	mov EBX,0
	int 80h

readStr:
	push EBP
	mov EBP,ESP
		
;readStr(char *str,int *size)
;{
;	char c;
;	*size = 0
;	while(1)
;	{
;		readChar(&c); you dont need a function for this
;		if(c==10) break;
;		str[size]=c;
;		size++;
;	}
;	str[size]='\0';
;	del c;
;	return;
;}
	mov EAX, dword[EBP+12]
	mov dword[EAX],0 
	push dword 0
	.loop:
		mov ECX, EBP
		sub ECX,4
		mov EAX,3
		mov EBX,1
		mov EDX,1
		int 80h
		
		cmp byte[EBP-4],10
		je .exit
		mov EAX,dword[EBP+8]; EAX  = str;
		mov EBX ,dword[EBP+12]; EBX = size;
		add EAX , dword[EBX]; EAX = size +*str
		
		mov CL , byte[EBP-4]
		mov byte[EAX] ,CL
		;mov byte[EAX], EBX; str[size]==c
		
		mov EBX, dword[EBP+12]
		inc dword[EBX]
		
		jmp .loop
	.exit :
		mov EAX,dword[EBP+8]; EAX  = str;
                mov EBX ,dword[EBP+12]; EBX = size;
                add EAX , dword[EBX]; EAX = size +*str
		mov byte[EAX],0
		
		add ESP,4
		pop EBP
		ret
printStr:
	push EBP
	mov EBP,ESP
;printStr(char *str)
;{
;	int i=0;
;	while(str[i]!='\0')
;	{
;		printf("%c",&str[i])
;		i++
;	}
;	printf("\n");
;}
	push dword 0
	.loop:
		mov EAX , dword[EBP+8]
		add EAX , dword[EBP-4]; str +i
		cmp byte [EAX],0
		je .exit
		
		mov ECX , EAX
		mov EAX,4
		mov EBX,1
		mov EDX,1
		int 80h
	
		inc dword[EBP-4]
		jmp .loop
	.exit:
		mov ECX , newline
                mov EAX,4
                mov EBX,1
                mov EDX,1
		int 80h
		
		add ESP,4
		pop EBP
		ret


		
		
			
		

