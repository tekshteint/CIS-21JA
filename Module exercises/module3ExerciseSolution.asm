TITLE Module 3 Exercise Solution	

COMMENT !
 The following class exercise is for module 3
 Topics: Assembly Fundamentals and Library Calls

 1. Use the comment directive instead of ; for 
 the first 4 lines of comments

	Note that the beginning and ending token (the exclamation point here) must match
	and it must not appear inside the comment block
 !

; 2. Name the directives that you see in the code:
; TITLE, COMMENT, INCLUDE, .data, .code, PROC, ENDP, END
; these are all the directives that are originally in the file + the COMMENT directive
; of step 1


INCLUDE Irvine32.inc
; brings in the Irvine32 library which has IO routines that we'll use

; 3. define a constant for the number of seconds in an hour
; by using an integer expression constant
sPerh = 60 * 60
;;;;; a constant does not take up space in memory
;;;;; the constant name, sPerh, will get substituted out in the code
;;;;; and replaced with 3600 by the assembler


.data		; marks the data segment where variables are defined

; 4. define a prompt: enter your name
myPrompt BYTE "enter your name: ",0
	; null termination is needed because we use the Irvine32 IO functions,
	; the null termination is not needed by assembly language

; 5. define memory space to store someone's name (20 characters for name)
uname BYTE 21 DUP(?)			; 21 uninitialized bytes, 1 extra byte for null termination

hi BYTE "Hi, ",0	; Hi string to print out

; 6. define a byte and initialize with binary 100
myByte BYTE 100b

; 7. define a word and initialize with hexadecimal A0 
myWord WORD 0A0h		; need 0 in front because value starts with letter

; 8. define a doubleword and initialize with -10
myDword SDWORD -10		; -10d  is also ok
						; SDWORD to say that the data is signed data
						; but it's not required
									
; 9. define an array of 5 doublewords and initialize with the values 1,2,3
; and leaving the last 2 elements uninitialized
myArr DWORD 1, 2, 3, ?, ?


.code       ; marks the code segment where instructions are 
main PROC   ; this program has 1 procedure (or function or method)
			; and it's called main here
			; PROC is the start of the main block

; 10. write code to print the prompt
mov edx, OFFSET myPrompt		; address of myPrompt goes into edx because we can't
								; store the entire string into edx
call writeString

; 11. write code to read in the user's name

mov ecx, 20						; readString will read in up to 19 chars and append 0 at the end
mov edx, OFFSET uname
call readString
nop

; 12. write code to print "Hi, <user's name>" where user's name is what you read in
mov edx, OFFSET hi				; print hi string
call writeString
mov edx, OFFSET uName			; print uName string
call writeString
call crlf

; 13. write code to store the immediate value -1 in eax
mov eax, -1

; 14. write code to print the word defined in step 7
mov eax, 0					; clear out eax first, because we will only have enough data to fill the lower half
mov ax, myWord				; need to store myWord in ax, so the sizes are the same (both are 16 bits)
call writeDec				; since the data is defined as WORD, we'll use unsigned print
call crlf

; 15. write code to print the doubleword defined in step 8
mov eax, myDword			; an integer will fit in eax, so no need to pass the address of myDword
							; so don't use:  mov eax, OFFSET myDword
call writeInt				; use writeInt because myDword is -10 which is signed data

;call writeDec				; when we use writeDec to print signed data
							; we get a huge positive number
call crlf

; 16. use the debugger's memory window and identify what your data
; definitions look like in mememory

; 1. build the program and produce the executable
; 2. set a breakpoint at the first line of code in the program
; 3. Debug -> Start Debugging
; 4. Windows -> Memory -> Memory1
; 5. At the memory window address line, type: &myPrompt   (or the name of your first variable)
; The memory window should show all your variables, one after another

; Here's what the all data definitions look like on my computer:
COMMENT !

addresses     data values                        char equivalence
                                                 of data values on left

0x00405000  45 6e 74 65 72 20 79 6f 75 72 20 6e  Enter your n
0x0040500C  61 6d 65 3a 20 00 61 00 0a 00 00 00  ame: .a.....
0x00405018  00 00 00 00 00 00 00 00 00 00 00 00  ............
0x00405024  00 00 00 48 69 2c 20 00 04 a0 00 f6  ...Hi, .. .ö
0x00405030  ff ff ff 01 00 00 00 02 00 00 00 03  ÿÿÿ.........
0x0040503C  00 00 00 00 00 00 00 00 00 00 00

- the prompt starts at address 00405000 (the address might be different on yours),
  with data values starting with 45 6e, ending with 20 00
- the name I entered is 'a', so the name string starts
  at address 00405012 with data values starting with 61 00, 
  ending with 00, at address 00405026
- the Hi string starts at address 00405027 with data
  values: 48 69 2c 20 00
- the byte variable is at address 0040502C with value: 04
- the word variable is at address 0040502D with value: a0 00
- the dword variable is at address 0040502F with value: f6 ff ff ff
- the arrData is at address 00405033 (or at arrData[0]) with value 01 00 00 00 as
  the first element, at address 00405037 (or at arrData[4]) with value 02 00 00 00
  as the second element, and so on
!



; 17. show what the array of 5 doublewords look like. 
; Why does it look like that?

; The array is:  01 00 00 00 02 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00
; - Each data value or each element takes up 4 bytes (a dword)
; - The bytes of each element are in little endian order (lowest byte at lowest address)
; - Therefore the doubleword value 1 (first element) looks like: 01 00 00 00
; - The uninitialized values (the last 8 bytes) could be anything, they happen to be 0



	exit	
main ENDP		; marks the end of the main block

END main		; marks end of program and dictates what the starting procedure is
