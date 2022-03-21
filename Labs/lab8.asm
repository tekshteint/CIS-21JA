TITLE  Lab 8: Find letters in 2D array of strings
		
; Name: Tom Ekshtein


INCLUDE Irvine32.inc

ROWS = 3
COLS = 11

printStr MACRO addr
	push edx
	mov edx, addr
	call writeString
	pop edx
ENDM


.data
myArr BYTE COLS*ROWS dup(?)
promptStr BYTE "Please enter your string", 0
targetLtr BYTE "Enter a target letter: ", 0
totalStr BYTE "Total count: ", 0

.code
main PROC
	
; 1. call fill array, pass arguments through *registers*
mov ecx, COLS
mov ebx, OFFSET promptStr
mov edx, OFFSET myArr
mov edi, ROWS
mov esi, 0

call fillArr				


; 2. check return value and end the program if return value is 0
cmp esi, 0
je finished

; 3. loop to call findCount, pass arguments through *the stack*
; esi contains number of strings and is passed through the stack
call crlf
sub esp, 4
push OFFSET targetLtr
push OFFSET myArr
call findCount

pop eax
call crlf
mov edx, OFFSET totalStr
printStr edx
call writeDec

finished:
	exit	
main ENDP


fillArr PROC
	
	loopTop:
		printSTR ebx
		call crlf
		call readString
		cmp eax, 0
		je done
		inc esi
		add edx, ecx
		dec edi
		cmp edi, 1
		jge loopTop

	done:
		call crlf
		push OFFSET myArr
		call printArr
		ret

fillArr ENDP


printArr PROC
	pushad
	push ebp
	mov ebp, esp
	mov ebx, [ebp+8]	;num of strings
	cmp ebx, 0
	je done
	mov esi, [ebp+40]	;myArr
	cld

	loopTop:
		dec ebx
		printStr esi
		add esi, COLS
		call crlf
		cmp ebx, 1
		jge loopTop

	done:
		pop ebp
		popad
		ret 4
	
printArr ENDP

findCount PROC
	push ebp
	mov ebp, esp
	mov ebx, 0
	pushad	
	mov edx, [ebp+12]	;targetStr
	call writeString
	call readChar
	call writeChar
	mov bl, al
	mov eax, COLS
	mov ecx, esi
	mul ecx
	mov ecx, eax
	mov al, bl
	mov ebx, 0
	cld
	mov edi, [ebp+8]	;myArr
	loopTop:
		repne scasb
		jnz notFound
		
	found:
		inc ebx
		jmp loopTop

	notFound:
		mov [ebp+16], ebx
		popad
		pop ebp
		ret 8




findCount ENDP

END main