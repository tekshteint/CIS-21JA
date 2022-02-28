TITLE  Lab 7: Calculate time difference with procedures
		
; Name: Tom Ekshtein, Oskar Castren
;ASK IF WE NEED EVERY SINGLE VARIABLE IN 8 BIT REGISTERS

INCLUDE Irvine32.inc

printStr MACRO strAddress
	push edx				
	mov edx, strAddress		
	call writeString
	pop edx

ENDM


.data
hrStr BYTE "Enter hour (0-23): ", 0
mnStr BYTE "Enter minute (0-59): ", 0
timeErrStr BYTE "Invalid input", 0ah, 0dh, 0

diffErrStr BYTE "Invalid time difference, check your times", 0ah, 0dh, 0

hrOutStr BYTE " hours, ", 0
mnOutStr BYTE " minutes", 0ah, 0dh, 0

timeArr BYTE ?, ?		; array of: start total minutes, end total minutes
diffHr BYTE ?			; time difference, hours portion
diffMin BYTE ?			; time difference, minutes portion

.code
main PROC
	
top :
	; 1. read time: pass arguments through *registers*
	;; call readTime proc and pass first 3 strings and timeArr
	mov esi, OFFSET hrStr
	mov ebx, OFFSET mnStr
	mov edi, OFFSET timeErrStr
	mov edx, OFFSET timeArr
	mov ecx, 2
	call readTime


	; 2. find difference: pass arguments through *the stack*
	;; call findDiff proc and pass timeArr, diffHr, diffMin
	push OFFSET timeArr
	call findDiff
	nop
	;pop eax
	cmp eax, 1
	je invalidDiff
	; 3. based on return value, either:
	; a) print result
	movzx eax, diffHr
	call writeDec
	;; write code to use macro to print hrOutStr
	printStr OFFSET hrOutStr
	movzx eax, diffMin
	call writeDec
	printStr OFFSET mnOutStr

	;; write code to use macro to print minOutStr


	jmp theEnd

	; or b) print error message
	invalidDiff :
	;; write code to use macro to print diffErrStr
	printStr OFFSET diffErrStr


	theEnd:
	;jmp top      ; create infinite loop for testing

	exit	
main ENDP


readTime PROC
readTop:
	printStr esi
	call ReadInt
	cmp eax, 0
	jl invalidTime
	cmp eax, 23
	jg invalidTime
	mov ah, al
	mov al, 60
	mul ah
	jc invalidTime
	mov ch, al

	printStr ebx
	call ReadInt
	cmp eax, 0
	jl invalidTime
	cmp eax, 59
	jg invalidTime
	add ch, al
	cmp cl, 1
	je saveSecond
	mov [edx], ch
	loop readTop

	invalidTime:
		printStr edi
		jmp readTop
		
	saveSecond:
		mov [edx+1], ch
		ret
		

readTime ENDP


findDiff PROC
push ebp
mov ebp, esp
mov eax, [ebp+8]
mov edx, [eax]
inc eax
mov ecx, [eax]
sub cl, dl
jc invalid
mov ah, 0
mov al, cl
mov cl, 60
div cl
mov diffMin, ah
mov diffHr, al
pop ebp
push 0
RET 

invalid:
;mov eax, 1
push 1
pop ebp

RET 
findDiff ENDP


END main