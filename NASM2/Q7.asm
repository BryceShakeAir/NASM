section .data
msg1: db 'The size of the array is :  ',10,0
l1 : equ $-msg1
msg2: db 'The elements of the array A are : ',10,0
l2 : equ $-msg2
msg3 :db 'The elements of the array B are : ',10,0
l3 : equ $-msg3
msg4 : db 'The elements of the array C are : ',10,0
l4 : equ $-msg4
n : dd 0
arrA : times 50 dd 0
arrB : times 50 dd 0
A : equ 8
B : equ 12
N : equ 16
section .bss
arrC : resd 50
bug : resd 1
i: equ 4
max : equ 8
section .txt

global _start
_start:
	push EBP
	mov EBP,ESP
	
	mov EAX ,4
	mov EBX ,1
	mov ECX,msg1
	mov EDX , l1
	int 80h
	
	push n
	call readNum
	add ESP,4
	
	mov EAX ,4
        mov EBX ,1
        mov ECX,msg2
        mov EDX , l2
        int 80h
	
	push arrA
	call readArray
	add esp, 4
	
	mov EAX ,4
        mov EBX ,1
        mov ECX,msg3
        mov EDX , l3
        int 80h
	
	push arrB
        call readArray
        add esp, 4

	push dword[n]
	push arrB
	push arrA
	call make 
	add ESP,12
	
	mov EAX ,4
        mov EBX ,1
        mov ECX,msg4
        mov EDX , l4
        int 80h

	
	push arrC
	call printArr
	add ESP,4
	
	pop EBP
	
	mov EAX ,1
	mov EBX ,0	
	int 80h
	
readNum :
	push EBP
        mov EBP,ESP
	
	;c code
	;void readNum(int *n)
	;{
	;	char c='/0';
	;	while(1)
	;	{
	;		c  = getchar(stdin)
	;		if(c==10) return
	;		c = c-30h
	;		*n = *n*10
	;		*n+=c	
	;	}
	;	del c
	;}
	
	push dword 0
	.loop1 :
		
		mov EAX ,3
		mov EBX ,0
		mov ECX ,bug
		mov EDX, 1
		int 80h
		
		cmp byte[bug],10
		je .exit
		
		sub byte[bug],30h
		
		mov ECX ,dword[EBP+8]
		mov EAX , dword[ECX]
		mov EBX ,10
		mov EDX ,0
		mul EBX
		
		add AL ,byte[bug]
		mov dword[ECX],EAX
		
		jmp .loop1
	.exit:
		add ESP ,4
		pop EBP
		ret
printNum :
	push EBP
        mov EBP,ESP
	;c code
	;void printNum(int a)
	;{
	;	EAX = a
	;	int size = 0
	;	while(EAX!=0)
	;	{
	;		EDX = EAX%10
	;		EAX = EAX/10
	;		push EDX
	;		size++
	;	}
	;	while(size!=0)
	;	{
	;		bug = pop
	;		print bug -30
	;	}
	;	del size
	;	
	;}
	push dword 0
	mov EAX , dword[EBP+8]
	.loop1:
		cmp EAX ,0
		jbe .loop2
		
		mov EDX ,0
		mov EBX,10
		div EBX
		
		push EDX
		inc dword[EBP-4]
		
		jmp .loop1
	.loop2:
		cmp dword[EBP-4],0
		je .exit
		
		pop dword[bug]
		add dword[bug],30h
			
		mov EAX ,4 
		mov EBX, 1
		mov ECX , bug
		mov EDX , 4
		int 80h
		
		dec dword[EBP-4]
		jmp .loop2
	.exit:
		add ESP,4
		pop EBP
		ret
		
readArray :
	push EBP
	mov EBP,ESP
	;c code
	;readArray(int *array)
	;{
	;	int i =0;	
	;	while(i<n)
	;	{
	;		readNum(array+i*4)
	;		i++
	;	}
	;	del i
	;}
	push dword 0
	.loop:
		mov EAX, dword[EBP-4]; i
		cmp EAX, dword[n]
		jae .exit
		
		mov EBX , 4
		mov EDX , 0
		mul EBX
		
		add EAX , dword[EBP+8]; arr+i*4
		push EAX
		call readNum
		add ESP,4
		
		inc dword[EBP-4]
		jmp .loop
	.exit :
		add ESP ,4
		pop EBP	
		ret
	
printArr :
	push EBP
	mov EBP,ESP
	
	push dword 0
        .loop:
                mov EAX, dword[EBP-4]; i
                cmp EAX, dword[n]
                jae .exit

                mov EBX , 4
                mov EDX , 0
                mul EBX

                add EAX , dword[EBP+8]; arr+i*4
               	mov EAX ,dword[EAX]
		push EAX
                call printNum
                add ESP,4

                inc dword[EBP-4]
                jmp .loop
        .exit :
                add ESP ,4
                pop EBP
                ret
make:
	push EBP
        mov EBP,ESP
	
	;c code
	;void make(int *arrA,int *arrB,int n)
	;{
	;	int i =0;
	;	int max = 0;
	;	while(i<n)
	;	{
	;		if(arrA[i]>arrB[i])
	;			max = arrA[i]
	;		else max = arrB[i]
	;		
	;		arrC[i] = max
	;		i++;
	;	}	
	;}
	push dword 0 
	push dword 0 
	.loop :
		mov EAX , dword[EBP-i]
		cmp EAX , dword[n]
		jae .exit
		
		shl EAX ,2 ; i = i*4
		
		mov EBX , dword[EBP+B]
		add EBX , EAX 
		mov EBX , dword[EBX];arrB[i]
		
		mov ECX , dword[EBP+A]
                add ECX , EAX
                mov ECX , dword[ECX];arrA[i]
		
		cmp ECX , EBX
		jbe .c1
		
		mov dword[EBP - max],ECX
		jmp .else
		
		.c1 :
			mov dword[EBP - max],EBX
                	jmp .else
		.else:
			mov EBX , arrC
	                add EBX , EAX	;EBX = arrC +i*4
			
			mov EAX , dword[EBP-max]
			mov dword[EBX],EAX
			
			inc dword[EBP-i]
			jmp .loop
		.exit:
			add ESP ,8
			pop EBP
			ret	
			
		
	
		
		
		
		
	

