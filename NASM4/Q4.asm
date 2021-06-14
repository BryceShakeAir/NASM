section .data
msg1 : db 'Enter the str : ',0 ,10
l1 : equ $-msg1
msg2 : db 'Reversed str is : ',0 ,10
l2 : equ $-msg2
str : times 5000 db 0
n : dd 0
len : times 50 dd 0
str1: equ 8
str2: equ 12
len1 : equ 16
len2: equ 20

section .text

global _start
_start:
	push EBP
	mov EBP,ESP
	
	mov EAX,4
	mov EBX,1
	mov ECX,msg1
	mov EDX,l1
	int 80h
	
	push n
	push len
	push str
	call readStr	
	add ESP,12
	
	push dword[n]
	push len
	push str
	call reverse
	add ESP,12
	
	mov EAX,4
        mov EBX,1
        mov ECX,msg2
        mov EDX,l2
        int 80h
	
	push dword[n]
	push len
	push str
	call printStr
	add ESP,12

	pop EBP
	mov EAX , 1
	mov EBX , 0
	int 80h
;void printStr(char *str,int *len,int n)
;{
;	int i=0;	
;	while(i<n)
;	{
;		print(str+i*100,len+i*4)
;		i++
;	}
;	add ESP,4
;}
printStr:
	push EBP
	mov EBP,ESP
	push dword 0
	.loop:
		mov EAX,dword[EBP-4]
		cmp EAX , dword[EBP+16]
		jae .exit
		
		mov EBX ,100
		mov EDX ,0
		mul EBX
		add EAX ,dword[EBP+8]
		push EAX
		
		mov EAX,dword[EBP-4]
		shl EAX,2
		add EAX ,dword[EBP+12]
		mov EDX, dword[EAX]
		pop ECX
		mov EAX ,4
		mov EBX,1
		int 80h
		
		inc dword[EBP-4]
		jmp .loop
	.exit:
		add ESP,4
		pop EBP
		ret
		
;int readWord(char *str,int *len)
;{
;	char c == 1
;	while(c!=0 || c!=10)
;	{
;		c = scanf
;		*(str +*len) = c;
;		*len = *(len) +1
;	}
;	 *(str +*len) = 0;
;	if(c==0) return 1;
;	else return 0;
;	add ESP,4
;}
readWord:
	push EBP
	mov EBP,ESP
	push dword 1
	.loop:
		mov ECX , EBP
		sub ECX ,4
		mov EAX ,3
		mov EBX ,0
		mov EDX ,1
		int 80h
		
		cmp byte[EBP-4]	,10
		je .exit1
		cmp byte[EBP-4],0
		je .exit2
		
		mov EAX ,dword[EBP+12]
		mov EAX , dword[EAX]
		add EAX , dword[EBP+8] ; EAX = (str+*len)
		
		mov CL ,byte[EBP-4]
		mov byte[EAX], CL
		
		mov EAX ,dword[EBP+12]
		inc dword[EAX]
		jmp .loop
	.exit1:
		mov EAX,0
		jmp .exit
	.exit2:
		mov EAX,1
	.exit:
		add ESP,4
		pop EBP
		ret
		
;readStr(char *str,int *len,int *n)
;{
;	int c = 1
;	while(c==1)
;	{
;		c = readWord(str+(*n)*100,len+(*n)*4)
;		*n = *n+1
;	} 
;	add ESP,4
;}
readStr: 
	push EBP
	mov EBP,ESP
	
	push dword 1
	.loop:
		cmp dword[EBP-4],1
		jne .exit
		
                mov EAX , dword[EBP+16]
                mov EAX ,dword[EAX]
                shl EAX,2
                add EAX ,dword[EBP+12]
                push EAX

		mov EAX , dword[EBP+16]
		mov EAX ,dword[EAX]
		mov EBX ,100
		mov EDX,0
		mul EBX
		
		add EAX , dword[EBP+8]
		push EAX
		
		call readWord
		add ESP,8
		
		mov dword[EBP-4],EAX
		mov EBX , dword[EBP+16]
		inc dword[EBX]
		jmp .loop
	.exit:
		add ESP,4
		pop EBP
		ret
;swap(char *str1,char *str2,int *len1,int *len2)
;{
;	int greater = *len1/*len2
;	int i =0;
;	char temp =0;
;	while(i<greater)
;	{
;		temp  = *(str1+i)
;		*(str1+i) = *(str2+i)
;		*(str2+i) = temp;
;		i++;
;	}
;	i = *len1;
; 	*len1 = *len2;	
;	*len2 = i;
;	add ESP,12
;}
swap :
	push EBP
	mov EBP,ESP
	
	mov EAX ,dword[EBP+len1]
	mov EAX ,dword[EAX]
	mov EBX ,dword[EBP+len2]
	mov EBX ,dword[EBX]
		
	cmp EAX ,EBX
	jae .max
	push EBX
	jmp .cont
	.max:
	push EAX
	.cont:
	push dword 0 ; i =8
	push dword 0 ; temp =12
	.loop:
		mov EAX ,dword[EBP-8]
		cmp EAX ,dword[EBP-4]
		jae .exit
		
		pusha 
		mov EAX,4
		mov EBX,1
		mov ECX,msg1
		mov EDX,l1
		int 80h
		popa
	
		add EAX , dword[EBP+str1]
		mov AL ,byte[EAX] ; EAX = *(str1+i)
		mov byte[EBP-12], AL; temp = *(str1+i)
		
		mov EAX ,dword[EBP-8]
		add EAX , dword[EBP+str2]
		mov AL ,byte[EAX]
		mov EBX ,dword[EBP-8]
                add EBX , dword[EBP+str1]
		mov byte[EBX],AL
		
		mov EAX ,dword[EBP-8]
                add EAX , dword[EBP+str2] ; EAX = str2+i
		mov CL , byte[EBP-12]
		mov byte[EAX] ,CL
		
		mov EAX ,dword[EBP-8]
		inc dword[EAX]
		jmp .loop
	.exit:
		mov EAX ,dword[EBP+len1]
		mov EBX , dword[EAX]
		
		mov ECX ,dword[EBP+len2]
		mov EDX ,dword[ECX]
		
		mov dword[EAX],EDX
		mov dword[ECX],EBX 
 		add ESP,12
		pop EBP
		ret
;void reverse(char *str,,int *len,int n)
;{
;	int i=0;
;	while(i<n/2)
;	{
;		swap(str+i*100,str+(n-i-1)*100,len+i*4,len+(n-i-1)*4 )
;		i++:
;	}
;	add ESP,4
;}
reverse :
	push EBP
	mov EBP,ESP
	push dword 0
	.loop:
		mov EAX ,dword[EBP+16]
		shr EAX ,1		
		
		cmp EAX ,1
		jne .here

		;pusha
                ;mov EAX,4
                ;mov EBX,1
                ;mov ECX,msg1
                ;mov EDX,l1
                ;int 80h
                ;popa
		
		.here:	
					
		cmp dword[EBP-4],EAX
		jae .exit
		
		pusha
                mov EAX,4
                mov EBX,1
                mov ECX,msg1
                mov EDX,l1
                int 80h
                popa
		
		mov EAX,dword[EBP+16]
		sub EAX,dword[EBP-4]
		dec EAX
		shl EAX,2
		add EAX,dword[EBP+12]
		push EAX
		
		mov EAX , dword[EBP-4]
		shl EAX,2
		add EAX, dword[EBP+12]
		push EAX
		
		mov EAX,dword[EBP+16]
                sub EAX,dword[EBP-4]
                dec EAX
		mov EBX ,100
		mov EDX,0
		mul EBX
		add EAX , dword[EBP+8]
		push EAX
		
		mov EAX , dword[EBP-4]
		mov EBX ,100
                mov EDX,0
                mul EBX
                add EAX , dword[EBP+8]
		push EAX
		
		call swap
		add ESP,16		
		inc dword[EBP-4]
		
		jmp .loop
	.exit:
		add ESP,4
		pop EBP
		ret		

