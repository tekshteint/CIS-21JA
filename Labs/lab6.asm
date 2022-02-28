TITLE  Assignment 6: Use bit wise instructions
		
; Name: Tom Ekshtein

INCLUDE Irvine32.inc

.data
zeroStr BYTE "EAX is 0", 0ah, 0dh, 0
divStr BYTE "Divisible by 4", 0ah, 0dh, 0
arr WORD 1, 0f02h, -2
array WORD 5 dup (3)

.code
main PROC
; Question 1 (3pts)
; In the space below, write code in 3 different ways (use 3 different instructions)
; to check whether EAX is 0, and jump to label Zero if it is, otherwise jump to Q2.
; To solve this problem you:
; - cannot use the CMP instruction or arithmetic instruction (ADD, SUB, DIV, etc.)
; - cannot change the EAX value or copy the EAX value to another register

	mov eax, 0		; change this value to test your code
	; make sure you have 3 different ways using 3 different instructions,
	; only one will run at a time
	
	;FIRST WAY
	;and eax, 0
	;jz Zero		; Works!

	;SECOND WAY
	;or eax, 1
	;jnz Zero		; Works!

	;THIRD WAY
	;xor eax, 0
	;jnz Zero		; Works!

	jmp Q2



	Zero :
		mov edx, OFFSET zeroStr
		call writeString
		call crlf

	Q2:
; Question 2
; You can use the following code to impress your friends, 
; but first you need to figure out how it works.

	mov al, 'A'	    ; al can contain any letter of the alphabet
	xor al, ' '	    ; the second operand is a space character
	call WriteChar

COMMENT !
a. (1pt) What does the code do to the letter in AL?     
   (Print the letter in AL to see, then change the letter to 'B', 'd', 'R', etc.)
   
   This code will do an XOR comparison between the hex value of the character A ascii value
   (41) with the hex value of a space in ascii (20) which results to the following in binary:

    0100 0001
XOR 0010 0000
---------------
	0110 0001	which is 61 in hex. Converting that hex value to an ascii value gives us
	the char: a. Testing for other characters we can confirm our hypothesis that this code
	takes a character and converts it between uppercase and lowercase.

b. (2pts) Explain how the code works. Your answer should not be a description
   of what the instruction does, such as "the code takes the value in AL
   and does an XOR with the space character."

   XOR is the exclusive or operator, looking at it from a logic standpoint we can
   form the follwing truth table where 1 = true and 0 = false:

   p | q | XOR 
  -------------
   0 | 0 |  F
   0 | 1 |  T
   1 | 0 |  T
   1 | 1 |  F
   
   The program checks each bit and performs the comparison shown above. Afterwards it stores
   the resulting bits in the same destination that the comparison was made in. Any hex value >= 41
   and <=5A as well as >=61 and <=7A is a letter in ascii. The first group are all uppercase and when you
   XOR that hex value it will effectively add 20 to give us a lowercase letter. The reverse is true for the 
   lowercase letters.

!

; Question 3 (4 pts)
; Write code to check whether the number in AL is divisible by 4,
; jump to label DivBy4 if it is, or go to label Q4 if it's not.
; You should not have to use the DIV or IDIV instruction.
; Hint: write out the first few integers that are divisible by 4,
; and see if you can find a pattern with them.

    mov al, 10     ; change this value to test your code
	clc			   ; clears carry flag
	shr al, 2	   ; shifting right divides the source by 2^n where n is the amount shifted. so 2^2=4
	jnc DivBy4	   ; if the carry flag is set, then al is not divisible by 4.
	jmp Q4



	DivBy4:
		mov edx, OFFSET divStr
		call writeString
		call crlf


	Q4:
; Question 4 (5 pts)
; Given an array arr of 3 WORD size data, as defined in .data above, 
; and ebx is initialized as shown below.
; Using ebx (not the array name), write ONE instruction (one line of code)
; to reverse the bits in the most significant byte (high byte) of 
; the last 2 elements of arr.  
; Reverse means turn 0 to 1 or 1 to 0.  
; Your code should work with all values in arr, not just the sample data in arr


	;arr WORD 1, 0f02h, -2

	mov ebx, OFFSET arr
	xor DWORD ptr [ebx + 2], 80008000h
	


	exit	
main ENDP

END main
