
; Description:
; 

INCLUDE Irvine32.inc

.data
mesg BYTE "Hello world",0dh,0ah,0

.code
main PROC
	call Clrscr

	mov	 edx, OFFSET mesg
	call WriteString
	mov ebx, -18
	exit
main ENDP

END main