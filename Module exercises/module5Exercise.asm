TITLE Module 5 Exercise		

;	Name: Tom Ekshtein 

INCLUDE Irvine32.inc

.data
count DWORD ?

.code
main PROC

;;;;;;;;;;;;;;;;;;;; part 1 ;;;;;;;;;;;;;;;;;
; unconditional JMP
; which instructions below will run?

L2: 
    mov eax, 5		; this will execute first
	jmp L1			; then we jump to L1 
	mov ebx, 6		; 
	mov ecx, 7		; 
	jmp L2			; 
L1:   
	mov edx, 8		; this will execute afterwards.
	  

; LOOP 
; what is the value of eax after the loop finishes?
; The value would be 4 since we start at 0 and increment it before the loop jump executes
	mov ecx,4
	mov eax,0
L3:
	inc eax		; 
	loop L3		; 
				; 
	
; what if, in the loop above, we use: mov ecx, 0 instead of: mov ecx, 4
; will the loop run? yes
; how many times? it will seem infinite but not really. In reality it would run 4,294,967,295 times since
; ECX would be 0000 0000 and the Loop decrements it to FFFF FFFF. So in order to reach 0 again it would run
; 4,294,967,295 times.


; write a nested loop using LOOP instructions: the outer loop runs 5 times
; the inner loop runs 3 times

mov ecx, 5
mov eax, 0
mov ebx, 0
L4:
	mov count, ecx
	mov ecx, 3
	inc eax
	L5:
		inc ebx
		loop L5
		mov ecx, count
		loop L4
	




; implement the same nested loop without LOOP instruction
mov eax, 0
mov ebx, 0
mov ecx, 5
mov edx, 0

outerLoop:
	add edx, 3
	inc eax
	cmp eax, ecx
	ja done
	jne innerLoop
	
	innerLoop:
		inc ebx
		cmp edx, ebx
		je outerLoop
		jne innerLoop
		

Done:
nop


;;;;;;;;;;;;;;;;; part 2 ;;;;;;;;;;;;;;;;;;;;;;

; write code to jump to L10 if the carry flag is set after adding ax and bx
; assume ax and bx have values
; add ax, bx
; jc L10

; write code to jump to L20 if ax > bx (signed data)
; cmp ax, bx
; jg L20

; write code to jump to L30 if ax > bx (unsigned data)
; cmp ax, bx
; ja L30



; implement the following pseudocode to work with signed data
; if (ax <= 10 AND bx > 0)    ;ax = 5, bx = 5
;   dx = 0
; else
;   dx = 5
mov ax, 5
mov bx, 5
cmp ax, 10			; clare code
jle firstBlock		; jg falseBlock
jmp elseBlock		; use fall through logic. no need to code another jump, instead make the condition directly
					; below so it goes to that logic afterwards if the jump doesn't happen

firstBlock:
	cmp bx, 0
	jg secondBlock

secondBlock:
	mov dx, 0
	jmp finally

elseBlock:
	mov dx, 5

finally:
	nop






; implement the following pseudocode to work with unsigned data
; while (ax > bx OR cx != 0)
; {
;    bx = bx * 2
;    cx = cx - 1
; }
mov bx, 2
mov cx, 2

top: 
	mov ax, 5
	cmp ax, bx
	jbe next
	cmp cx, 0
	jcxz next

body:
	mov dx, 2
	mov ax, bx
	mul dx
	mov bx, ax
	sub cx, 1
	jmp top


next:
	nop
	






;;; if (ax > bx AND bx > cx OR dx == 0)  ;; unsigned
;;;   si = 0
;;; else
;;;   si = 1

mov ax, 1
mov bx, 7
mov cx, 8
mov dx, 0

cmp ax, bx
ja one
cmp dx, 0
je two
jmp three

one:
	cmp bx, cx
	ja two
	cmp dx, 0
	je two

two:
	mov si, 0
	jmp finish

three:
	mov si, 1
	jmp finish


finish:
	nop




	exit
main ENDP

END main