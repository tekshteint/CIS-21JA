TITLE Module 4 Class Exercise			


COMMENT !
There are 4 main concepts in module 4:
- data transfer or the mov* instructions
- add / subtract
- multiply / divide
- flags
!

INCLUDE Irvine32.inc

.data
num word 4
negNum word -4			; better to use SWORD since its signed


.code
main PROC
;;;;; part 1: data transfer
; write code to move num into bx
mov bx, num ;mov destination, information

; write code to move num into ecx
movzx ecx, num ;movzx is for smaller data than register size

;also possible to do movzx ebx, ax or movzx, bl
; can't do movzx ebx, eax bc they're the same size


; write code to move negNum into ebx
movsx ebx, negNum ;movxs is signed


;;;;; part 2: arithmetic
;;;;; warm up with basic arithmetic

; write code to add num to ax
add ax, num		;ax = ax+num

; write code to add ax to num
add num, ax

; write code to subtract num from ax
sub ax, num		;ax = ax-num

; write code to subtract ax from num        
sub num, ax

; write code to subtract 1 from ax
sub ax, 1
;also dec ax

; can we write 1 line of code to subtract num1 from num2, if both are defined?
; No we cannot since they are not stored in registers
; Correct: No we can't have 2 memory vairable operands

mov num,4	;reset num value for mul

; write code to multiply num by 5
;incorrect way
;mov ax, num
;mul 5		this does not work bc mul only accepts register or variable

;correct way
mov ax, 5 ;eax = c8a50005 the 0005 is what we moved
mul num
nop ; is a no operation instruction used to stop breakpoints

; write code to multiply ax by num
mov ax, num
mul num


; write code to divide num by 5
mov ax, num
mov bx, 5
mov dx, 0
div bx
;unsigned
;mov dx, 0 ;will zero out the dx or remainder register ;also can use cwd
div bx
nop

mov num, 4 ;reset num value

; write code to divide num by -5
mov ax, num
mov bx, -5
cwd			;convert word to double word
idiv bx


;;;;;; now for some real, rolling up your sleeves work
; implement this expression
; 5 - 2 + (8 / 3)
mov ax, 8
mov cx, 3
mov dx, 0
div cx

add ax, 5
sub ax, 2




;;;;;; part 3: flags
; FLAGS for add
; predict what the CF, OF, SF, ZF values are
; optionally you can run the program with the debugger and see if your predictions are correct

COMMENT !
FROM NOTES IN CLASS
CF for signed data, and OF for unsigned data tldr

unsigned:
    1111 1111   -> 255
   +0000 0001   -> 1
   ----------     ----
(1) 0000 0000       0

this one is a carry out and goes into the CF or carryout flag
and CF = 1. the result in the 8 bit register would be 0000 0000 but CL = 1

Therefore, CF = 1 means an invalid result. not from the program but something we need
to setup.


signed:
	1 <- carry into MSB column (Most significant bit)
	1111 1111  ->  -1
	0000 0001  ->  +1
   ----------     ----
 (1)0000 0000  ->   0
  ^
  |-------- carry out of MSB column

 signed vs unsigned data can change our result since signed is correct but unsigned is not

 Overflow flag OF is the XOR of the carry into MSB and
 the carry out of MSB. Therefore, 1 xor 1 = false, or 0
 Therefore, OF = 0
 OF = 1 means invalid result, therefore result is valid.

!


; next to each instruction that's an add or sub instruction,
; list the value of  CF, OF, SF, ZF
; the first step has been done for you

mov al,0f0h            
call DumpRegs
add al,0fh			; 1111 0000 + 0000 1111 = (0) 1111 1111
					; CF = 0, SF = 1, ZF = 0, OF = 0
					; no carryout, signed flag, zero flag, no carry in
call DumpRegs		
add al,0ffh			; CF = 1, SF = 1, ZF = 0, OF = 0
call DumpRegs


mov al,0ffh
call DumpRegs
add al, 80h			; CF = 1, SF = 0, ZF = 0, OF = 1
call DumpRegs
mov al,07fh
call DumpRegs
add al,1			; CF = 0, SF = 1, ZF = 0, OF = 1
call DumpRegs 


; CF flags for subtract
mov al,5
sub al,-1			; CF = 1, SF = 0, ZF = 0, OF = 0
call DumpRegs    

mov al,5
sub al,3			; CF = 0, SF = 0, ZF = 0, OF = 0
call DumpRegs      


exit
main ENDP

END main