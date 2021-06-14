section .data
msg1 : db 'The first string is : ',0 ,10
l1 : equ $-msg1
msg2 : db 'The second str is : ',0 ,10
l2 : equ $-msg2
msg3 : db 'The resultant is : ',0 ,10
l3 : equ $-msg3
string : times 5000 db 0
len : times 50 dd 0
n : dd 0
org_space : db ' '
str1 : equ 8
str2 : equ 12
len1 : equ 16
len2 : equ 20
str : equ 8
N : equ 12
LEN : equ 16

new : db 10
section .bss
section .text

global _start
_start:	
	push EBP
	mov EBP,ESP

	mov EAX , 4
	mov EBX , 1
	mov ECX , msg1
	mov EDX , l1
	int 80h
	
	push n
	push len
	push string
	call readStr
	add ESP,12
	
	push len
	push dword[n]
	push string
	call lexically
	add ESP,12	
	
	push dword[n]
	push len
	push string
	call printStr
	add ESP,12
			
	pop EBP
	mov EAX ,1
	mov EBX ,0
	int 80h
;void printStr(char *str,int *len,int n)
;{
;	int i=0;
;	while(i<n)
;	{
;		int j=0;
;		while(j<*(len+i*4))
;		{
;			printchar(str+i*100+j)
;			j++;
;		}
;		i++;
;		printchar(' ')
;	}
;	print newline
;}
printStr:
	push EBP
	mov EBP ,ESP
	
	push dword 0
	.loop1:
		mov EAX,dword[EBP+16]
		cmp dword[EBP-4],EAX
		jae .exit1
		push dword 0
		.loop2:
			mov EAX ,dword[EBP+12]
			mov EBX , dword[EBP-4]
			shl EBX ,2
			add EAX , EBX
			mov EAX , dword[EAX]
			cmp dword[EBP-8], EAX
			jae .exit2
			
			;pusha
			;mov EAX , 4
        	        ;mov EBX , 1
	                ;mov ECX , msg2
                	;mov EDX , l2
                	;int 80h
			;popa
		
			mov ECX , dword[EBP+8]
			mov EAX , dword[EBP-4]
			mov EBX , 100
			mov EDX ,0
			mul EBX
			add ECX , EAX
			add ECX , dword[EBP-8]
			mov EAX ,4
			mov EBX ,1
			mov EDX ,1
			int 80h
			inc dword[EBP-8]
			jmp .loop2
		.exit2:
			add ESP,4
			inc dword[EBP-4]
			
			mov EAX ,4
			mov EBX ,1
			mov ECX ,org_space			
			mov EDX ,1
			int 80h

			jmp .loop1
	.exit1:	
		add ESP,4
		pop EBP
		
		mov EAX ,4
		mov EBX ,1
		mov ECX ,new			
		mov EDX ,1
		int 80h
		ret	
				
;int main()
;{
;	// read 2 strings as one
;	// while reading put each word into a block in 2D
;	// Every word is in an array
;	// sort lexically
;	// printString	
;}
;int readWord(char *str,int *len)
;{
;	char c
;	while(1)
;	{
;		 c = scanf("%c",);
;		if(c==10 || c == ' ') break;
;		*(str+*len) = c;
;		*len = *len +1;		
;	}
;	*(str+*len) = 0;
;	if(c==' ') return 0;
;	else return 10;	 
;}
readWord :
	push EBP
	mov EBP,ESP
	
	push dword 0
	.loop:
		mov ECX , EBP
		sub ECX , 4
		mov EAX , 3
		mov EBX , 0
		mov EDX , 1
		int 80h
		
		
		;mov EAX , 4
                ;mov EBX , 1
		;mov ECX , msg2
                ;mov EDX , l2
                ;int 80h

		mov BL ,byte[EBP-4] ;BL  = c
		cmp BL , 10
		je .exit1
		cmp BL ,byte[org_space]
		je .exit2
		mov ECX , dword[EBP+8]; ECX = str
		mov EDX , dword[EBP+12]; EDX = len
		mov EDX , dword[EDX] ; EDX = *len
		add ECX , EDX 
		mov byte[ECX], BL
		
		mov EDX , dword[EBP+12]; EDX = len
		inc dword[EDX]
		 
		jmp .loop
	.exit1:
	mov ECX , dword[EBP+8]; ECX = str
       	mov EDX , dword[EBP+12]; EDX = len
       	mov EDX , dword[EDX] ; EDX = *len
       	add ECX , EDX
       	mov byte[ECX], 0
	
	mov EAX , 0
	jmp .exit
	.exit2:
	
	mov ECX , dword[EBP+8]; ECX = str
        mov EDX , dword[EBP+12]; EDX = len
        mov EDX , dword[EDX] ; EDX = *len
        add ECX , EDX
        mov byte[ECX], 0

        mov EAX , 1
	jmp .exit

	.exit:
	
	add ESP,4
	pop EBP
	ret
;readStr(char *str,int *len,int *n)
;{
;	char c = 1;
;	while(c!=0)
;	{
;		c = readWord(str+(*n)*100,len+(*n)*4)
;		(*n) = (*n) + 1;
;	}
;}
readStr:
	push EBP
	mov EBP, ESP
	
	;mov EAX , 4
        ;mov EBX , 1
       	;mov ECX , msg2
       	;mov EDX , l2
        ;int 80h

	push dword 1
	.loop:
		cmp byte[EBP-4] ,0
		je .exit
		
		;mov EAX , 4
                ;mov EBX , 1
                ;mov ECX , msg2
                ;mov EDX , l2
                ;int 80h
		
		mov EBX , dword[EBP+12]
		mov ECX , dword[EBP+16] 
		mov ECX , dword[ECX]
		shl ECX ,2
		add EBX , ECX ; EBX  = len +(*n)*4
		push EBX
		
		mov ECX , dword[EBP+16]
                mov ECX , dword[ECX]
		mov EAX , 100
		mov EDX , 0
		
		mul ECX
		add EAX , dword[EBP+8] ; EAX = str +(*n)*100
		push EAX
		
		call readWord
		add ESP,8
		
		mov dword[EBP-4],EAX ; c = return value		
		mov ECX , dword[EBP+16] ; *n++
		inc dword[ECX]
		jmp .loop
	.exit:
		add ESP,4
		pop EBP
		ret

		  
;int lexicallyGreater(char *str1,char *str2,int len1 ,int len2)
;{
;	smaller = len1/len2;
;	for(int i=0;i<smaller;)
;	{
;		if( *(str1+i)<*(str2+i)) return 0;
;		else if(*(str1+i)>*(str2+i)) return 1;
;		if(i==(smaller-1)) 
;		{
;			if(len1==smaller) return 0;
;			else return 1;
;		}
;		i++;
;	}
;	add ESP,8
;}
lexicallyGreater:
	push EBP
	mov EBP , ESP
	mov EAX , dword[EBP+len1]
	mov EBX , dword[EBP+len2]	
	
	cmp EAX , EBX
	jae .mini
	push EAX
	jmp .cont
	.mini :
	push EBX ; dword[EBP-4] = smaller
	.cont:
	push dword 0 ; i = 8
	.loop:
		mov EAX , dword[EBP-8]
		cmp EAX , dword[EBP-4]
		jae .exit
		
		mov EBX , dword[EBP+str1]
		add EBX , EAX ; EBX = (str1+i)
		mov BL , byte[EBX];
		
		mov EDX , dword[EBP+str2]
		add EDX, EAX 
		mov DL , byte[EDX] ; *(str2+i)
		
		cmp BL, DL ; str1+i < str2 +i
		jae .continue1
		
		mov EAX ,0
		jmp .exit	
		.continue1:
		
		cmp BL , DL ; str2+i < str1+i
		jbe .continue2
		
		mov EAX ,1
		jmp .exit
		
		.continue2:
		
		mov EBX , dword[EBP-4]
		dec EBX
		mov EAX , dword[EBP-8]
		cmp EAX , EBX ; i== smaller-1
		jne .continue 		
			
			inc EBX
			cmp EBX , dword[EBP+len1]
			jne .continue3
			
			mov EAX ,0
			jmp .exit	
			.continue3:
			
			mov EAX ,1
			jmp .exit
				
		
		.continue:
		inc dword[EBP-8]
		jmp .loop
	.exit:	
		add ESP ,8
		pop EBP
		ret
;void swapVal(int *len1,int *len2)
;{
;	int temp = *len1;
;	*len1 = *len2;
;	*len2 = temp 
;}
swapVal:
	push EBP
	mov EBP,ESP

	mov EAX ,dword[EBP+8]
	mov EBX , dword[EAX]
	mov ECX , dword[EBP+12]
	mov EDX , dword[ECX]
	
	mov dword[EAX], EDX
	mov dword[ECX],EBX
	pop EBP
	ret
;void swap(char *str1, char *str2,int len1 ,int len2)
;{
;	greater = len1/len2
;	for(int i=0;i<greater;i++)
;	{
;		char temp = *(str1+i)
;		*(str1+i) = *(str2+i)
;		*(str2+i) = temp;
;		i++
;	}
;	add esp,12
;}
swap :
	push EBP
	mov EBP ,ESP
	
	mov EAX , dword[EBP+len1]
	mov EBX , dword[EBP+len2]	
	
	cmp EAX , EBX
	jae .max
	push EBX
	jmp .cont
	.max :
	push EAX ; dword[EBP-4] = larger
	.cont:
	push dword 0 ; i = -8 
	push dword 0 ; temp = -12
	.loop:
		mov EAX ,dword[EBP-8]
		cmp EAX ,dword[EBP-4]
		jae .exit 
		
		mov EBX,EBP
		sub EBX , 12 ;EBX  = EBP-12
		
		mov ECX , dword[EBP+str1]
		add ECX , EAX
		mov CL, byte[ECX] ; CL = *(str1+i)
		mov byte[EBX] , CL
		
		mov EDX , dword[EBP+str2]
		add EDX , EAX
		mov DL, byte[EDX]
		mov ECX , dword[EBP+str1]
		add ECX , EAX
		mov byte[ECX], DL
		
		mov EDX , dword[EBP+str2]
		add EDX , EAX

		mov EBX , EBP
		sub EBX ,12
		mov BL , byte[EBX]
		
		mov byte[EDX] , BL
		
		inc dword[EBP-8]
		jmp .loop
	.exit:
		add ESP,12
		pop EBP
		ret	
		 		
		
;void lexically(char *str,int n,int *len)
;{
;	int i=0
;	for(;i<n;)
;	{
;		int j=0
;		for(;j<n-i-1;)
;		{
;			if( lexicalgreater( (str +j*100) ,(str+(j+1)*100 ), *(len +j*4),*(len+(j+1)*4) );
;				swap(str+j*100,str+(j+1)*100,*(len +j*4),*(len+(j+1)*4));
;			 j++		
;		}
;		i++;
;	}
;}
lexically:
	push EBP
	mov EBP, ESP
	push dword 0
	.loop1:
		mov EAX , dword[EBP-4]
		cmp EAX , dword[EBP+N]
		jae .exit1
		push dword 0
		.loop2:
			;pusha
			;mov EAX , 4
   		 	;mov EBX , 1
  	 	     	;mov ECX , msg2
  		      	;mov EDX , l2
  		      	;int 80h
			;popa
			
			mov EAX,dword[EBP+N];
			sub EAX , dword[EBP-4]
			dec EAX
			cmp dword[EBP-8] , EAX
			jae .exit2
			
			mov EAX , dword[EBP+LEN]
			mov EBX , dword[EBP-8]
			inc EBX
			shl EBX ,2
			add EAX , EBX ; EAX  = len+(j+1)*4
			mov EAX , dword[EAX]
			push EAX
		
			mov EAX , dword[EBP+LEN]
			mov EBX , dword[EBP-8]
			shl EBX ,2
			add EAX , EBX ; EAX  = len+j*4
			mov EAX , dword[EAX]
			push EAX
			
			
			;(str +(j+1)*100)
			mov EAX , dword[EBP-8]
			inc EAX			
			mov EBX ,100
			mov EDX ,0
			mul EBX
			
			add EAX , dword[EBP+str]
			push EAX
			
			mov EAX , dword[EBP-8]
			mov EBX ,100
			mov EDX ,0
			mul EBX
			
			add EAX , dword[EBP+str]
			push EAX			
			
			call lexicallyGreater
			add ESP,16
				
			cmp EAX ,1
			jne .continue
				
				;printing after lexicallyGreater before swap
				;pusha
	                        ;mov EAX , 4
        	                ;mov EBX , 1
        	                ;mov ECX , msg2
                	        ;mov EDX , l2
                        	;int 80h
                        	;popa
				
				mov EAX , dword[EBP+LEN]
				mov EBX , dword[EBP-8]
				inc EBX
				shl EBX ,2
				add EAX , EBX ; EAX  = len+(j+1)*4
				mov EAX , dword[EAX]
				push EAX
							
				mov EAX , dword[EBP+LEN]
				mov EBX , dword[EBP-8]
				shl EBX ,2
				add EAX , EBX ; EAX  = len+j*4
				mov EAX , dword[EAX]
				push EAX
			
				mov EAX , dword[EBP-8]
				inc EAX			
				mov EBX ,100
				mov EDX ,0
				mul EBX
			
				add EAX , dword[EBP+str]
				push EAX		
		
				;(str +j*100)
				mov EAX , dword[EBP-8]
				mov EBX ,100
				mov EDX ,0
				mul EBX
				
				add EAX , dword[EBP+str]
				push EAX
								
				call swap
				add ESP,16
				
				mov EAX , dword[EBP+LEN]
                                mov EBX , dword[EBP-8]
                                shl EBX ,2
                                add EAX , EBX ; EAX  = len+j*4
				
				push EAX
				
				mov EAX , dword[EBP+LEN]
                                mov EBX , dword[EBP-8]
                                inc EBX
                                shl EBX ,2
                                add EAX , EBX ; EAX  = len+(j+1)*4
                                push EAX
					
				call swapVal
				add ESP,8						
				
			.continue:
				
				;pusha
				;void printStr(char *str,int *len,int n)
				;push dword[EBP+N]
				;push dword[EBP+LEN]
				;push dword[EBP+str]
				;call printStr
				;add ESP,12
				;popa	
				
				inc dword[EBP-8]
				jmp .loop2		
		.exit2:
			add ESP,4
			inc dword[EBP-4]
			jmp .loop1	
	.exit1:
		add ESP,4
		pop EBP
		ret

