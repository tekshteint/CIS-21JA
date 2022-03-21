TITLE final review

COMMENT !
Example 1: Write code to implement the following loop. All variables are unsigned bytes. Catch all possible errors with jumps to error label E1.
	while (var1 > var2)
		var2 = var2 * 5

Example 2:  The following question is longer than the typical exam question. 
It could be 3 different exam questions, to give you more practice, and in the 
real exam you would only need to do one part of this question.

Write a procedure to copy str1 to str2. Both strings are text strings that are null terminated. 
The procedure returns 1 if all of str1 can be copied to str2, and returns 0 if str1 cannot be copied 
to str2 because str2 is smaller in size. Use string instructions as needed.

The procedure call is
sub esp, 4			; for return value of 1 or 0
push OFFSET str1
push OFFSET str2
call stringCopy	


!


INCLUDE Irvine32.inc



.data
var1 byte 50
var2 byte 10

firstStr byte "this is the first string", 0
secondStr byte "This is the second string. This one will be much bigger to test", 0
smallStr byte "small string", 0

.code

main PROC
mov al, var2
mov bl, 5
loopTop:
	cmp var1, al
	jbe E1
	mul bl
	jc E1
	jmp loopTop
	
endLoop:
	mov var2, al

E1:
	;do something

sub esp, 4			; for return value of 1 or 0
push OFFSET firstStr
push OFFSET secondStr
call stringCopy	



exit
main ENDP
COMMENT !
stack:
return			16
firststr		12
secondstr		8
ebp				4


!


stringCopy PROC
	push ebp
	mov ebp, esp
	pushad


	mov edi, [ebp+12]
	mov ecx, -1

	cld
	xor al, al
	repne scasb

	dec edi
	
	mov ebx, edi

	mov edi, [ebp+8]
	mov ecx, -1
	cld
	xor al, al
	repne scasb
	dec edi

	sub ebx, [ebp+12]
	sub edi, [ebp+8]

	cmp ebx, edi
	ja noCopy

	mov esi, [ebp+12]
	mov edi, [ebp+8]
	cld
	mov ecx, ebx	;lengthof firstStr
	inc ecx			; for 0 termination
	rep movsb
	mov DWORD PTR [ebp+16], 1
	jmp done



	noCopy:
		mov DWORD PTR [ebp+16], 0

	done:
		popad
		pop ebp
		ret 8


stringCopy ENDP

END main

