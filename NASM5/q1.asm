section .data
msg1 : db "Enter the number",10,0
l1 : equ $-msg1
format1 : db "%lf",0
format2 : db "%lf",10

section .bss
num1 : resq 1
num2 : resq 1
num3 : resq 1
section .text

global main
extern scanf
extern printf

read :
	push EBP
	mov EBP,ESP
	sub ESP,8
	lea EAX ,[EBP-8]
	push EAX
	push format1
	call scanf
	add ESP,8
	
	fld qword[EBP-8]
	mov EAX , dword[EBP+8]
	fst qword[EAX]
	add ESP,8
	mov ESP,EBP
	pop EBP
	ret
	
print :
	push EBP
	mov EBP,ESP
	sub ESP,8
	
	mov EBX , dword[EBP+8]
	fld qword[EBX]
	
	fst qword[EBP-8]
	
	push format2
	call printf
	add ESP,8
	
	mov ESP,EBP
	pop EBP
	ret	
	
main:
	mov EAX,4
	mov EBX,1
	mov ECX,msg1
	mov EDX,l1
	int 80h
	
	push num1
	call read
	add ESP,4
	
	push num2
	call read
	add ESP,4
	
	FLD qword[num1]
	fmul qword[num2]
	fst qword[num3]

	push num3
	call print
	add ESP,4
	
	mov EAX,1
	mov EBX,0
	int 80h	
	 
	
