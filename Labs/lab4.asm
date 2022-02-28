TITLE  Lab 4: Calculate the number of coins, and predict flag values
		
; Don't forget this beginning documentation with your name
; Name: Tom Ekshtein


INCLUDE Irvine32.inc

; Part 1 (10pts)

MAX = 99

.data
changeStr BYTE "Change is: ",0
; 0ah, 0dh is for \n to save the need for calling crlf
centStr BYTE " cents", 0ah, 0dh, 0
qStr BYTE " quarters, ", 0
dStr BYTE " dimes, ", 0
nStr BYTE " nickels, ", 0
pStr BYTE " pennies", 0, 0ah, 0dh, 0

.code
main PROC
	;print total change
	mov edx, OFFSET changeStr
	call writeString
	
	call randomize			; create a seed for the random number generator
	mov eax, MAX   			; set upper limit for random number to MAX
	call randomRange		; random number is returned in eax, and is 0-99 inclusive
	call writeDec			; print to check random number
	call crlf

	mov ah, 0				; zeroing out remainder reg
	mov bh, 25				; moving 25 cents to bh for division
	div bh					; dividing the change by 25 cents for number of quarters
	mov bl, ah				; using bl as our remainder storage register, we move the value of ah to store for the next operation
	;could've been done with movzx eax, al if I used the al and not ah register
	mov ah,0				; zeroing out ah to store the correct amount of coins
	call writeDec			; since the amount of quarters is stored in al, we can just call writeDec
	mov edx, OFFSET qStr	; preparing to print out string for quarters
	call writeString


	mov ax, bx				; moving bx into ax since bl is our remainder
	mov bx, 10				; moving 10 cents to bx for division
	mov ah, 0				; zeroing out ah
	div bl					; division to find amount of dimes
	mov bl, ah				; storing our remainder
	mov ah, 0				; zeroing out remainder in ah so we don't print garbage data
	call writeDec			; dimes are in al so we can call writeDec like before
	mov edx, OFFSET dStr	; preparing to print out dime string 
	call writeString


	mov ax, bx				; moving remainder like last time
	mov bx, 5				; moving 5 cents to bx for division
	mov ah, 0				; zeroing out remainder 
	div bl					; division to find amount of nickles
	mov bl, ah				; storing remainder again
	mov ah, 0				; zeroing out previous remainder again
	call writeDec			; nickels are in al so we can call writeDec like before
	mov edx, OFFSET nStr	; preparing to print nickel string
	call writeString
	mov ax, bx				; moving pennies from bl to ax in order to call writeDec
	call writeDec
	mov edx, OFFSET pStr	; preparing to print penny string
	call writeString


	exit	
main ENDP

END main


COMMENT !
Part 2 (5pts)
Assume ZF, SF, CF, OF are all 0 at the start, and the 3 instructions below run one after another. 
a. fill in the value of all 4 flags after each instruction runs 
b. show your work to explain why CF and OF flags have those values
   Your explanation should not refer to signed or unsigned data values, 
   such as "the result will be out of range" or "204 is larger than a byte"
   or "adding 2 negatives can't result in a positive"
   Instead, show your work in the same way as in the exercise 4 solution.

   	mov al, 70h 

	add al, 30h 
	adding 70h and 30h would result in 

	    111
		0111 0000
	   +0011 0000
	 ------------
	    1010 0000   
	
	; a. ZF =0   SF =1  CF =0   OF = 1
	; b. explanation for CF: Since there are no 1's being carried out of the problem, the carry flag is off.
	;    explanation for OF: Since both numbers have the signed bit turned off and the sum
	;	 gave us a number with the signed bit on, the OF flag is set

	; b. claire's explanation: Carry out is 0 xor carr in is 1
	

	sub al, 070h     

						70h =	0111 0000
	2's complement is: Reverse: 1000 1111
							   +0000 0001
							    ----------
						2's:	1001 0000
	
	and al has a value of 1010 0000
	This means that our new operation is:
				1010 0000		(previous al value)
			   +1001 0000		(2's complement)
			   -----------
			 (1)0011 0000


	; a. ZF = 0  SF = 0  CF = 0   OF = 1 
	; b. explanation for CF: Although there is a carry out, it is ignored because of the fact that we are "subtracting". 
	;						 Therefore the flag is not set.
							claire:  carry out is 1 and is reveresed
							
	;    explanation for OF: The OF can be set when adding 2 numbers of the same sign gives us a number of opposite sign.
	;						 In this case, we are adding 2 negative numbers and getting a positive number the OF is set.
							claire: carry out is 1 xor carry in is 0


!