section .data
msg1: db 'Enter the size of the array : ',10,0
l1 : equ $-msg1
msg2 : db 'Enter the elements of the array : ',10,0
l2 : equ $-msg2
msg3 : db 'The sorted list is : ',10,0
l3 : equ $-msg3
arr : times 50 dd 0
space : db ' ' 
n : dd 0
bug : dd 0   
section .txt
global _start 
_start:
	push EBP
	mov EBP,ESP
	
	mov EAX ,4 
	mov EBX ,1
	mov ECX ,msg1
	mov EDX ,l1
	int 80h
		
	push n
	call readNum
	add ESP,4
	
	;push dword 0
        ;call printNum
        ;add ESP,4
	
	;mov EAX ,1
	;mov EBX,0
	;int 80h
			
	mov EAX ,4
        mov EBX ,1
        mov ECX ,msg2
        mov EDX ,l2
        int 80h
	
	push arr
	call readArray
	add ESP,4
	
	push arr
	push dword[n]
	call sort
	add ESP ,8
	
	mov EAX ,4
        mov EBX ,1
        mov ECX ,msg3
        mov EDX ,l3
        int 80h

	push arr
	call printArray
	add ESP,4
		
	pop EBP
	mov EAX ,1
	mov EBX,0
	int 80h 

readNum :
	push EBP
        mov EBP,ESP
	;void readNum(int *n)
	;{
	;	char c = '\0'
	;	while(1)
	;	{
	;		c = getchar
	;		if(c==10) break;
	;		c = c-30h
	;		*n = *n*10
	;		*n += c
	;	}
	;	del c
	;}
	push dword 0
	.loop :
		mov ECX , EBP
		sub ECX , 4
		
		mov EAX ,3
		mov EBX ,0
		mov EDX ,1
		int 80h 
		
		mov DL , byte[ECX]
		mov CL,DL
		cmp CL ,10
		je .exit
	
		sub CL , 30h
		
		mov EAX , dword[EBP+8]
		mov EAX, dword[EAX]
		mov EBX ,10
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
printNum :
	push EBP
	mov EBP,ESP
	;printNum(int a)
	;{
	;	EAX =  a
	;	int size = 0
	;	while(EAX!=0)
	;	{
	;		EAX = EAX/10
	;		EDX = EAX%10
	;		push EDX
	;		size++
	;	}
	;	while(size!=0)
	;	{
	;		pop byte
	;		printByte +30h
	;		size--
	;	}
	;}
	mov EAX , dword[EBP+8]
	push dword 0
	cmp EAX ,0
	jne .loop1
	mov byte[bug],30h
	mov EAX ,4
        mov EBX ,1
        mov ECX ,bug
        mov EDX ,1
        int 80h
	jmp .exit
		
	.loop1:
		cmp EAX ,0
		je .loop2
		
		mov EDX ,0
		mov EBX ,10
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
		mov EBX ,1
		mov ECX ,bug
		mov EDX ,4
		int 80h
		
		dec dword[EBP-4]
		jmp .loop2
	.exit :
		add ESP,4
		pop EBP
		ret
readArray:
	push EBP
        mov EBP,ESP
	;readArray(int *arr)
	;{
	;	int i =0;
	;	while(i<n)
	;	{
	;		readNum(arr +i*4)
	;	}
	;}
	push dword 0
	.loop :
		mov EAX , dword[EBP-4]
		cmp EAX,dword[n]
		jae .exit
		
		shl EAX ,2
		add EAX , dword[EBP+8]
		push EAX
		call readNum
		add ESP, 4
		
		inc dword[EBP-4]
		jmp .loop
	.exit:	
		add ESP ,4
		pop EBP
		ret
printArray:
	push EBP
	mov EBP ,ESP
	 push dword 0
        .loop :
		mov EAX , dword[EBP-4]
                cmp EAX , dword[n]
                jae .exit
                
		shl EAX ,2
                add EAX , dword[EBP+8]
                push dword[EAX]
                call printNum
                add ESP, 4
		
		inc dword[EBP-4]	
	
		mov EAX ,4
        	mov EBX ,1
       	 	mov ECX ,space
        	mov EDX ,1
        	int 80h
                jmp .loop
        .exit:
                add ESP ,4
                pop EBP
                ret
	
		

swap :
	push EBP
        mov EBP,ESP
	
	mov EAX , dword[EBP+8]
	mov EBX , dword[EAX]
	
	mov ECX , dword[EBP+12]
	mov EDX , dword[ECX]
	
	mov dword[ECX],EBX
	mov dword[EAX],EDX
	
	pop EBP
	ret
		
		
sort :
	push EBP
        mov EBP,ESP
	;sort(int *arr,int n)
	;{
	;	int i=1;
	;	while(i<n)
	;	{
	;		int j = i-1
	;		while(j>=0&&arr[j+1]<arr[j])
	;			swap(&arr[j],&arr[j+1])
	;			j--
	;		i++
	;	}
	;}
	push dword 1
	.loop1 :
		mov EAX ,dword[EBP-4]
		cmp EAX , dword[n]
		jae .exit
		
		mov EAX ,dword[EBP-4]	
		dec EAX	
		;pusha	
		;push EAX
		;call printNum
		;add ESP ,4
		;popa
		
		push EAX
		.loop2:
			mov EAX , dword[EBP-8]
			cmp EAX , 4294967292
			jae .exit1
			
			mov EAX , dword[EBP-8]	
			shl EAX,2
			mov EBX , arr
			add EBX , EAX ; EBX  = arr +4*j
			mov ECX ,dword[EBX] ; ECX = arr[j]
			
			add EBX ,4       ;EBX = arr +4*(j+1)
			mov EDX ,dword[EBX]; EDX  = arr[j+1]
			
			pusha
			push EAX
			call printNum
			add ESP,4
			
			mov EAX,4
			mov EBX,1
			mov ECX,space
			mov EDX,1
			int 80h
	
			popa
			
			;pusha
                        ;push EDX
                        ;call printNum
                        ;add ESP,4
                        
			;mov EAX,4
                        ;mov EBX,1
                        ;mov ECX,space
                        ;mov EDX,1
                        ;int 80h

			;popa
			
			cmp EDX , ECX
			jae .exit1
			
			mov EBX , dword[EBP-8]
			shl EBX,2
                        add EBX , arr
				
			push EBX
			
			add EBX ,4
			push EBX
			call swap
			add ESP ,8
			
			dec dword[EBP-8]  	
			jmp .loop2
		.exit1:
			add ESP,4
			inc dword[EBP-4]
			jmp .loop1
	.exit :	
		add ESP ,4
		pop EBP
		ret
			
	
	


			
		
		
	


