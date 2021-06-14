;This program sorts any list of numbers

section .data
msg1 : db 'Enter the size of the array : ',10,0
l1 : equ $-msg1
msg2 : db 'The sorted array is : ',10,0
l2 : equ $-msg2
n : dd 0  
arr : times 100  dd 0
space : db ' '
quo : equ 4
size : equ 8
i : equ 4
j : equ 8
section .bss
rem : resd 1
bug : resb 1 

section .text
global _start:
_start :

	mov EAX, 4
	mov EBX, 1
	mov ECX , msg1
	mov EDX , l1
	int 80h
	
	push n 
	call readNum ; read the size of the array	
	add ESP,4  ; cleaning the parameters
	
	push arr
	call readArray
	add ESP,4 
	
	call bubblesort 
	
	mov EAX, 4
        mov EBX, 1
        mov ECX , msg2
        mov EDX , l2
        int 80h

	call printArray ; print the number
	
	mov EAX ,1
	mov EBX,0	
	int 80h
	
readNum :
	
	push EBP
	
	;mov EAX , ESP 	; moving the return address to rem
	;add EAX, 4
	;mov EAX , dword[EAX]
	;mov dword[rem], EAX
	 
	mov EBP,ESP ;setting up EBP
	
	; c code
	;	while(1)
	;	{
	;		c = getchar()
	;		if c==(' ') break;
	;		c = c-30h	
	;		*n = *n *10
	;		*n += c
	;	}			
		
	
	push dword 0 ; declaring a local char
	.loop :
	
	mov EAX , 3 ; reading in a byte
	mov EBX , 0
	mov ECX , EBP
	sub ECX , 4
	;mov ECX , bug
	mov EDX , 1
	int 80h
	
	mov CL ,byte[EBP-4]
	cmp CL ,byte[space] ; if(c==' ')
	je .exit
	
	sub CL ,30h ; c = c -30h
	
	mov EAX , dword[EBP+8] ; &n
	mov EAX , dword[EAX] ; n
	mov EDX, 0
	mov EBX ,10
	mul EBX 
	
	add AL , CL   
	
	mov ECX, dword[EBP+8]; ECX = &n 
	mov dword[ECX] ,EAX ; *n  = *n * 10 + rem
	
	jmp .loop
	
	.exit:
		add ESP ,4	
		pop EBP
		ret	
	
readArray:
	push EBP
	mov EBP ,ESP
	;c code
	;readNum(int *arr)
	;{
	;	int i =0
	;	while(i<n)
	;	{
	;		readNum(arr+i)
	;		i +=4
	;	}
	;}
	push dword 0 ; int i =0
	.loop :
		mov EAX , dword[n]
		cmp dword[EBP-4],EAX ;if(i>=n)
		jae .exit
		
		pusha ; pushing all 
		mov EAX , dword[EBP +8] 
		mov EBX , dword[EBP -4] ;  i
		shl EBX ,2
		add EAX ,EBX	
	
		push EAX
		call readNum
		add ESP ,4 
		
		popa
		
		add dword[EBP-4],1; i = i +1
		
		jmp .loop
	.exit :
		add ESP ,4
		pop EBP
		ret

printNum :
	push EBP
	mov EBP , ESP
	
	; c code 
	;printNum(int n)
	;{
	;	int quo = n
	;	int size =0
	;	while(quotient!=0)
	;	{	
	;		rem = quo%10
	;		quo = quo/10
	;		push rem
	;		size++
	;	}
	;	while(size!=0)
	;	{
	;		pop rem	
	;		printf(rem)
	;		size--
	;	}	
	;}
	
	mov EAX , dword[EBP+8]
	push EAX ; quo = n
	push dword 0 ; size
	
	.loop1:	
		mov EAX, dword[EBP - quo]
		cmp EAX , 0			
		je .loop2 

		mov EDX ,0
		mov EBX , 10
		div EBX 
		
		mov dword[EBP - quo] ,EAX; quo = quo/10
		push EDX ; push rem
		
		inc dword[EBP - size]; size ++
		jmp .loop1
		
	.loop2 :
		mov EAX, dword[EBP - size]
		cmp EAX , 0
		je .exit
		
		pop dword[rem] ; pop rem
		
		add dword[rem], 30h
		mov EAX , 4
		mov EBX , 1
		mov ECX , rem
		mov EDX , 4 
		int 80h ; printing remainder
		
		dec dword[EBP - size]
		
		jmp .loop2
		
	.exit :
		add ESP ,8
		pop EBP
		ret 
printArray:
	push EBP
	mov EBP, ESP
	
	;c code
	;printArray()
	;{
	;	int i =0;
	; 	while(i<n)
	;	{
	;		printNum(arr+i)
	;		i = i+4;	
	;	}
	;
	;} 	
	
	push dword 0
	.loop:
		mov EAX , dword[n]
                cmp dword[EBP-4],EAX ;if(i>=n)
                jae .exit
		
		pusha
		mov EAX , arr
		mov EBX , dword[EBP -4] ;  i
		shl EBX ,2 
		add EAX , EBX ; arr = arr + i*4
		mov EAX , dword[EAX]
			
		push EAX
		call printNum ; printNum(arr+i)
		add ESP , 4
		
		popa
		add dword[EBP-4],1
		
		mov EAX ,4
		mov EBX ,1 
		mov ECX , space
		mov EDX , 1
		int 80h
		
		jmp .loop
	.exit:	
 		add ESP ,4
		pop EBP
		ret	
swap :
	push EBP
	mov EBP, ESP
	
	push dword 0 ; temp = 0
		
	mov EAX , dword[EBP+8] ; EAX = a
	mov EAX , dword[EAX]	; EAX = *a
	mov dword[EBP-4],EAX 	; temp = *a
		
	mov ECX , dword[EBP+12]; ECX = b
	mov EBX , dword[ECX]; EBX = *b
	mov EAX , dword[EBP+8]; EAX = a
	mov dword[EAX], EBX ; *a = *b 
		
	mov EDX , dword[EBP -4]
	mov dword[ECX], EDX
	
	add ESP ,4
	pop EBP
	ret
	
sum :
	push EBP
        mov EBP, ESP
	; c code
	;int sum(int n)
	;{
	;	EAX = n;
	; 	int sum = 0
	;	while(quo!=0)
	;	{
	;		EDX = quo%10
	;		sum+= EDX
	;	}
	;	return sum
	;}
	
	mov EAX , dword[EBP+8]
	push dword 0 ; sum = -4
	.loop :
		cmp EAX , 0
		je .exit
		
		mov EDX ,0
		mov EBX ,10
		div EBX 
		
		add dword[EBP-4],EDX
		
		jmp .loop
	
	.exit :
		pop EAX
		pop EBP
		ret 
			
		

bubblesort :
	push EBP
	mov EBP , ESP	
	; c code
	; bubblesort()
	;{
	;	int i =0;	
	; 	while(i<n)
	;	{
	;		int j = 1;
	;		while(j<n-i)
	;		{
	;			int a = sum(arr[j-1]);
	;			int b = sum(arr[j])
	;			if(b>a)
	;			{
	;				swap(arr+j-1, arr+j);
	;			}
	;			j++;
	;		}
	;		i++;
	;	}
	;}
	;	
	push dword 0
	.loop1 :
		mov EAX , dword[EBP-i]			
		cmp EAX ,dword[n] ; i>=n
		jae .exit
		
		push dword 1 ; j = 1
		.loop2 :
			mov EBX , dword[n]
			mov EAX , dword[EBP -i]
			sub EBX , EAX ; n-i
			cmp dword[EBP-j] , EBX ; j>= n-i
			jae .exit1
			
			mov ECX , arr
			mov EAX , dword[EBP-j]; j
			shl EAX , 2 ; j*4
			add ECX , EAX ; ECX  =  arr + j 
			mov ECX , dword[ECX] ; ECX = arr[j]
			
			push ECX	
			call sum
			add ESP ,4
			
			push EAX ; -12 is a
			
			mov ECX , arr
                        mov EAX , dword[EBP-j]; j
			dec EAX
                        shl EAX , 2 ; j-1*4
                        add ECX , EAX ; ECX  =  arr + j-1 
                        mov ECX , dword[ECX] ; ECX = arr[j-1]

			push ECX
                        call sum
                        add ESP ,4	
		        
			pop EBX ; EBX  = sum(arr[j]); eax = sum(arr[j-1])
			; stack has ebp,i,j
			cmp EBX , EAX 
			jae  .exit2	
			
			; calling swap
			pusha 
			
			mov ECX , arr
                        mov EAX , dword[EBP-j] ; ECX  =  arr + j 
			shl EAX , 2
			add ECX , EAX 
			push ECX
			
			sub ECX,4
			push ECX ; ECX = arr+j-1
			
			call swap
			add ESP, 8
			
			popa
			
			.exit2:
			
			inc dword[EBP-j]	
			jmp .loop2
			
			.exit1:	
				add ESP, 4 ;popping j	
				inc dword[EBP-i] ; i = i +1
				jmp .loop1
			.exit:
				add ESP,4 ; popping i 
				pop EBP
				ret

 
			
		

