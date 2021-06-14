section .data
msg1 : db 'Enter the size : ',10,0
l1 : equ $-msg1
msg2 : db 'Enter the elements : ',10,0
l2 : equ $-msg2
msg4 : db 'Enter the element to be searched : ',10,0
l4 : equ $-msg4
msg3 : db 'What type of search : ',10,0
l3 : equ $-msg3
msg5 : db 'Element not found  ',10,0
l5 : equ $-msg5
msg6 : db 'Element is found at  ',0
l6 : equ $-msg6
break : db 10
arr : times 50 dd 0
n : dd 0
i : equ 4
j : equ 8
l : db 'l'
start : equ 4
end : equ 8
k : equ 12

section .bss
bug : resd 1
type : resb 1
key : resd 1

section .text

global _start
_start :
	
	mov EAX,4
	mov EBX ,1
	mov ECX , msg1
	mov EDX,l1
	int 80h
	
	push n
	call readNum
	add ESP , 4
	
	mov EAX,4
        mov EBX ,1
        mov ECX , msg2
        mov EDX,l2
        int 80h

	call readArray
	
	mov EAX,4
        mov EBX ,1
        mov ECX ,msg4
        mov EDX,l4
        int 80h
	
	push key
	call readNum
        add ESP ,4	

	mov EAX,4
        mov EBX ,1
        mov ECX ,msg3
        mov EDX,l3
        int 80h

	mov EAX,3
        mov EBX ,0
        mov ECX , type
        mov EDX,1
        int 80h
	
	mov EAX,3
        mov EBX ,0
        mov ECX ,bug
        mov EDX,1
        int 80h
	
	mov AH, byte[type]
	cmp AH, byte[l]
	jne  .binary
	
	push dword[key] 
	call linearSearch
	add ESP ,4
	
	jmp .exit
	
	.binary :
		
		push dword[n]
        	push arr
		call insertionSort
		add ESP ,8
		
		push dword[key]
		mov EAX, dword[n]
		dec EAX
		
		push EAX
        	push dword 0
		
		mov EAX,4
        	mov EBX ,1
       	 	mov ECX , msg1
        	mov EDX,l1
        	int 80h
		
		call binarySearch 
		add ESP,12
	.exit :
		mov EAX ,1
		mov EBX ,0
		int 80h


readNum:
	push EBP
        mov EBP , ESP
	
	;readNum(int *n)
	;{
	;	char c
	;	while(1)
	;	{
	;		c = getchar;
	;		if(c==10) break
	;		c = c-30h
	; 		*n = *n*10
	;		*n += c
	;	}
	;}
	push dword 0
	.loop:
	
	mov EAX ,3
	mov EBX,0
	mov ECX ,EBP
	sub ECX ,4
	mov EDX,1
	int 80h
	
	cmp byte[EBP-4], 10
	je .exit
	
	sub byte[EBP-4],30h
	
	mov EAX ,dword[EBP+8]
	mov EAX, dword[EAX]
	mov EDX,0
	mov EBX,10
	mul EBX
	
	add AL, byte[EBP-4]	
	mov EBX,dword[EBP+8]
	mov dword[EBX], EAX
	jmp .loop
	
	.exit:
	add ESP,4
	pop EBP
	ret
	
readArray:
	push EBP
        mov EBP , ESP

	;readArray()
	;{
	;	int i=0;
	;	while(i<n)
	;	{
	;		readNum(arr+i)
	;		i++
	;	}
	;}
	
	push dword 0
	.loop:
		mov EAX , dword[EBP-4]
		cmp EAX,dword[n]
		jae .exit
		
		shl EAX ,2
		add EAX ,arr
		push EAX
		call readNum
		add ESP,4
		
		inc dword[EBP-4]
		jmp .loop
	.exit:
		add ESP,4
		pop EBP
		ret	
		
printNum :
	push EBP
        mov EBP , ESP
	;printNum(int a)
	;{
	;	int size = 0
	;	EAX = a
	;	while(EAX!=0)
	;	{
	;		EAX = EAX/10
	;		EDX = EDX%10
	;		push EDX
	;		size++
	;	}
	;	while(size!=0)
	;	{
	;		pop bug
	;		print byte[bug]
	;		size--
	;	}	
	;}
	push dword 0
	mov EAX , dword[EBP+8]
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
		add dword[bug],30h
	
		mov EAX ,4
		mov EBX ,1
		mov ECX,bug
		mov EDX ,1
		int 80h
		
		dec dword[EBP-4]
		jmp .loop2
	.exit:
		add ESP ,4
		pop EBP
		ret
	



linearSearch :
	push EBP
        mov EBP , ESP
	;linearSearch(int key)
	;{
	;	int i =0;	
	;	while(i<n)
	;	{
	;		if(arr[i]==key)
	;		{
	;			print Found at i
	;			break;
	;		}
	;	}
	;	if(i==n-1)
	;	{
	;		printNOT FOUND
	;	}
	;}
	push dword 0 
	.loop :
		mov EAX , dword[EBP-4]
		cmp EAX , dword[n]
		jae .notfound
		
		shl EAX ,2
		add EAX ,arr
		mov EAX,dword[EAX]
		;pusha
		
		;push dword[EBP+8] 
		;call printNum
		;add ESP ,4
		
		;popa
		cmp EAX,dword[EBP+8] ; arr[i] == key
		je .found
		
		inc dword[EBP-4]
		jmp .loop
	.notfound:
		mov EAX,4
                mov EBX,1
                mov ECX ,msg5
                mov EDX,l5
                int 80h
		
		jmp .exit
	.found :
		mov EAX,4
                mov EBX,1
                mov ECX ,msg6
                mov EDX,l6
                int 80h

                push dword[EBP-4]
                call printNum
                add ESP,4
		
		mov EAX,4
                mov EBX,1
                mov ECX ,break
                mov EDX,1
                int 80h
		
	.exit:
		add ESP ,4
		pop EBP
		ret
		

swap :
	push EBP
	mov EBP , ESP
	
	mov EAX , dword[EBP+8]
	mov EBX , dword[EAX]
	
	mov ECX , dword[EBP+12]  
        mov EDX , dword[ECX]
	
	mov dword[ECX],EBX
	mov dword[EAX],EDX
		
	pop EBP
	ret 

insertionSort:
	push EBP
        mov EBP , ESP
	
	;insertionSort(int *arr,int n)
	;{
	;	int i =0;
	;	while(i<n-1)
	;	{
	;		int j = i+1
	;		while(j<n)
	;		{
	;			if(arr[j]<arr[i])
	;			{
	;				swap(&arr[i],&arr[j]);
	;			}
	;			j++;
	;		}
	;		i++;
	;	}
	;}
	
	push dword 0
	.loop1:
		mov EAX ,dword[EBP-i]
		mov ECX , dword[EBP+12]
                dec ECX
		cmp EAX, ECX
		jae .exit
		push EAX
		inc dword [EBP-j]
		
		.loop2:
			mov EBX, dword[EBP-j]
			mov ECX , dword[EBP+12]
			cmp EBX , ECX
			jae .exit1
			
			mov EAX ,dword[EBP-i]
			shl EAX ,2
			shl EBX ,2	
			add EAX , arr
			mov EAX , dword[EAX] ; EAX  = arr[i]
			add EBX , arr
                        mov EBX , dword[EBX] ; EBX = arr[j]
			
			cmp EBX , EAX
			jae .exit2
				mov EAX ,dword[EBP-i]
				mov EBX ,dword[EBP-j]
				shl EAX ,2
				shl EBX ,2
					
				add EAX , arr
				add EBX , arr
				pusha
				
				;push dword[EAX]
                                ;call printNum
                                ;pop dword[EAX]
				
				push EAX
				push EBX
				
				call swap
				add ESP ,8
				popa
			
				;push dword[EAX]
				;call printNum
				;pop dword[EAX]
				
				pusha
				mov EAX,4
				mov EBX ,1
				mov ECX, break
				mov EDX ,1		
				popa
				
				;push dword[EBX]
                                ;call printNum
                                ;pop dword[EBX]
				
			.exit2 :
				inc dword[EBP-j]
				jmp .loop2
		.exit1:
			add ESP ,4
			inc dword[EBP-i]
			jmp .loop1
	.exit :
		add ESP,4
		pop EBP
		ret
binarySearch :
	push EBP
	mov EBP,ESP
	
	;binarySearch(int start,int end,int key)
	;{
	;	if(start>end)
	;	{
	;		print Element not found
	;		ret	
	;	}
	;	int mid = (start + end)/2
	;	if(arr[mid]==key) return Found at mid
	;	binarySearch(start,mid,key)
	; 	binarySearch(mid+1,end,key)
	;	clear mid
	;}
	
	mov EAX , dword[EBP+start]
	cmp EAX , dword[EBP+end]
	ja .notfound
	
	add EAX , dword[EBP+end]
	shr EAX,2 ; mid = (start+end)/2
	mov dword[EBP-4],EAX
	
	add EAX ,arr
	mov EAX, dword[EAX]
	cmp EAX, dword[EBP+ k ]
	je .found
	
	push dword[EBP+k]
	push dword[EBP-4]
	push dword[EBP+start]
	call binarySearch
	add ESP ,12
	
	push dword[EBP+k]
        push dword[EBP+end]
	mov EAX , dword[EBP-4]
	inc EAX
	push EAX
        call binarySearch
        add ESP ,12
	
	.exit :
		add ESP ,4
		pop EBP
		ret
			
	.notfound :
		mov EAX,4
		mov EBX,1
		mov ECX ,msg5
		mov EDX,l5
		int 80h
		ret
	.found :
		mov EAX,4
                mov EBX,1
                mov ECX ,msg6
                mov EDX,l6
                int 80h
		
		push dword[EBP-4]
		call printNum
		add ESP,4
		
		jmp .exit
		
		
		
	
	
	
	
	

				 
				

		
	
