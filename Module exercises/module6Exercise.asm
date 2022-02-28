TITLE Module 6 Exercise						

INCLUDE Irvine32.inc

.data
bigData QWORD 123456781234567h

.code
main PROC

;;;;;;;;;;;;  part 1: bit-wise instructions ;;;;;;;;;;;;;
; predict what the code will do by answering
; the questions, then step through the code
; to check your answers

	mov al, 1010b
	and al, 1      ; al: 0 since we are comparing 0A hex to 1 dec which in binary is 1010 and 0001.
	;					Since non of those bits line up and match al is set to 00 hex.
	or al, 1       ; al: 01 since we are comparing 00 hex to 1 dec which is 0000 0000 and 0000 0001
	;					where only the LSB is 1. therefore our hex value would also be 01.
	xor al, 0fh    ; al: 0E since we are XOR'ing 01 to 0F. this means that in binary we would have 
	;					0000 1111 and 0000 0001. 1's LSB is the only 1 and the rest are 0's meaning that
	;					we would end up with 0000 1110.
	not al         ; al: Inverting al would result in 1111 0001 or F1 in hex.

	mov al, 1010b
	test al, 1000b   ; what are we testing for? testing if bit 3 in al is set
	jz L1			 ; will it jump? No, since we are testing with a jump zero jump and the bit is set.
	mov bl, 1
L1:
	xor al, al		 ; al: 0. using xor register,register zero's it out.

nextTest:
	mov al,1000b
	test al, 80h	; what are we testing for? 80h is 1000 0000 so we are testing if the MSB is not set.
	jnz L2			; will it jump? No
	not al			; al: F7
L2:



	mov al,2
	shl al,1		; al: 4
	sal al,2		; al: 16

	shr al,1		; al: 8


	mov al,0feh		
	shr al,1		; al: 7F
	mov al,0feh    
	sar al,1		; al: FF


	mov al, 0fh
	ror al,4		; al: F0
	rol al,4		; al: 0F

	mov al, 0f0h
	stc				; set cf
	rcr al, 4		; al: 1F
	mov al, 0f0h
	clc				; clear cf
	rcl al, 4;		; al: 07

	mov ax,1234h	
	mov bx,5678h
	shld ax,bx,4	; ax: 2345  bx: 5678
	shrd bx,ax,4	; ax: 2345	bx: 5567

	;;;;;;;;;;;;;;; part 2: solve these problems ;;;;;;;;;;;;

;Problem 1:

mov ax, 1234h
mov bx, 100h
mul bx				; result: 3400h
shl eax, 16
shr eax, 16
call writeDec



; call writeDec to print the result






;Problem 2:
; multiply bigData by 2, then store the result back in bigData
COMMENT ! MYWORD
mov eax, dword ptr bigData
mov ebx, dword ptr bigData+4
mov ecx, 2
mul ecx
mov ebp, edx
mov esi, eax
mov eax, ebx
mul ecx
add eax, ebp
!
; for a 64 big bigData, we break up into 2 parts: 32 upper, 32 lower
; we shift left the lower 32 bits first

;mov eax, DWORD PTR bigData
;shl eax, 1
;mov DWORD PTR bigData, eax
					;1		000 0001 0010 ... 
;bigData QWORD 1234567 81234567h

;instead do this which will shift directly from memory
shl DWORD PTR bigData, 1		; shifting left lower 32 bits, MSB is in CF
rcl DWORD PTR bigData +4, 1		; shifting left upper 32 bits, MSB is in CF



;Problem 3 - indirect addressing:
; multiply bigData by 2, then store the result back in bigData,
; but we only have the address of bigData in ebx

mov ebx, OFFSET bigData
; can't use the name bigData, we need to use ebx
shl WORD PTR [ebx], 1		; this shifts the data at the address which is in ebx
rcl DWORD PTR [ebx+4], 1	; this rotates the data at the address which is 4 more 
							; than the address in ebx
; Note:
; shl DWORD PTR ebx, 1		; this shifts left the address in ebx, to get to the data
							; we need to use [] to dereference the address
							



	exit
main ENDP

END main