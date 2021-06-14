section .data
msg1 : db 'The size is : ',10,0
l1 : equ $-msg1
msg2 : db 'The elements are : ',10,0
l2 : equ $ - msg2
space : db 10
msg3 : db 'The prime numbers are : ',10,0
l3 : equ $-msg3
arr : times 50 dd 0
n : dd 0
temp : dd 0
section .text

global _start
_start :
	
	mov EAX , 4
	mov EBX , 1
	mov ECX , msg1
	mov EDX , l1
	int 80h
	
	push n
	call readNum
	add ESP, 4
	
	mov EAX , 4
        mov EBX , 1
        mov ECX , msg2
        mov EDX , l2
        int 80h
	
	;mov EAX ,1
        ;mov EBX ,0
        ;int 80h
	
	push arr 
	call readArray
	add ESP ,4
	
	mov EAX , 4
        mov EBX , 1
        mov ECX , msg3
        mov EDX , l3
        int 80h

	call printPrime	
	
	mov EAX ,1
	mov EBX ,0
	int 80h

readNum :
	push EBP
	mov EBP , ESP
	
	; c code
	;readNum(int *n)
	;{
	;	char c = '0'
	; 	while(1)
	;	{
	;		c = getchar()
	;		if(c==10) break;
	;		*n = *n * 10
	;		*n += c
	;	}
	;}
	
	push dword 0
	.loop:
		mov EAX,3
		mov EBX ,0
		mov ECX ,EBP
		sub ECX , 4
		mov EDX ,1
		int 80h
		 
		cmp byte[EBP-4] ,10
		je .exit
		
		mov EAX , dword[EBP+8]
		mov EAX , dword[EAX]
		mov EDX ,0
		mov EBX ,10
		mul EBX
		
		sub byte[EBP-4],30h
		add AL , byte[EBP-4]
		
		mov ECX,dword[EBP+8] 
		mov dword[ECX],EAX
	
		jmp .loop
	.exit :
		add ESP , 4
		pop EBP
		ret
	
readArray:
	push EBP
	mov EBP ,ESP	
	;readArray(int *arr)
	;{
	;	int i=0;
	; 	while(i<n)
	;	{
	;		readNum(arr+i)
	;		i++
	;	}
	;}
	push dword 0
	.loop:
	mov EAX , dword[EBP-4]
	cmp EAX , dword[n]
	jae .exit
	
	mov EBX , arr
	shl EAX ,2
	add EBX ,EAX
	push EBX
	
	call readNum
	add ESP,4
	
	inc dword[EBP-4]
	jmp .loop
	.exit:
		
		add ESP ,4
		pop EBP
		ret
printNum :
	push EBP
        mov EBP, ESP
	
	;printNum(int a)
	;{
	;	int size =0;
	;	int EAX = n;
	;	while(EAX!=0)
	;	{
	;		EAX = n/10
	;		EDX = n%10
	;		push EDX
	;		size++
	;	}
	;	while(size!=0)
	;	{
	;		pop ECX
	; 		print ECX
	;		size--
	;	}
	;	clear the variable
	;}
	push dword 0
	mov EAX , dword[EBP+8]	
	.loop1:
		cmp EAX,0
		je .loop2
		
		mov EBX ,10
		mov EDX,0	
		div EBX
		
		push EDX
		inc dword[EBP-4]	
		jmp .loop1
	.loop2 :
		cmp dword[EBP-4],0
		je .exit
		pop dword[temp]
		
		add byte[temp],30h
		
		mov EAX ,4
		mov EBX ,1
		mov ECX , temp
		mov EDX , 1
		int 80h 
		
		dec dword[EBP-4]
		jmp .loop2
	.exit :
		add ESP ,4
		pop EBP	
		ret

isPrime:
	push EBP
        mov EBP, ESP
	
	;isPrime(int a)
	;{
	;	int i =2;
	;	while(i<n)
	;	{
	;		if(a%i==0) break;
	;	}
	;	if(i==n-1)
	;	{
	;		printNum(a);
	;	}
	;}
	push dword 2
	.loop:
		mov EBX , dword[EBP-4] ; eBX= i
		cmp EBX , dword[n] 
		jae .prime
		mov EAX , dword[EBP+8]
		mov EDX , 0

		div EBX
		cmp EDX ,0
		je .exit
		
		inc dword[EBP-4]
		jmp .loop
		
		.prime:
			push dword[EBP +8]
			call printNum
			add ESP,4
			
			mov EAX , 4
			mov EBX , 1
			mov ECX ,space
			mov EDX ,1
			int 80h
			
		.exit:
			add ESP , 4
			pop EBP
			ret
			
		
printPrime :
	push EBP
	mov EBP, ESP
	;isPrime()
	;{
	;	int i=0;
	;	while(i<n)
	;	{
	;		isPrime(arr[i])
	;		i++;
	;	}
	;}
	push dword 0
	.loop :
		mov EAX , dword[EBP-4]
		cmp EAX , dword[n]
		jae .exit
		
		shl EAX,2
		add EAX , arr
		mov EAX ,dword[EAX]
		push EAX
		
		call isPrime
		
		add ESP,4
		inc dword[EBP-4]
		jmp .loop
	.exit :
		add ESP ,4
		pop EBP
		ret
	
	
