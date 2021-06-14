section .data
msg1 : db 'Enter the size of the array : ',10,0
l1: equ $-msg1
msg2 : db 'Enter the elements of the array : ',10,0
l2 : equ $-msg2
msg3 : db 'The most frequent elements are : ',10,0
l3 : equ $-msg3
msg4 : db 10,'Least frequent elements are : ',10,0
l4 : equ $-msg4
arr : times 50 dd 0
orgArr : times 50 dd 0
count : times 50 dd 0
n : dd 0
N : equ 8
ORG : equ 12
ARR : equ 16
COU : equ 20
j : equ 12
index : equ 8
i : equ 4
MAX : equ 8
MIN : equ 12
MAXF : equ 16
MINF : equ 20


section .bss
max : resd 1
min : resd 1
bug : resd 1
newSize : resd 1

section .txt

global _start
_start:
	push EBP
	mov EBP,ESP
		
	mov EAX ,4
	mov EBX ,1
	mov ECX ,msg1
	mov EDX,l1
	int 80h
	
	push n
	call readNum 
	add ESP,4
	
	;push dword[n]
	;call printNum
	;add ESP,4
	
	;mov EAX,1
	;mov EBX,0
	;int 80h
	
	mov EAX ,4
        mov EBX ,1
        mov ECX ,msg2
        mov EDX,l2
        int 80h
	
	push count
	push arr
	push orgArr
	push dword[n]
	call readArray
	add ESP , 16
	
	push count
	push arr
	call printV
	add ESP ,8
	
	pop EBP
	
	mov EAX , 1
	mov EBX,0
	int 80h

printNum :	
	push EBP
	mov EBP, ESP
	; c code
	;printNum(int a)
	;{
	;	EAX = a
	;	int size = 0
	;	while(EAX!=0)
	;	{
	;		EAX = EAX/10
	;		EDX = EAX%10
	;		push EDX
	;	 	size++
	;	}
	;	while(size!=0)
	;	{
	;		pop bug;
	;		bug += 30h;
	;		print bug;
	;		size--;
	;	}
	;}	
	mov EAX ,dword[EBP+8]
	push dword 0
	.loop1:
		cmp EAX,0
		je .loop2
		
		mov EBX ,10
		mov EDX ,0
		div EBX
		
		push EDX
		inc dword[EBP-4]
		jmp .loop1
	.loop2:
		mov EAX , dword[EBP-4]
		cmp EAX ,0
		je .exit
		
		pop dword[bug]
		add dword[bug],30h
		
		mov EAX,4
		mov EBX,1
		mov ECX,bug
		mov EDX,4
		int 80h
		
		dec dword[EBP-4]
		jmp .loop2
	.exit :
		add ESP ,4
		pop EBP
		ret
			
readNum :
	push EBP
	mov EBP , ESP
	
	;c code
	;readNum(int *n)
	;{
	;	char c
	;	while(1)
	;	{
	;		c = getchar
	;		if(c==10) break;
	;		c = c-30h
	;		*n = *n*10
	;		*n +=c
	;	}
	;	del c
	;}	
	push dword 0
	.loop :
		mov ECX,EBP
		sub ECX,4
		
		mov EAX,3
		mov EBX,0
		mov EDX,1
		int 80h
		
		mov EDX,EBP
                sub EDX,4
	
		mov CL , byte[EDX]
		cmp CL ,10
		je .exit
		
		sub CL , 30h
		
		mov EAX , dword[EBP+8]
		mov EAX ,dword[EAX]
		mov EBX , 10
		mov EDX ,0	
		mul EBX
	
		add AL,CL
		mov EBX,dword[EBP+8]
		mov dword[EBX],EAX
		
		jmp .loop

	.exit : 
		add ESP,4
		pop EBP
		ret

readArray:
	push EBP
	mov EBP, ESP
	;c code
	;readArray(int n, int* org_arr ,int *arr,int *count)
	;{
	;	int i =0;
	;	int index =0
	;	while(i<n)	
	;	{
	;		readNum(arr +i*4)
	;		int j=index;
	;		while(j>0)
	;		{
	;			if(org_arr[j-1]==arr[i])
	;			{
	;				count[j-1]++
	;				break;	
	;			}
	;			j--;
	;		}
	;		if(j==0)
	;			{
	;				org_arr[index] = arr[i]
	;				count[index] =1;
	;				index++;	
	;				break;
	;			}
	;		
	;		i++
	;		del j
	;	}
	;	del i 
	; del index
	;}
	push dword 0
	push dword 0
	.loop1:
		;push dword[EBP-i]
		;call printNum
		;add ESP,4
		
		mov EAX , dword[EBP-i]
		cmp EAX , dword[n]
		jae .exit
		
		shl EAX , 2
		add EAX , dword[EBP+ARR]
		
		push EAX 
		call readNum
		add ESP ,4
		
		push dword[EBP-index]; int j = index
		
		.loop2 : 
			
			;push dword[EBP-j]
			;call printNum
			;add ESP,4
			
			mov EAX , dword[EBP -j]		
			cmp EAX , 0
			jbe .exit1
 	;                       if(org_arr[j-1]==arr[i])
        ;                       {
        ;                               count[j-1]++
        ;                               break;  
        ;                       }
        ;                       j--;
			mov ECX ,EAX
			dec ECX
			shl ECX,2
			mov EDX , ECX ; EDX  = j-1
			add ECX, dword[EBP+ORG]
			mov ECX,dword[ECX] ; ECX  = org_arr[j-1]
			
			mov EAX ,dword[EBP-i]
			shl EAX ,2
			add EAX , dword[EBP+ARR]
			mov EAX,dword[EAX] ;EAX = arr[i] 
			
			cmp EAX , ECX
			jne .exit2 
				
			add EDX , dword[EBP+COU]
			inc dword[EDX]
			jmp .exit1
			
		.exit2:
			dec dword[EBP-j]
			jmp .loop2
		.exit1:
				
        ;                       if(j==0)
        ;                       {
        ;                               org_arr[index] = arr[i]
        ;                               count[index] =1;
        ;                               index++;        
        ;                       }
        ;               }
        ;               i++
	
			cmp dword[EBP-j],0
			jne  .continue
			
			mov EAX , dword[EBP-i]
			shl EAX,2
			add EAX , dword[EBP+ARR]
			mov EAX , dword[EAX]; EAX = arr[i]		
			
			mov EDX, dword[EBP-index]
			shl EDX,2
			
			mov ECX , dword[EBP+ORG]
			add ECX , EDX
			mov dword[ECX],EAX; org_arr[index]=arr[i]
			
			mov EBX , dword[EBP+COU]
			add EBX , EDX	; EBX = count +index*4
			mov dword[EBX] , 1
			
			inc dword[EBP-index] 
			
		.continue :inc dword[EBP-i]
			add ESP ,4
			
			jmp .loop1
			
	.exit:
		mov EAX,dword[EBP-index]
		mov dword[newSize],EAX
		add ESP ,8
		pop EBP 
		ret
	
printV :
	push EBP
	mov EBP , ESP
	; c code
	;void printV(int* count ,int *org,int newSize )
	;{
	;	int i=0;
	;	int max = 0;
	;	int min =0;
	;	int maxfreq=0
	;	int minfreq=0
	;	while(i<newSize)
	;	{
	;		if(maxfreq<count[i])
	;		{
	;			maxfreq = count[i]
	;			max = org[i]
	;		}
	;		if(minfreq>count[i])
	;		{
	;			minfreq = count[i]
	;			min = org[i]
	;		}
	;		i++;
	;	}
	;}
	push dword 0 
	push dword 0 
	push dword 0 
	push dword 0 
	push dword 100 
	.loop:
		mov EAX ,dword[EBP-i]; EAX =i
		cmp EAX ,dword[newSize]
		jae .exit
		
		shl EAX,2
		
		mov EBX ,count
		add EBX ,EAX
		mov EBX,dword[EBX]; EBX = count[i]
		
		mov ECX , orgArr
                add ECX , EAX
                mov ECX ,dword[ECX]; ECX = org[i]
		
		cmp dword[EBP-MAXF],EBX
		jae .continue
		
		mov dword[EBP-MAXF],EBX
		mov dword[EBP-MAX],ECX
		
	.continue:
		
		cmp dword[EBP-MINF],EBX
		jbe .continue2
		
		;mov EAX ,4
		;mov EBX ,1
		;mov ECX, msg4
		;mov EDX ,l4
		;int 80h
		
		mov dword[EBP-MINF],EBX
                mov dword[EBP-MIN],ECX
		
	.continue2:
		inc dword[EBP-i]
		jmp .loop

	.exit :
		mov EAX ,4
		mov EBX,1
		mov ECX,msg3
		mov EDX ,l3
		int 80h
		
		push dword[EBP-MAX]
		call printNum
		add ESP,4
		
		
		mov EAX ,4
                mov EBX,1
                mov ECX,msg4
                mov EDX ,l4
                int 80h

		push dword[EBP-MIN]
		call printNum
		add ESP ,4
		
		add ESP,20
		pop EBP
		ret	
	
						 
				
			
			
					
		
		
