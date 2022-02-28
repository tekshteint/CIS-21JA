TITLE  Lab 5: Calculate time difference
		
; Name: Tom Ekshtein


INCLUDE Irvine32.inc


.data
getHour BYTE "Enter Hour: ", 0
getMins BYTE "Enter Minute: ", 0
largeTime BYTE "The time entered is too large", 0ah, 0dh, 0
smallTime BYTE "The time entered is too small", 0ah, 0dh, 0
checkTime BYTE "Invalid time difference, check your times", 0ah, 0dh, 0
hourStr BYTE " hours, ", 0
minStr BYTE " minutes", 0ah, 0dh, 0
continueStr BYTE "Continue? y/n: ", 0


.code
main PROC

mov ecx, 2
loopStart:

	hourInput:
		mov edx, OFFSET getHour
		call WriteString
		call ReadInt
		mov ebx, eax
		cmp ebx, 23
		jg large
		cmp bl, 0
		jl small
	
	minInput:
		mov edx, OFFSET getMins
		call WriteString
		call ReadInt
		mov bh, al
		cmp bh, 59
		jg large
		cmp bh, 0
		jl small

	validate: ;bl is hours and bh is minutes
		mov al, 60
		mul bl
		jc large
		add al, bh
		jc large
		cmp cl, 1
		je cmpEnd

	storeStart:
		mov ch, al
		loop loopStart

	cmpEnd:
		sub al, ch
		jc invalidDiff

		mov dl, 0
		mov cl, 60
		div cl
		movzx ebx, ax
		mov ah, 0

		call WriteDec
		mov edx, OFFSET hourStr
		call WriteString
		mov al, bh
		call WriteDec
		mov edx, OFFSET minStr
		call WriteString

	continue:
		mov ecx, 2
		mov edx, OFFSET continueStr
		call WriteString
		call readChar
		mov edx, eax
		call WriteChar
		call crlf

		cmp al, 'Y'
		je loopStart
		cmp al, 'y'
		je loopStart
		cmp al, 'N'
		je finish
		cmp al, 'n'
		je finish

		jmp continue

	large:
		mov edx, OFFSET largeTime
		call WriteString
		jmp loopStart

	small:
		mov edx, OFFSET smallTime
		call WriteString
		jmp loopStart

	invalidDiff:
		mov edx, OFFSET checkTime
		call WriteString
		jmp continue



finish:
	exit	
main ENDP

END main