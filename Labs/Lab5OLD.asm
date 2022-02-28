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
		cmp ebx, 0
		jl small
	
	minInput:
		mov edx, OFFSET getMins
		call WriteString
		call ReadInt
		cmp eax, 59
		jg large
		cmp eax, 0
		jl small

	validate:
		mov bh, bl
		mov bl, al
		mov al, 60
		mul bh
		cmp ax, 0FFh
		jg large
		mov bh, 0
		add ax, bx
		cmp ax, 0FFh
		jg large
		cmp ecx, 1
		je cmpEnd

	storeStart:
		mov esi, eax
		loop loopStart

	cmpEnd:
		cmp esi, eax
		jg invalidDiff
		
		sub eax, esi
		mov edx, 0
		mov ecx, 60
		div ecx
		mov ebx, edx

		call WriteDec
		mov edx, OFFSET hourStr
		call WriteString
		mov eax, ebx
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

		mov dh, 'Y'
		mov dl, 'y'
		mov bh, 'N'
		mov bl, 'n'
		cmp al, dl
		je loopStart
		cmp al, dh
		je loopStart

		cmp al, bh
		je finish
		cmp al, bl
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