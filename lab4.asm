TITLE  Lab 4: Calculate the number of coins, and predict flag values
		
; Name: Nicole Parziale


INCLUDE Irvine32.inc

; Part 1 (10pts)

.data
	change  byte "Change is ", 0
	cents byte " cents", 0DH, 0Ah, 0
	quarter  byte " quarters, ", 0
	dime byte " dimes, ", 0
	nickle byte " nickles, ", 0
	penny byte " pennies ", 0
	MAX word 99

.code
main PROC
	call randomize			; create a seed for the random number generator
	movzx eax, MAX    			; set upper limit for random number to 9
	call randomRange		; random number is returned in eax, and is 0-9 inclusive
	mov edx, OFFSET change  
	call writeString        ; 26-30 print "Change is (___) cents" to the console
	call writeDec
	mov edx, OFFSET cents	
	call writeString

	mov bl, 25              
	div bl 
	mov bh, ah
	movzx eax, al               ; 32-38 divide change amount by 25 and print quotient -
	call writeDec               ; value to the screen with coin name. -
	mov edx, OFFSET quarter     ; remainder is stored in bh for use in next step.
	call writeString
 
    movzx eax, bh
 	mov bl, 10              
	div bl 
	mov bh, ah                  ; 40-47 same process as previous block but for 10 (dimes)
	movzx eax, al
	call writeDec
	mov edx, OFFSET dime
	call writeString
    
    movzx eax, bh
 	mov bl, 10              
	div bl 
	mov bh, ah                 ; 49-56  5 (nickles)
	movzx eax, al
	call writeDec
	mov edx, OFFSET nickle
	call writeString

    movzx eax, bh
	call writeDec             ; 58-61 same for 1 (pennies) except no need to store results
	mov edx, OFFSET penny
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

; a. ZF = 0  SF =1  CF = 0  OF = 1
; b. explanation for CF:  70h in binary is 0111 0000  30h in binary is 0011 0000
;       when added together the result is 1010 0000. There no CF because the result of the addition 
;       fits into the word data size without any extra bits needing to be carried over.
;    
;    explanation for OF: The overflow flag is set because even though there was no carry over the ALU doesn't know whether the 
;       binary values are signed or unsigned. Since the MSB for both of the input values are positive
;       but the result has a 1 in the MSB (meaning possibly negative) the OF is set to indicate that 
;       we could be dealing with a negative result 

sub al, 070h     

; a. ZF = 0  SF = 0  CF = 0   OF = 1 
; b. explanation for CF:  from above the value of al before the sub process was 1010 0000. Since the ALU does subtraction
;       by adding the 2's complement + 1, 070h in we add 1001 0000 to the value above stored in al and get
;       0011 0000 or 30h in hex.In the computation of this result the last "borrow" performed is ignored since 
;       this was a situation where a>b for a-b.   
;                          
;    explanation for OF: Since the ALU doesn't know whether the inputs are signed or unsigned in a situation where the 
;       2's complement addition (subtraction) of two numbers results in an overflow bit && the MSB of the inputs is 
;       different than the MSB of the result then the OF flag is set. Since the MSB of a and b in this case were both 1 
;       the resulting most significant bit is 0 and there is a 1 overflow bit. Because the program may utilized signed values
;       this lets the programmed know that in the event of signed inputs this result would be wrong (adding two negatives 
;       cannot yield a positive)


!