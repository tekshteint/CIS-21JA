TITLE Module 7 Example
;;;;;; this example file was produced from the Zoom class meeting on 2/16
;;;;;; review the 2/16 recording for discussion of this file if needed


INCLUDE Irvine32.inc

.stack

.data
n1 BYTE 5
n2 BYTE 10
sum WORD ?
n3 BYTE 8
n4 BYTE 20

.code
main PROC

;;;;;;;;;; calling procedure and pass arguments through registers ;;;;;;;;;;

; 1st call to addRegs:   ax = addRegs(n1, n2)
; 1. pass arguments through registers
mov al, n1
mov bl, n2
; 2. call the procedure
call addRegs
; 3. print return value 
movzx eax, ax
call writeDec
call crlf

; 2nd call to addRegs:  ax = addRegs(n3, n4)
; 1. pass arguments through registers
mov al, n3
mov bl, n4
; 2. call the procedure
call addRegs
; 3. print return value 
movzx eax, ax
call writeDec
call crlf

;;;; The only reason the addRegs procedure (or any procedure)
;;;; can work with any input argument values is if you make sure
;;;; your procedure doesn't use specific variable names like n1, n2, n3...
;;;; Instead, your procedure should only get input from the registers
;;;; or stack. This guarantees that your procedure will work with data 
;;;; that the caller passes in and not with some hard coded variable names


;;;;;;;; calling procedure and passing argument through the stack ;;;;;;;;;

; stack frame from calling addStack below:
; room for ret value    <- bottom
; n1  
; n2
; return address


; 0. save room for return value
push eax
; 1. pass arguments through the stack
movzx eax,n1
push eax
movzx eax, n2
push eax
; 2. call the procedure
call addStack
; 3. print return value 
pop eax
call writeDec

exit
main ENDP


; addRegs: add 2 input arguments in registers
; input: al, bl
; output: ax
addRegs PROC
	add al, bl		; add arguments in registers al and bl
	movzx ax, al    ; store sum in ax
	ret
addRegs ENDP


; stack frame for addStack call:
; room for ret val  <- ebp+16
; n1                <- ebp+12
; n2                <- ebp+8
; return address    <- ebp+4 
; ebp               <- ebp
; eax               <- esp

; addStack: add 2 input arguments on stack
; input: see stack frame
; output: see stack frame
addStack PROC	

; step 1: set ebp
push ebp			; save old ebp value that caller might be using
mov ebp, esp		; copy current esp into ebp, setting ebp to be the base
					; for the stack frame

; step 2: save register that are used
push eax			; save old eax that caller might be using

; step 3: do work, which is add
mov al, [ebp+8]		; using ebp to get to input arguments
add al, [ebp+12]   

movzx eax, al		
mov [ebp+16], eax   ; put return value back on stack, by using ebp
					; to get to location of return value

; step 4: restoring registers
pop eax
pop ebx

; step 5: return and clear out input args on the stack
ret 8    ; ret: pop off the return address
         ; 8: then pop off 8 more bytes (2 args on the stack)

addStack ENDP


;;;;;;;;;;;;;;;;;; to be continued...
; nestedAdd: add 2 input arguments twice in nested calls
; input: on stack
; output: on stack
nestedAdd PROC

nestedAdd ENDP


END main

