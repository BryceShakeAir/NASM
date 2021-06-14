section .data
msg1 : db 'Enter the no. of floating point numbers',10,0
l1 : equ $-msg1
msg2 : db 'Enter arr: ',10,0
l2 : equ $-msg2
msg3 : db 'Sorted arr is : ',10,0
l3 : equ $-msg3
dr : db '%d',0
fr : db '%lf',0
fw : db '%lf',10

section .bss
n : resd 1
arr : resq 100
num : resq 1
section .text

global main
extern scanf
extern printf

readNat:
	push EBP
	mov EBP,ESP
	sub ESP,2
	
	push ESP	
	push dr
	call scanf
	add ESP,8
	
	mov EAX , dword[EBP+8]
	mov BX , word[EBP-2];
	mov dword[EAX],0
	mov word[EAX],BX
	
	mov ESP,EBP
	pop EBP
	ret	

read :
	push EBP
	mov EBP,ESP
	sub ESP,8
	
	push ESP	
	push fr
	call scanf
	add ESP,8
	
	mov EAX , dword[EBP+8]
	fld qword[EBP-8];
	fstp qword[EAX]
	
	mov ESP,EBP
	pop EBP
	ret
	
readArr:
	push EBP
	mov EBP,ESP
	
	push dword 0
	
	.loop:
		mov EAX , dword[EBP-4]
		cmp EAX , dword[EBP+12]
		jae .exit
		
		mov EBX , dword[EBP-4]
		mov EDX , dword[EBP+8]
		lea EAX , [EDX+8*EBX]
		push EAX		
		call read
		add ESP,4
		
		;mov EAX ,4
		;mov EBX ,1
		;mov ECX ,msg1
		;mov EDX ,l1
		;int 80h		
		
		inc dword[EBP-4]
		jmp .loop
	.exit:
		mov ESP,EBP	
		pop EBP
		ret
swap:
	push EBP
	mov EBP,ESP
	
	lea EBX , [EBP+8] 
	mov EAX , dword[EBX] ; EAX = a;
	fld qword[EAX] ; st0 = *a
	
	lea ECX , [EBP+12]
	mov EDX , dword[ECX] ; EDX = b
	fld qword[EDX] ; st0 = *b ; st1 = *a
	
	fstp qword[EAX]
	fstp qword[EDX]
	
	mov ESP,EBP
	pop EBP
	ret
;void sort(int *arr,int n)
;{
;	int i=0;
;	while(i<(n-1))
;	{
;		int j =0;
;		while(j<(n-i-1))
;		{
;			if(arr[j]<arr[j+1])
;				swap(&arr[j],&arr[j+1]);
;			j++
;		}
;	}
;}
sort :
	push EBP
	mov EBP,ESP
	
	push dword 0
	.loop1:
		mov EDX,dword[EBP+12]
		dec EDX
		cmp dword[EBP-4] , EDX
		jae .exit
			
		push dword 0
		
		.loop2:
			mov EDX,dword[EBP+12]
			sub EDX ,dword[EBP-4]
			dec EDX ; EDX = n-i-1
			cmp dword[EBP-8], EDX
			jae .exit1
			
			mov ECX , dword[EBP-8]; ECX = j;
			mov EBX , dword[EBP+8]
			lea EDX , [EBX+8*ECX]
			
			fld qword[EDX] ; st0 = arr[j] ;
			
			mov ECX , dword[EBP-8]; ECX = j;
			inc ECX ; ECX = j+1
			mov EBX , dword[EBP+8]
			lea EDX , [EBX+8*ECX]
			
			fcomp qword[EDX]
			fstsw AX
			sahf
			jae .exit2 ; arr[j+1] > arr[j]
			
			mov ECX , dword[EBP-8]; ECX = j;	
			mov EBX , dword[EBP+8]
			lea EDX , [EBX+8*ECX]
			
			push EDX
			
			mov ECX , dword[EBP-8]; ECX = j;
			inc ECX ; ECX = j+1
			mov EBX , dword[EBP+8]
			lea EDX , [EBX+8*ECX]
			
			push EDX
			
			call swap
			add ESP,8
	
			.exit2:
				inc dword[EBP-8]
				jmp .loop2
									
		.exit1:
			add ESP,4
			inc dword[EBP-4]
			jmp .loop1
					
	.exit:
		add ESP,4
		mov ESP,EBP
		pop EBP
		ret
print :
	push EBP
	mov EBP,ESP
	
	sub ESP,8
	fstp qword[EBP-8]
	push fw
	call printf
	add ESP,4
	
	mov ESP,EBP
	pop EBP
	ret		
	
printArr:
	push EBP
	mov EBP,ESP
	push dword 0
	.loop:
		mov EAX , dword[EBP+12]
		cmp dword[EBP-4], EAX
		jae .exit
		
		;mov EAX ,4
		;mov EBX,1
		;mov ECX,msg1
		;mov EDX,l1
		;int 80h				
	
		mov EBX , dword[EBP-4]
		mov EDX , dword[EBP+8] ; EDX = arr
		lea EAX , [EDX+8*EBX] ; EAX = arr +8*j
		fld qword[EAX]
		call print
		
		;mov EAX ,4
		;mov EBX,1
		;mov ECX,msg1
		;mov EDX,l1
		;int 80h		
				
		inc dword[EBP-4]
		jmp .loop			
	.exit:
		add ESP ,4
		mov ESP,EBP	
		pop EBP
		ret		
main :
;int main()
;{
;	int n;
;	read n;
;	readArray
;	sort
;	printArray
;}
	mov EAX ,4
	mov EBX,1
	mov ECX,msg1
	mov EDX,l1
	int 80h
	
	push n
	call readNat
	add ESP,4
	
	mov EAX ,4
	mov EBX,1
	mov ECX,msg2
	mov EDX,l2
	int 80h

	push dword[n]
	push arr
	call readArr
	add ESP,8
	
	push dword[n]
	push arr
	call sort
	add ESP,8

	mov EAX ,4
	mov EBX,1
	mov ECX,msg3
	mov EDX,l3
	int 80h

	push dword[n]
	push arr
	call printArr
	add ESP,8

	push dword[n]
	push arr
	call printArr
	add ESP,8
	

	mov EAX ,1
	mov EBX,0
	int 80h	

