TITLE Module8Exercise						

INCLUDE Irvine32.inc


space macro ; macro to print a single space
push eax
mov eax,' '
call writeChar
pop eax
endm

numrow = 3
numcol = 5

.data
arr WORD 1,2,3,3,4,4,5,6,2,2,2,7,5,5,5
uniq WORD 15 dup(0)

twoD WORD 0,1,2,3,4
     WORD 10,11,12,13,14
     WORD 20,21,22,23,24

;or	 
;twoD WORD 0,1,2,3,4,10,11,12,13,14,20,21,22,23,24

.code

main PROC
; part 1: copy arr into uniq, print uniq to check
cld
mov ecx, lengthof arr
mov esi, OFFSET arr
mov edi, OFFSET uniq
rep movsw

mov esi, OFFSET uniq
mov ecx, lengthof uniq
printLoop:
    lodsw
    or ax, 30h
    call writeChar
    space
    loop printLoop
nop

; part 2: zero out uniq
mov ax, 0
mov edi, OFFSET uniq
mov ecx, lengthof uniq
cld
rep stosw

nop


; part 3: copy arr into uniq, but don't copy consecutive 
; duplicate numbers
mov ecx, lengthof arr
dec ecx
mov esi, OFFSET arr
mov edi, OFFSET uniq
mov ax, [esi]
stosw
add esi, 2
;inc edi
loopTop:
    mov ax, [esi]
    cmp [esi-2], ax
    jne append
    add esi, 2
    loop loopTop
    jmp done

append:
    dec ecx
    stosw
    add esi, 2
    ;add edi, 2
    cmp ecx, 0
    jg loopTop

done:
    nop


; part 4: implement: ax = twoD[2][3] 

mov ebx, OFFSET twoD
mov edi, 6                  ;3*2 since we are working with words
add ebx, numCol * 4         ;2*2 for the same reason as above
mov ax, [ebx+edi]


; part 5: implement: ax = twoD[1][2] 
;          by using ebx
mov ebx, OFFSET twoD
mov edi, 4
add ebx, numCol * 2
mov ax, [ebx+edi]
nop

exit
main ENDP

END main