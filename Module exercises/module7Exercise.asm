TITLE Module 7 Exercise

INCLUDE Irvine32.inc

.stack		;;;;; is this needed? Yes it is, our previous assignments include the irvine32.inc which already declares a stack.

macro1 MACRO myStr, val
	push edx				; save registers that are used
	push eax
	mov edx, OFFSET myStr	; print string
	call writeString
	movzx eax, val			; print numeric value
	call writeDec
	call crlf				; print newline
	pop eax					; restore registers that are used
	pop edx
ENDM

.data
n1 BYTE 3
n2 BYTE 4
prod WORD ?

productStr BYTE "product is ", 0
n2Str BYTE "n2 is ", 0


.code
main PROC


;;;;; part 1   parameter passing through registers

mov al, 5
mov bl, 3

; a. write the mul1 procedure that accepts 2 input through registers
;    and returns the product through a register
;done
;correct


; b. call the mul1 procedure, passing in the values in al and bl

call mul1 ;correct

; c. print the product and text explanation (use the productStr above for the text)

movzx eax, ax	; extend to eax to print
mov edx, OFFSET productStr
call writeString
call writeDec
call crlf

COMMENT ! claire's answer above
mov edx, OFFSET productStr
call WriteString
shl eax, 16
shr eax, 16
call WriteInt
macro1 productStr, n1
!



;;;;; part 2   parameter passing through the stack: pass by value

; a. write the mul2 procedure that accepts 2 input through the stack
;    and returns the product through the stack
; b. call mul2 to do:  prod = n1 * n2

sub esp, 4			; make room for return value
movzx eax, n1		; extend n1 byte to a dword to push into stack, since stack data are always 32 bits
push eax			; n1 in stack
movzx eax, n2		; extend n2 byte to a dword to push into stack
push eax			; n2 in stack
call mul2
pop eax				; pop return value into eax
mov prod, ax		; store ax word into prod


COMMENT ! claire's answer above
sub esp, 4
and ebx, 0
and eax, 0
mov al, byte ptr n1
mov bl, byte ptr n2
push eax
push ebx
!

;call mul2
;pop prod
; c. define a macro that accepts a string and an unsigned value
; DONE IN START OF FILE

movzx eax, ax
mov edx, OFFSET macro1

; d. invoke the macro with the productStr (defined above) to print on a separate line: product is ---
; WORKS



;;;;; part 3   parameter passing through the stack: pass by address or by reference
; a. write the calc procedure to do the following 2 tasks 
;      prod = prod * n1 + n2  
;      n2 = n2 - 1
;   both prod and n2 will be updated
;   calculation should call mul2 to do the multiplication
; b. call calc 
; c. invoke the same macro twice and use the strings defined above to print:
;       product is ---
;       n2 is ---


exit
main ENDP


; mul1 multiplies 2 bytes 
; input: al, bl
; output: ax

mul1 PROC
mul bl

ret 

mul1 ENDP


; mul2 multiplies 2 bytes
; input: n1, n2
; output: on stack
mul2 PROC
push ebp
mov ebp, esp ;saving esp location at ebp

mov eax, [ebp+12]
mov ebx, [ebp+8]
mul ebx
mov [ebp +12], eax

ret 8 ;CAN'T FIGURE THIS PORTION OUT

mul2 ENDP


; calc runs:
;      prod = prod * n1 + n2  
;      n2 = n2 - 1
; input: n1, n2, prod
; output: none
calc PROC

calc ENDP


END main

