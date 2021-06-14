section .data
msg1 : db 'Enter elements for row major matrix1 : ',10,0
l1 : equ $-msg1
msg2 : db 'Enter elements for row major matrix2 : ',10,0
l2 : equ $-msg2
msg3 : db 'The new matrix is : ',10,0
l3 : equ $-msg3
msg4 : db 'Enter the no. of rows in 1st matrix : ',10,0
l4 : equ $-msg4
msg5 : db 'Enter the no. of cols in 1st matrix : ',10,0
l5 : equ $-msg5
msg6 : db 'Enter the no. of rows in 2nd matrix : ',10,0
l6 : equ $-msg6
msg7 : db 'Enter the no. of cols in 2nd matrix : ',10,0
l7 : equ $-msg7
arr1 : times 100 dd 0
row1 : dd 0
col1 : dd 0
arr2 : times 100 dd 0
row2 : dd 0
col2 : dd 0
space : db ' '
new: db 10
arr : times 100 dd 0
bug : dd 0

section .text

global _start
_start:
	push EBP
	mov EBP,ESP
	
	mov EAX,4
	mov EBX,1
	mov ECX,msg4
	mov EDX,l4
	int 80h
	
	push row1
	call readNum
	add ESP,4		

	mov EAX,4
        mov EBX,1
        mov ECX,msg5
        mov EDX,l5
        int 80h
	
	push col1
        call readNum
        add ESP,4
	
	mov EAX,4
        mov EBX,1
        mov ECX,msg1
        mov EDX,l1
        int 80h
	
	push dword[col1]
	push dword[row1]
	push arr1
	call readMatrix	
	add ESP,12
	
	;push dword[col1]
	;push dword[row1]
	;push arr1
	;call printMatrix
	;add ESP,12
	
	;mov EAX ,1
	;mov EBX ,0
	;int 80h
	
	mov EAX,4
        mov EBX,1
        mov ECX,msg6
        mov EDX,l6
        int 80h

        push row2
        call readNum
        add ESP,4
	
	mov EAX,4
        mov EBX,1
        mov ECX,msg7
        mov EDX,l7
        int 80h

        push col2
        call readNum
        add ESP,4

	mov EAX,4
        mov EBX,1
        mov ECX,msg2
        mov EDX,l2
        int 80h
	
        push dword[col2]
        push dword[row2]
        push arr2
        call readMatrix 
        add ESP,12

	mov EAX, dword[col1]
	cmp EAX, dword[row2]
	jne .exit 
	
	;push dword[col2]
	;push dword[row2]
	;push arr2
	;push dword[col1]
	;push dword[row1]
	;push arr1
	;push arr
	call multiply
	;add ESP,28
		
	push dword[col2]
	push dword[row1]
	push arr
	call printMatrix
	add ESP,12
	
	.exit :
	
	pop EBP
	
	mov EAX,1
	mov EBX,0
	int 80h
readNum :
	push EBP
	mov EBP,ESP
;readNum(int *n)
;{
;	char c='\0'
;	while(1)
;	{
;		readChar(&c);
;		if(c==10) break;
;		*n= *n*10
;		c=c -30h
;		*n += c;
;	}
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
		mov ECX, dword[EBP+8]
		mov EAX ,dword[ECX]
		mov EBX,10
		mov EDX,0
		mul EBX
		
		sub byte[EBP-4],30h
		add AL, byte[EBP-4]
		mov dword[ECX], EAX
		jmp .loop
	.exit :
		add ESP,4
		pop EBP
		ret
printNum:
	push EBP
        mov EBP,ESP
;printNum(int a)
;{
;	mov EAX  = a;
;	EBX = 10;
;	int size =0;	
;	while(EAX!=0)
;	{
;		mov EDX , 0
;		div EBX
;		push EDX;
;		size++
;	}
;	while(size!=0)
;	{
;		pop dword[bug]
;		bug = bug -30h
;		print bug
;		size --
;	}
;	del size
;}
	mov EAX , dword[EBP+8]
	cmp EAX ,0
	jne .continue
	add dword[EBP+8],30h
	mov EAX,4
	mov EBX,1
	mov ECX, EBP
	add ECX ,8
	mov EDX,1	
	int 80h
	jmp .exit1	
		
.continue:
	mov EAX , dword[EBP+8]
	mov EBX ,10
	push dword 0
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
		add dword[bug],30h
		mov EAX,4
		mov EBX,1
		mov ECX, bug
		mov EDX,1	
		int 80h
		
		dec dword[EBP-4]
		jmp .loop2
	.exit:
	add ESP ,4
	.exit1:
	pop EBP
	ret
	
readMatrix :
	push EBP
	mov EBP,ESP
;readMatrix(int *arr,int row,int col)
;{
;	int i=0;
;	while(i<row)
;	{
;		int j=0;
;		while(j<col)
;		{
;			readNum(arr+i*col+j);
;			j++;
;		}
;		i++
;		del j
;	}
;	del i
;}
	push dword 0
	.loop1:
		mov EAX , dword[EBP-4]
		cmp EAX , dword[EBP+12]
		jae .exit1
		push dword 0
		.loop2:
			mov EAX ,dword[EBP+16]; EAX = col
			mov EBX , dword[EBP-8]; EBX = j
			cmp EBX,EAX
			jae .exit2
			
			mov ECX , dword[EBP-4]; ECX = i
			shl ECX,2			
			mov EDX,0
			mul ECX
			
			shl EBX,2
			add EAX , EBX
			;pusha
			;push EAX
			;call printNum
			;add ESP,4			
			;popa
				
			add EAX ,dword[EBP+8] ; EAX = arr +i*col +j
		
			;pusha			
			push EAX
			call readNum
			add ESP,4
			;popa
			
			;push dword[EBP-4]
			;call printNum
			;add ESP,4				
			
			inc dword[EBP-8]
			jmp .loop2
			
		.exit2: 
			inc dword[EBP-4]
			add ESP,4
			jmp .loop1
	.exit1:
	      	add ESP,4
              	pop EBP	
		ret
		
printMatrix :
	push EBP
	mov EBP,ESP
	push dword 0
        .loop1:
                mov EAX , dword[EBP-4]
                cmp EAX , dword[EBP+12]
                jae .exit1
                push dword 0
                .loop2:
                        mov EAX ,dword[EBP+16]; EAX = col
                        mov EBX , dword[EBP-8]; EBX = j
                        cmp EBX,EAX
                        jae .exit2

			shl EAX,2
                        mov ECX , dword[EBP-4]; ECX = i
                        mov EDX,0
                        mul ECX; EAX  = col *i
			shl EBX,2
                        add EAX , EBX
			;pusha
			;push EAX
			;call printNum
			;add ESP,4			
			;popa
			
                        add EAX ,dword[EBP+8] ; EAX = arr +i*col +j
                        push dword[EAX]
                        call printNum
                        add ESP,4

			mov EAX , 4
			mov EBX ,1
			mov ECX ,space
			mov EDX,1
			int 80h
			
                        inc dword[EBP-8]
                        jmp .loop2

                .exit2:
			mov EAX,4
			mov EBX,1
			mov ECX,new
			mov EDX,1
			int 80h
			
                        inc dword[EBP-4]
                        add ESP,4
                        jmp .loop1
        .exit1:
                add ESP,4
                pop EBP
                ret
mult :
	push EBP
	mov EBP,ESP
	mov EAX , dword[EBP+8]
	mov EDX,0
	mov EBX, dword[EBP+12]
	mul EBX
	
	pop EBP
	ret


multiply:
	push EBP
	mov EBP,ESP
	push dword 0
;multiply(int *arr,int *arr1,int row1,int col1,int *arr2, int row1,int col2 )
;{
;	int i=0;
;	while(i<row1)
;	{
;		int j =0 ;
;		while(j<col2)
;		{
;			int k=0;
;			while(k<col1)
;			{
;				arr[i][j] += arr1[i][k]* arr2[k][j] 
;				k++
;			}
;			j++
;		}
;		i++
;	}
;}
	.loop1:
		mov EAX, dword[EBP-4]
		cmp EAX , dword[row1]
		jae .exit1
		push dword 0
		.loop2:
			mov EBX , dword[EBP-8]
			cmp EBX , dword[col2]
			jae .exit2
			push dword 0
			.loop3:
				mov ECX , dword[EBP-12]
				cmp ECX , dword[col1]
				jae .exit3
				
				mov EAX, dword[EBP-4]
				shl EAX,2 ; EAX = i*4
				mov EDX , 0
				mov EBX, dword[col1] 
				mul EBX; EAX = i*col1*4
				
				mov ECX , dword[EBP-12]
				shl ECX ,2				
				add EAX , ECX 
				add EAX ,arr1 ;arr1 +i*col1*4 +k*4
				mov EAX , dword[EAX]
				
				push EAX ; arr1[i][k] = -16
				;call printNum
				
				;mov EAX ,4
				;mov EBX ,1
				;mov ECX ,space
				;mov EDX ,1
				;int 80h
						
				mov ECX , dword[EBP-12]
				shl ECX,2				
				mov EAX , dword[col2] ; EAX = col2
				mov EDX , 0
				mul ECX ; EAX = col2*4*k
				mov ECX , dword[EBP-8]
				shl ECX,2
				add EAX , ECX ; EAX  =col2*4*k +j*4
				add EAX , arr2 
				mov EAX , dword[EAX] ; EAX = arr2[k][j]
				
				pop EBX ; EBX = arr1[i][k]
				
				mov EDX ,0
				mul EBX
				
				push EAX
				;call printNum
				
				;mov ECX , dword[EBP-12]
				;shl ECX,2
				mov EAX , dword[col2] ; EAX = col1
                                mov EDX , 0
				mov ECX , dword[EBP-4] ; ECX  = i
				shl ECX,2	;ECX  = 4*i
                                mul ECX ; EAX = col2*4*i
				mov ECX , dword[EBP-8]
				shl ECX ,2 
				add EAX , ECX ; EAX = col2*i*4 +j*4
				add EAX , arr
				
				pop EBX
				add dword[EAX],EBX 
				
				;push dword[EBP-8] ;j
				;call printNum 
				;add ESP,4
				
				inc dword[EBP-12]
				jmp .loop3
			.exit3:
				add ESP,4	
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


			 
		
	


