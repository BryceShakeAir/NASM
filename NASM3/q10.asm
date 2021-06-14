section .data
msg1 : db 'Enter the string :',10,0
l1 : equ $-msg1
msg2 : db 'The # of a is : ',10,0
l2 : equ $-msg2
msg3 : db 'The # of e is : ',10,0
l3 : equ $-msg3
msg4 : db 'The # of i is : ',10,0
l4 : equ $-msg4
msg5 : db 'The # of o is : ',10,0
l5 : equ $-msg5
msg6 : db 'The # of u is : ',10,0
l6 : equ $-msg6
a : dd 0
e : dd 0
i : dd 0
o : dd 0
u : dd 0
a_char : db 'a'
e_char : db 'e'
i_char : db 'i'
o_char : db 'o'
u_char : db 'u'
size : dd  0
bug : dd 0
section .bss

str : resb 100 

section .text

global _start
_start:
	push EBP
	mov EBP,ESP
	
	push size
	push str	
	call readStr
	add ESP,8
	
	push dword[size] 
	push str
	call checkStr
	add ESP,8
	
	mov EAX,4
	mov EBX,1
	mov ECX,msg2	
	mov EDX,l2
	int 80h
	
	push dword[a]
	call printNum
	add ESP,4
		
	mov EAX,4
	mov EBX,1
	mov ECX,msg3	
	mov EDX,l3
	int 80h
	
	push dword[e]
	call printNum
	add ESP,4
	
	mov EAX,4
	mov EBX,1
	mov ECX,msg3	
	mov EDX,l3
	int 80h
	
	push dword[i]
	call printNum
	add ESP,4
	
	mov EAX,4
	mov EBX,1
	mov ECX,msg4	
	mov EDX,l4
	int 80h
	
	push dword[i]
	call printNum
	add ESP,4
	
	mov EAX,4
	mov EBX,1
	mov ECX,msg5	
	mov EDX,l5
	int 80h
	
	push dword[o]
	call printNum
	add ESP,4
	
	mov EAX,4
	mov EBX,1
	mov ECX,msg6	
	mov EDX,l6
	int 80h
	
	push dword[u]
	call printNum
	add ESP,4
		
	mov EAX ,1
	mov EBX,0
	int 80h
	pop EBP
	ret
readStr :
	push EBP
	mov EBP,ESP
	;void readStr(char *str,int *size)
	;{
	;	char c;
	;	while(1)
	;	{
	;		getchar(c)
	;		if(c==10) break;
	;		c = c-30h;
	;		*(str+*size) = c;			
	;		*size++;
	;	}
	;	*(str+*size) = 0;
	;	del c
	;}
	push dword 0
	.loop:
		mov ECX,EBP
		sub ECX,4
		mov EAX,3
		mov EBX,1
		mov EDX,1
		int 80h
				
		cmp byte[EBP-4],10
		je .exit
		
		sub byte[EBP-4],30h
		mov EAX , dword[EBP+12]; EAX  = size
		mov EBX , dword[EBP+8]
		add EBX , dword[EAX] ; EBX = str + *size
		mov CL,byte[EBP-4]
		mov byte[EBX], CL
		inc dword[EAX]
		jmp .loop
	.exit :
		mov EAX , dword[EBP+12]; EAX  = size
		mov EBX , dword[EBP+8]
		add EBX , dword[EAX] ; EBX = str + *size
		mov byte[EBX] , 0
		
		add ESP,4
		pop EBP
		ret	 
checkStr:
	push EBP
	mov EBP,ESP
	;void checkStr(char *str,int size)
	;{
	;	int i =0;
	;	while(i<size)
	;	{
	;		if(str[i]=='a')
	;			a++;
	;		else1 if(str[i]=='e')
	;			e++
	;		else2 if(str[i]=='i')
	;			i++	;
	;		else3 if(str[i]=='o')
	;			o++
	;		else4 if(str[i]=='u')
	;			u++
	;		else 5 i++;	
	;	}				
	;	del i	
	;}
	push dword 0
	.loop :
		mov EAX , dword[EBP-4]
		cmp EAX , dword[EBP+12]
		jae .exit
		
		add EAX , dword[EBP+8]
		mov AL , byte[EAX]
		
		cmp AL , byte[a_char]
		jne .else1
		inc dword[a]
		
		.else1:	
		cmp AL , byte[e_char]
		jne .else2
		inc dword[e]
		
		.else2:
		cmp AL , byte[i_char]
		jne .else3
		inc dword[i]
		
		.else3:
		cmp AL , byte[o_char]
		jne .else4
		inc dword[o]
		
		.else4:
		cmp AL , byte[u_char]
		jne .else5
		inc dword[u]
		
		.else5:
		inc dword[EBP-4]
		jmp .loop
	.exit:
		add ESP,4
		pop EBP
		ret		
printNum :
	push EBP
	mov EBP,ESP
	push dword 0
	;void printNum(int a)
	;{
	;	int size=0;
	;	EAX = a;
	;	if(EAX ==0)
	;	printf(0) 
	;	while(EAX!=0)
	;	{
	;		EDX = EAX%10
	;		push EDX
	;		size++;
	;	}
	;	while(size!=0)
	;	{
	;		pop dword[bug]
	;		print bug
	;		size--	
	;	}
	;}
	mov EAX , dword[EBP+8]
	cmp EAX ,0
	jne .continue
	mov byte[bug],30h
	mov EAX ,4
	mov EBX,1
	mov ECX,bug
	mov EDX ,1
	int 80h
	
	.continue:
	mov EAX , dword[EBP+8]
	mov EBX , 10
	.loop1:
		cmp EAX ,0
		je .loop2
		
		mov EDX ,0		
		div EBX
		push EDX 
		inc dword[EBP-4]
		jmp .loop1
	.loop2:
		cmp dword[EBP-4],0
		je .exit
		pop dword[bug]
		add byte[bug],30h
		
		mov EAX ,4
		mov EBX,1
		mov ECX ,bug
		mov EDX ,1
		int 80h
		dec dword[EBP-4]
		jmp .loop2
	.exit:
		add ESP,4
		pop EBP
		ret
	 		
				
				
	
	
