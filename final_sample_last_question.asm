TITLE MASM solution to last question of final sample						

INCLUDE Irvine32.inc

.data
str1 BYTE "assembly programming", 0
str2 BYTE "0123456789012345678901", 0
; change the 2 string lengths to test your code

.code
main PROC
	sub esp, 4				
	push OFFSET str1		
	push OFFSET str2
	call stringCopy

	; set breakpoint at exit line to see that str1 has been copied over or not
	; depending on the string lengths
	exit
main ENDP


stringCopy PROC
	push ebp
	mov ebp, esp
	pushad

	;;;; Step 1. find length of str1
	mov edi, [ebp+12]	; edi -> str1
	mov ecx, -1			; want ecx to hold a large value so we can hit the 0 termination,
						; and the largest value for ecx is FFFF FFFFh, or -1
	cld					; forward direction
	xor al, al			; al = 0 because we want to search for 0
	repne scasb 
	; when repne stops, 
	dec edi				; because edi has moved to the next location
						; after the decrement, edi = addr of 0 termination
	mov ebx, edi		; ebx = addr of 0 termination


	;;;; Step 2. find length of str2 (similar steps to find length of str1)
	mov edi, [ebp+8]	; edi -> str2
	mov ecx, -1			; want ecx to hold a large value so we can hit the 0 termination
	cld 
	xor al, al
	repne scasb 
	dec edi				; edi = addr of 0 termination
	
	;;;; at this point:
	;; ebx = addr of 0 termination of str1
	;; edi = addr of 0 termination of str2
	sub ebx, [ebp+12]		; ebx has num of elements of str1
	sub edi, [ebp+8]		; edi has num of elements of str2


	;;;; Step 3. compare the string lengths
	cmp ebx, edi
	ja  noCopy			; if length of str1 > length of str2, no copy


	;;;;; Step 4. copy
	mov esi, [ebp+12]
	mov edi, [ebp+8]
	cld
	mov ecx, ebx		; ecx = lengthof str1
	inc ecx             ; add 1 more to copy the 0 termination also
	rep movsb
	mov DWORD PTR [ebp+16], 1		; return 1 because we copied
	jmp theEnd

	noCopy:
	mov DWORD PTR [ebp+16], 0		; return 0 because we didn't copy
	
	theEnd:
	popad
	pop ebp
	ret 8
stringCopy ENDP

END main