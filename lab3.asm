TITLE Lab3 3				

;;;;; Q1: Don't forget to document your program 			
; Name: Tom Ekshtein
; Date: 01/21/22

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Answer each question below by writing code at the APPROPRIATE places in the file
;;;;; Putting your answer immediately after the question is not necessarily the correct place

;;;;; Q2: Write the directive to bring in the IO library			
INCLUDE Irvine32.inc
;;;;; Q3: Create a constant called SECS_PER_MIN and initialize it to 60
		;done
		; put constants before .data and after include library
;;;;; Q4: Create a constant called SECS_PER_DAY by using SECS_PER_MIN (of Q3) in an integer expression constant
		;done
;;;;; Q5: Define an array of 25 signed doublewords, use any array name you like. Initialize:
;;;;;	- the 1st element to 10 
;;;;;	- the 2nd element to the hexadecimal value C2
;;;;;	- the 3rd element to the binary value 10101 
;;;;;	- the 4th element to the SECS_PER_MIN constant defined in Q3
;;;;; and leave the rest of the array uninitialized.  
		;done
;;;;; Q6. Define the string "Output is ", use any variable name you like.
		;done
;;;;; Q7. Define a prompt that asks the user for a negative number
		;done
;;;;; Q8. Write code to print to screen the value of eax after SECS_PER_DAY is stored in eax (first line of code below)
;;;;;     Use the string you defined in Q6 as the text explanation for your output
		;done
;;;;; Q9. Write code to prompt the user for a negative number, using the prompt string that you defined in Q7
		;done
;;;;; Q10. Write code to read in the user input, which is guaranteed to be a negative number
		;done
;;;;; Q11. Write code to print "Output is " and then echo to screen the user input number
		;done
;;;;; Q12. Write code to print "Output is " and then print the first element of the array defined in Q5
;;;;;      The output should not contain a + or - sign
		;done
;;;;; Q13. Build, run, and debug your code
;;;;; Your output should be similar to this (without the commented explanation)
		;done
;;;;; Output is 86400						    ; printing SECS_PER_DAY
;;;;; Enter a negative number: -2
;;;;; Output is -2								; echo user input number
;;;;; Output is 10 								; print first element of array
;;;;; Press any key to continue . . .

;;;;; Q14. At the end of the source file, without using semicolons (;), add a comment block
;;;;;      to show how bigData appears in memory (should be the same 8 hexadecimal values as in lab 2), 
;;;;;      and explain why the data in memory looks different than the initialized value 
		;done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.data
bigData QWORD 1234567890abcdefh					; same bigData value as lab 2

SECS_PER_MIN = 60
SECS_PER_DAY = 1440*SECS_PER_MIN

myArr DWORD 10,0C2h,10101b,SECS_PER_MIN, 21 DUP(?)
;text string is ALWAYS byte
myOutput BYTE "Output is ",0
myPrompt BYTE "please enter a negative number: ",0




.code
main PROC
	mov eax, SECS_PER_DAY						; eax = HRS_PER_YEAR value
	mov edx, OFFSET myOutput
	call writeString
	call writeDec
	call crlf

	mov edx, OFFSET myPrompt
	;mov eax, 0		;DON'T NEED TO ZERO OUT EAX
	call writeString
	call readInt	;readInt will always store in EAX
	
	mov edx, OFFSET myOutput
	call writeString
	call writeInt

	call crlf
	call writeString
	mov eax, myArr[0]	;mov eax, myArr would also get first value of array
	call writeDec


	exit	
main ENDP

END main

COMMENT !

ef cd ab 90 78 56 34 12

;bigData is a hex value bc of h at the end
;INCORRECT EXPLANATION The value of bigData in memory looks different since we are looking at it in hex and not decimals.

from claire corrections:
the initialized value is not decimal, either. It's a hexadecimal value just like the memory content, but in reverse byte order due to little endian

!