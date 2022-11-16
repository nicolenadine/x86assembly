TITLE Lab 7: Working with Procedures and Macros: Convert user decimal input into Hexidecimal

; Name: Nicole Parziale 

INCLUDE Irvine32.inc

MAX_INT = 65535    ;maximum int size for a 16 bit word

printStr MACRO addr
	push edx
	mov edx, addr
	call writeString
	call crlf
	pop edx
ENDM

.data

inputPrompt BYTE "Enter a number: ", 0
invalidSign BYTE "Must be positive", 0
invalidSize BYTE "Number must be less than 65536", 0
promptCont BYTE "Would you like to continue? ", 0
charArr BYTE 4 dup('0'),'h',0 

.code
main PROC

top:
mov edx, OFFSET inputprompt
mov ebx, OFFSET invalidSize
mov ecx, OFFSET invalidSign
call readInput                ;input will be stored in eax after call returns

push eax
push OFFSET charArr
call convert
printStr OFFSET charArr

printStr OFFSET promptCont
call readChar
call writeChar
call crlf    
or al, 00010000b   ;make sure char is lowercase by setting 5th bit 
cmp al,'y'
je top        
 
exit
main ENDP

readInput PROC
	;edx = prompt string
	;ebx = addr of invalidSize
	;ecx = addr of invalidSign

getInput:
  printStr edx          ;prompt user
  call readInt
	  
  checkInput: 
  cmp eax, 0            ;check if input is negative  
  jl notPositive 
  cmp eax, MAX_INT      ;check if input > MAX_INT
  jg tooLarge     
  jmp validInput        ;skip over error cases if input is valid
  
  tooLarge: 
  ;print error when input is too large and loop back to getInput
  printStr ebx
  jmp getInput
                             
  notPositive:    
  ;print error when input is negative and loop back to getInput
  printStr ecx
  jmp getInput

  validInput:
  ret

readInput ENDP

convert PROC
	;STACK
	;input int [+12]
	;addr of array [+8]
	;return address [+4]
	;ebp

push ebp
mov ebp, esp
pushad
mov edx, [ebp+12] 
mov ebx, [ebp+8]   ;ebx = addr string array  
add ebx, 3         ;hex digits will be loaded in reverse order 
                   ;so move forward 3 bytes to start load at arr[3]

convertDigit:
and dx, 15         ;and a value with (2^n - 1) to obtain the modulo result this is the remainder

sub esp, 4         ;make room for return digit
push edx
call toChar
pop edx            ;edx gets return value which = hex digit ascii value
mov [ebx], dl      ;inserts ascii value for current hex digit into array

dec ebx            ;move to previous arr index
shr eax, 4         ;result = quotient from diving user input by 16. 
				   ;this becomes the new dividend on next loop pass
mov edx, eax      
cmp eax, 0         ;if eax = 0 then we have extracted all the hex digits from
                   ;the input value and there is no need to continue. 
ja convertDigit

popad
pop ebp
ret 8

convert ENDP

toChar PROC 
	;STACK
	;return value [+12]
	;hex digit argument [+8]
	;return address  [+4]
	;ebp
   
push ebp
mov ebp, esp
push eax

mov eax, [ebp+8]      ;eax = hex digit
cmp eax, 9            ;determine whether hex digit is numeric or alpha
ja hexLetter
add eax, 48           ;this is the offset to convert a digit 0-9 to ascii
jmp returnDigit

hexLetter:
add eax, 55           ;this is the offset to convert a digit 10-15 to hex ascii A-F

returnDigit:
mov [ebp+12], eax     ;move converted hex digit into return value on stack
pop eax
pop ebp
ret 4

toChar ENDP

END main
