section .data

msg1 :db 'Enter 1st num : ',10
l1 : equ $-msg1
msg2 :db 'Enter 2nd num : ',10
l2 : equ $-msg2
 
section .bss

xh : resb 1
xl : resb 1
yh : resb 1
yl : resb 1
jnk : resb 1
out0 : resb 1
out1 : resb 1
out2 : resb 1

section .data

global _start:
_start :
	mov EAX, 4
	mov EBX, 1
	mov ECX, msg1
	mov EDX, l1
	int 80h		

	mov EAX, 3
        mov EBX, 0
        mov ECX, xh
        mov EDX, 1
	int 80h
	
	mov EAX ,3
        mov EBX ,0
        mov ECX ,xl
        mov EDX ,1
	int 80h

	mov EAX ,3
        mov EBX ,0
        mov ECX ,jnk
        mov EDX ,1
	int 80h

	mov EAX, 4
        mov EBX, 1
        mov ECX, msg2
        mov EDX, l2
        int 80h	

	mov EAX ,3
        mov EBX ,0
        mov ECX ,yh
        mov EDX ,1
	int 80h

	mov EAX ,3
        mov EBX ,0
        mov ECX ,yl
        mov EDX ,1
	int 80h
	
	mov EAX ,3
        mov EBX ,0
        mov ECX ,jnk
        mov EDX ,1
        int 80h	
	
	;mov EAX, 4
        ;mov EBX, 1
        ;mov ECX, yh
        ;mov EDX, 1
        ;int 80h
	
	;mov EAX, 4
        ;mov EBX, 1
        ;mov ECX, yl
        ;mov EDX, 1
        ;int 80h
	
	;jmp exit
	sub byte[xh],30h
	sub byte[yh],30h
	sub byte[xl],30h
	sub byte[yl],30h

	mov AL, byte[xl]
	add AL, byte[yl]
	mov AH ,0
	mov BL ,10
	div BL
	
	mov byte[out0],AH
	mov byte[out1],AL
	
	mov AL, byte[xh]
        add AL, byte[yh]
        mov AH ,0
        mov BL ,10
        div BL

        add byte[out1],AH
        mov byte[out2],AL
	
	add byte[out0],30h
	add byte[out1],30h
	add byte[out2],30h

	mov EAX, 4
        mov EBX, 1
        mov ECX, out2
        mov EDX, 1
        int 80h
	
	mov EAX, 4
        mov EBX, 1
        mov ECX, out1
        mov EDX, 1
        int 80h
	
	mov EAX, 4
        mov EBX, 1
        mov ECX, out0
        mov EDX, 1
        int 80h

	exit :mov EAX, 1
	mov EBX, 0
	int 80h	


