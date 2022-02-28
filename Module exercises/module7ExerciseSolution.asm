TITLE Module 7 Exercise solution

INCLUDE Irvine32.inc

.stack		;;;;; is this needed?
			;;;;; This is to ask for memory for a stack segment.
			;;;;; It is not needed if we include Irvine32.inc
			;;;;; because the Irvine include file already sets 
			;;;;; the stack to 4K bytes.


;; answer for 2c:				; the string name is passed to the macro
printStr MACRO inStr, val		; val is an unsigned value smaller than a dword
	push edx				; save registers that are used
	push eax
	mov edx, OFFSET inStr	; print string
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

; a. write the mul1 procedure that accepts 2 input through registers
;    and returns the product through a register
; b. call the mul1 procedure, passing in the values in al and bl
; c. print the product and text explanation (use the productStr above for the text)

; see answer for a below, after the end of main procedure

; answer for b:
mov al, 5		; pass 5 through register al
mov bl, 3		; pass 3 through register bl
call mul1		
;;; return value (product) is returned in ax

; answer for c:
movzx eax, ax	; extend to eax to print
mov edx, OFFSET productStr
call writeString
call writeDec
call crlf



;;;;; part 2   parameter passing through the stack: pass by value

; a. write the mul2 procedure that accepts 2 input through the stack
;    and returns the product through the stack
; b. call mul2 to do:  prod = n1 * n2
; c. define a macro that accepts a string and an unsigned value
; d. invoke the macro with the productStr (defined above) to print on a separate line: product is ---

; see answer for a below, after main procedure

; answer for b:
sub esp, 4			; make room for return value
movzx eax, n1		; extend n1 byte to a dword to push into stack, since stack data are always 32 bits
push eax			; n1 in stack
movzx eax, n2		; extend n2 byte to a dword to push into stack
push eax			; n2 in stack
call mul2
pop eax				; pop return value into eax
mov prod, ax		; store ax word into prod

; answer for d:
printStr productStr, prod


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

; answer for b:
push OFFSET prod		; pass prod by address since prod needs to be updated
push OFFSET n2			; pass n2 by address since n2 needs to be updated
movzx eax, n1
push eax				; pass n1 by value since n1 isn't changed by calc
call calc
	; after the return, both prod and n2 are already updated by the calc procedure,
	; no need for return value

; answer for c:
printStr productStr, prod
printStr n2Str, n2


exit
main ENDP

;; answer for 1a
; mul1 multiplies 2 bytes 
; input: al, bl
; output: ax
mul1 PROC
	mul bl	; al * bl, product in ax
	ret		; so execution can go back to main
mul1 ENDP



;; answer for 2a
; mul2 multiplies 2 bytes
; input: n1, n2 on stack
; output: on stack
;;; stack frame:
; ret val		ebp + 16
; n1			ebp + 12
; n2			epb + 8
; ret addr		ebp + 4
; ebp			ebp + 0
; saved regs	ebp - 4

mul2 PROC	
	; set ebp
	push ebp		
	mov ebp, esp	
	; save  registers	
	push eax
	push edx		; why push edx?			
	; do work
	mov eax, [ebp + 12]			; eax = n1
	mul DWORD PTR [ebp + 8]		; eax = n1 * n2, edx should be 0 since n1, n2 are bytes
	mov [ebp + 16], eax			; ret val = eax

	COMMENT !
	alternate version for multiplication, using bytes:
	mov al, [ebp + 12]					; al = 1 byte of n1 DWORD on the stack
	mul BYTE PTR [ebp + 8]				; ax = n1 * n2,  n1, n2 are bytes, result is in ax
	movzx DWORD PTR [ebp + 16], ax		; return ax that's extended to 32 bits on the stack
	;;; if using this version, there is no need to save and restore edx
	!

	; restore registers
	pop edx
	pop eax
	pop ebp
	; return and clear input parameters
	ret 8
mul2 ENDP


;; answer for 3a
; calc runs:
;      prod = prod * n1 + n2    ; prod needs to be updated (pass by address)
;      n2 = n2 - 1				; n2 needs to be updated (pass by address)
; input: n1, n2 address, prod address
; output: none
;; stack frame:
; addr prod			ebp + 16
; addr n2			ebp + 12
; n1				ebp + 8
; ret addr			ebp + 4
; ebp
; all regs

calc PROC
	; set ebp
	push ebp
	mov ebp, esp
	; save all registers
	pushad

	; do work
	; a. fetch input from stack:
	mov edx, [ebp + 16]			; edx = addr prod
	mov ebx, [ebp + 12]			; ebx = addr n2
	; b. call mul2 to do prod * n1
	sub esp, 4					; make room for return value
	movzx eax, WORD PTR [edx]	; extend prod (WORD) into 32 bits
	push eax					; pass prod
	push DWORD PTR [ebp + 8]	; pass n1
	call mul2
	pop eax						; eax = prod * n1
		;;;; note that the input arguments to mul2 are both 32 bits	
	; c. add n2
	movzx ecx, BYTE PTR [ebx]	; extend n2 to 32 bits
	add eax, ecx				; eax = (prod * n1) + n2
	; d. store result back in prod
	mov [edx], ax				; prod = ax, must be WORD size since prod is a WORD
	; e. decrement n2
	dec BYTE PTR [ebx]			; decrement byte at n2

	; restore registers
	popad
	pop ebp
	; return and clear input params
	ret 12
calc ENDP


COMMENT !
; Both prod and n2 will be modified by calc
; so it might be tempting to save room for 2 return values 
; on the stack, or in HLL terminology: to return 2 values.

; However, no commonly used HLL accepts 2 return values.

; And if we're going to write assembly procedures that use
; the stack for input parameters, so that they can be run with HLL,
; then we also need to return only 1 value.

; The solution to having the callee (called procedure) update multiple variables
; of the caller is:   the caller passes the ADDRESS of the 
; variable, instead of passing the data or value of the variable.
; (In C/C++, this is called pass by address / reference)

;    pass by address means that main sends the address
;    of these variables to calc. Then calc dereferences
;    the address in order to get to the memory location where the
;    variable is and modifies the data directly.
!

END main

