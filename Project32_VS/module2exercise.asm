
; Description:
; 

INCLUDE Irvine32.inc

.data
mesg BYTE "Hello world",0dh,0ah,0
num1 BYTE 4
num2 WORD 42
c1 BYTE 'b' 

.code
main PROC
	call Clrscr

	mov	 edx, OFFSET mesg
	call WriteString
	mov ebx, -18
	exit
main ENDP

END main