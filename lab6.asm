TITLE  Assignment 6: Use bit wise instructions
		
; Name: 

INCLUDE Irvine32.inc

.data
zeroStr BYTE "EAX is 0", 0ah, 0dh, 0
divStr BYTE "Divisible by 4", 0ah, 0dh, 0
arr WORD 1, 0f02h, -2

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

	;method 1
    or eax, 0
	jnz Q2
	jmp Zero

	;method 2
	test eax, -1
	jnz Q2
	jmp Zero

	;method 3
	xor eax, 0
	jnz Q2
	jmp Zero

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

COMMENT !
a. (1pt) What does the code do to the letter in AL?     
   (Print the letter in AL to see, then change the letter to 'B', 'd', 'R', etc.)

   It converts the letter in Al to the opposite case. So an uppercase letter becomes a 
   lowercase letter and a lowercase letter becomes an uppercase one.

b. (2pts) Explain how the code works. Your answer should not be a description
   of what the instruction does, such as "the code takes the value in AL
   and does an XOR with the space character."

   When two opperands are compared using XOR the resulting comparison will contain a 0 in 
   any bit location where the bits being compared are the same and will contain a 1 in any location
   where the bits being compared are different. In ASCII the difference between an uppercase letter 
   and its lowercase compliment is +32. In binary the bit that has a value of 32 is the 5th bit
   (since bit location numbering starts from 0 the lsb). So, that is the bit that determines whether a
   a letter is upper or lowercase. Since the space value has all bits set to zero except the 5th bit, 
   performing an XOR opperation on the binary representation of a letter with the binary represenation of the space
   will flip the 5th bit of the letter opperand and leave all the rest the same. This affectivly switches the case.


!

; Question 3 (4 pts)
; Write code to check whether the number in AL is divisible by 4,
; jump to label DivBy4 if it is, or go to label Q4 if it's not.
; You should not have to use the DIV or IDIV instruction.
; Hint: write out the first few integers that are divisible by 4,
; and see if you can find a pattern with them.

    ;mov al, 10     ; change this value to test your code
	;test al, 00000011b
	;jz DivBy4
	;jmp Q4
	
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

	mov ebx, OFFSET arr     
	mov ebx, OFFSET [arr+2]
	mov eax, [ebx]
	Call writeint
	call crlf
	xor DWORD PTR [ebx+2], 0ff00ff00h
	mov eax, [ebx]
	Call writeint
	
	

	exit	
main ENDP

END main
