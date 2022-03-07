TITLE midterm 2 review: sample questions

; Covers modules 5 (branching), 6 (bit-wise instruction / indirect addressing), 7 (procedures / macros)
; The following questions are in the same 2 types of questions you'll see in midterm 2:
; - questions to write code
; - questions to explain code or show results

INCLUDE Irvine32.inc

printStr MACRO str
	push eax
	push edx
	mov edx, OFFSET str
	mov al, '*'
	call writeChar
	call writeString
	call writeChar
	call crlf
	pop edx
	pop eax

ENDM


.data
errorStr BYTE "invalid result",0

var1 SBYTE 90
var2 SBYTE 10
var3 SBYTE -100
arr DWORD 1,2,3,4,5,6,7,8
var4 DWORD -1, -1

.code
main PROC
; The first 3 sample questions are to write code

; 1. write a macro that prints the errorStr (defined above)
; on a separate line of text, with a * character at the beginning and end of the string
printStr errorStr

; 2. write code that implements:
;   var3 = var1 * var2 - var3
; where the variables are defined in .data
;
; if any operation ends up with an invalid result, invoke the
; macro of question 1 
; var1, var2, var3 can contain any data value. You shouldn't rely 
; on the initialized data above when writing code to catch invalid result

mov al, var1
imul var2
jo invalid
sub al, var3
jo invalid
mov var3, al
jmp next

invalid:
	printStr errorStr

next:
; 3. write a procedure that accepts 2 input arguments: an array 
; of DWORDs and the number of elements. The procedure zeroes out all 
; the elements at each even index (index 0, 2, 4...)
;
; the procedure call is given here:
push OFFSET arr     
push LENGTHOF arr   
call proc1

exit
main ENDP

COMMENT !
stack:
offset arr
lengthof arr
ebp
ecx
ebx

!
proc1 PROC
	push ebp
	mov ebp, esp
	push ecx
	push ebx
	mov ecx, [ebp+8]
	mov ebx, [ebp+12]

	loopTop:
		mov DWORD PTR [ebx], 0
		add ebx, 8
		sub ecx, 2
		cmp ecx, 0
		jg loopTop

	pop ebx
	pop ecx
	pop ebp
	ret 8
proc1 ENDP
END main


COMMENT !

These sample questions are to read code

4. With the procedure call to proc1 of question 3, show a diagram
of the stack frame of proc1 at the point right after all the even indexed
elements have been zeroed out. 
For each value in the stack frame, you can either put the register 
name that holds the value (such as: eax), or describe what the value 
is (such as: return addr in main)
Make sure to list the values in the order that they appear in the stack,
and show where the stack top is

stack:
offset arr		address of arr[0]
lengthof arr	length of arr = 8
ebp				return address
ecx				counter for looping
ebx				used for adressing the array
TOP


5. Show the value of all registers that are changed after each
instruction

xor al, al			
or al, 82h			
shl al, 1			
jc L1				
and bl, 0
jz L2
L1: not al			
L2:


6. Using the same arr defined in main above, show the values in the array
after this code segment:
1,2,3,4,5,6,7,8

mov edx, OFFSET arr			address of arr[0]
add edx, LENGTHOF arr		arr[2]
add DWORD PTR [edx], 2		arr[2] = 3+2 = 5
sub edx, 4					arr[1]
add DWORD PTR [edx], 4		arr[1] = 2+4 = 6
1,6,5,4,5,6,7,8


7. Explain why you need to run:  mov ebp, esp     in a procedure that
accepts arguments through the stack

this way we can save the stack pointer in ebp and use it to reference what we have in the stack

Explain why you generally don't need to run:  mov ebp, esp   in a procedure that
acccepts arguments through registers

Since we aren't using the stack for inputs in a proc that uses registers for its arguments we don't need to reference anything in there.
!