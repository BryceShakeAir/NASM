section .data
msg1 : db 'Enter the str : ',10,0
l1 : equ $-msg1
sf :db '%s',0
fd :db '%d',10
s : equ 8
str : equ 12
len : equ 16
start : equ 20
lengt : dd 0

section .bss
string : resb 100

section .text:
	global main
	extern printf
	extern scanf
readStr:
	push EBP
	mov EBP,ESP
		
	push string
	push sf
	call scanf
	add ESP,8
	
	pop EBP
	ret

printNum:
	push EBP
	mov EBP,ESP
	
	push dword[EBP+8]
	push fd
	call printf
	add ESP,8
	
	pop EBP
	ret
;int occur(char s,char *string,int len,int start)
;{
;	int i=0;
;	while(i<len)
;	{
;		if(str[i+start]==s) return 1;
;		i++;
;	}
;	return 0;
;}
occur :
	push EBP
	mov EBP,ESP
	push dword 0
	
	.loop:	
		mov EAX ,dword[EBP-4]
		cmp EAX , dword[EBP+len]
		jae .exit1
			mov EAX ,dword[EBP-4] 
			add EAX , dword[EBP+start]
			add EAX , dword[EBP+str] ;str +start +i
			mov BL,byte[EAX];
			cmp BL,byte[EBP+s]
			je .exit
			inc dword[EBP-4]
			jmp .loop		
			
	.exit1:
		mov EAX , 0
		add ESP,4
		pop EBP
		ret
	.exit:
		mov EAX , 1
		add ESP,4
		pop EBP
		ret		

;int findMin(char s,char *string,int len)
;{
;	int j=1
;	while(j<=len)
;	{	
;		int i=0
;		while(i<(len-j+1))	
;		{
;			if(occur(s,str,j,i)!=1) break;
;			else1:i=i+1		
;		}
;		if(i==len-j+1) return j;
;		j++;
;	}
;}
findMin:
	push EBP
	mov EBP,ESP
	push dword 1
		
	.loop1:
		mov EAX,dword[EBP+len]
		cmp dword[EBP-4],EAX
		;cmp dword[EBP-4],1		
		ja .exit
		
		push dword 0 ; EBP-8 i
		.loop2:
			mov EAX,dword[EBP+len]
			sub EAX ,dword[EBP-4]
			inc EAX
			cmp dword[EBP-8],EAX
			jae .exit1
			;if(occur(s,str,i,j)!=1) break;
			;i=i+1	
			
				push dword[EBP-8]
				push dword[EBP-4]				
				push dword[EBP+str]
				push dword[EBP+s]
				
				call occur
				add ESP,16
				
				cmp EAX ,1
				je .else1
				
				jmp .exit1
					
				.else1:
				inc dword[EBP-8]
				jmp .loop2			
		.exit1:
			mov EBX,dword[EBP+len]
			sub EBX ,dword[EBP-4]
			inc EBX
			cmp dword[EBP-8],EBX
			jne .else
			
			pusha
			push dword[EBP-4]
			call printNum
			add ESP,4
			popa			
		
			mov EAX, dword[EBP-4]
			add ESP,8
			pop EBP
			ret 	
		.else :
			add ESP,4			
			inc dword[EBP-4]
			jmp .loop1
	.exit:
		mov EAX,0
		add ESP,4
		pop EBP
		ret
;int minOcc(char *string,int len)
;{
;	int i=0;
;	int min=0;
;	int j=0;
;	while(i<len)
;	{
;		j = findMin(string[i],string,len)	
;		if(j<min) min = j; 		
;		i++;
;	}
;	return min
;}
minOcc:
	push EBP
	mov EBP,ESP
	push dword 0 	
	push dword 100
	push dword 0
	.loop:
		mov EAX , dword[EBP-4]
		cmp EAX , dword[EBP+12]
		;cmp EAX ,1
		jae .exit
		
		mov EBX , dword[EBP+8]
		add EBX ,dword[EBP-4]
		mov EAX ,0
		mov AL, byte[EBX] ; str[i]
		
		push dword[EBP+12]		
		push dword[EBP+8]		
		push EAX
		call findMin
		
		mov dword[EBP-12],EAX
		add ESP,12
		cmp EAX , dword[EBP-8]
		jae .else
		mov dword[EBP-8],EAX
		push EAX
		call printNum
		add ESP,4 		
					
		.else:
		inc dword[EBP-4]
		jmp .loop
		
	.exit:
		mov EAX ,dword[EBP-8]
		add ESP,12
		mov ESP,EBP		
		pop EBP
		ret
		
	
;int len(char *str)
;{
;	int i=0;
;	while(str[i]!='\0') i++:
;	return i;
;}
length:
	push EBP
	mov EBP,ESP
	push dword 0 		
	.loop:
		mov EAX , dword[EBP+8] ; EAX = str
		add EAX , dword[EBP-4]
	
		mov BL,byte[EAX]
		
		cmp BL,0
		je .exit
		
		inc dword[EBP-4]
		jmp .loop
	.exit:
	mov EAX , dword[EBP-4]
	add ESP,4
	mov ESP,EBP
	pop EBP
	ret

main:
	mov EAX ,4
	mov EBX ,1
	mov ECX ,msg1
	mov EDX,l1
	int 80h
	
	call readStr
	
	push string
	call length
	add ESP,4

	mov dword[lengt],EAX
	push dword[lengt]
	call printNum
	add ESP,4
	
	;int minOcc(char *string,int len)
	push dword[lengt]	
	push string
	call minOcc
	add ESP,8
	
	push EAX	
	call printNum
	add ESP,4	
		
	mov EAX ,1
	mov EBX,0
	int 80h 
