TITLE midterm 2 review: sample questions

; Covers modules 5 (branching), 6 (bit-wise instruction / indirect addressing), 7 (procedures / macros)
; The following questions are in the same 2 types of questions you'll see in midterm 2:
; - questions to write code
; - questions to explain code or show results

INCLUDE Irvine32.inc

printErr MACRO errStr
	push edx
	push eax
	and eax, eax
	mov al, '*'
	call writeChar
	mov edx, OFFSET errStr 
	call writeString
	call writeChar
	call crlf
	pop eax
	pop edx
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
printErr errorStr



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
jo invalidResult
sub al, var3
jno okay

invalidResult:
	printErr errorStr
	jmp nextQ

okay:
	mov var3, al


COMMENT ! my work
mov al, var1
mov ah, var2
mul ah
jc invalidOperation
mov bl, var3
sub al, bl
jo invalidOperation
mov ebx, OFFSET var3
mov [ebx], eax

invalidOperation:
	printErr errorStr
!

nextQ:
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


;stack:
;OFFSET arr
;Lengthof arr
;ebp
;ecx
;ebx
;eax

proc1 PROC
push ebp
mov ebp, esp
push ecx
push ebx
push eax
mov ecx, [ebp+8]

mainLoop:
	movzx ax, cl
	mov ch, 2
	div ch
	cmp ah, 1
	je zeroIndex

notZero:
	loop mainLoop

zeroIndex:
	mov ch, 0
	mov ebx, [ebp+12]
	mov eax, 4
	mul ecx
	add ebx, eax
	sub ebx, 4
	mov al, 0
	mov [ebx], al
	loop mainLoop
	pop eax
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

Bottom:
OFFSET arr: Array address
Lengthof arr: 8
ebp: return address
ecx
ebx
eax



5. Show the value of all registers that are changed after each
instruction

xor al, al		0000 0000	
or al, 82h		1000 0010	
shl al, 1		0000 0100 CF: 1	
jc L1			jump	
and bl, 0		doesn't run
jz L2			doesn't run
L1: not al		1111 1011	
L2:


6. Using the same arr defined in main above, show the values in the array
after this code segment:

mov edx, OFFSET arr			addr of arr
add edx, LENGTHOF arr		adding 8 to the address, so we are at arr[2]
add DWORD PTR [edx], 2		since we are adding 2, arr[2]=3, 3+2=5
sub edx, 4					edx-=4, meaning that we are at arr[1]
add DWORD PTR [edx], 4		arr[1]=2, 2+4=6
01 00 00 00 06 00 00 00 05 00 00 00 04...

7. Explain why you need to run:  mov ebp, esp     in a procedure that
accepts arguments through the stack
in order to save the value of the stack pointer, we move it into ebp to be able to return to it later at the end of the proc

Answer: ebp gets the current esp value at the start of the procedure.
This means ebp has the address which is 1 slot away from the input arguments on the
stack
and allows us to use ebp+8, ebp+12, ebp+16, ...  to access the input arguments

Explain why you generally don't need to run:  mov ebp, esp   in a procedure that
acccepts arguments through registers
since we aren't messing with the stack and pushing/popping, we don't need to save the stack pointer since it won't change and our return value won't either.

Answer: there is no need to set ebp because it will not be used to access input
arguments on the stack. All input arguments are in registers

!