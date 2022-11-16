TITLE  Lab 8: Find letters in 2D array of strings
		
; Name: Nicole Parziale


INCLUDE Irvine32.inc

ROWS = 3
COLS = 11
TOTAL_BYTES = ROWS * COLS



printStr MACRO addr
	push edx
	mov edx, addr
	call writeString
	pop edx
ENDM

printIndex MACRO index
	
	push eax
	mov al, '['
	call writeChar
	mov eax, index
	call writeDec
	mov al, ']'
	call writeChar
	pop eax

ENDM


.data

arr BYTE (ROWS * COLS)  dup(?)
getUserString BYTE "Enter a string: ", 0
getLetter BYTE "Enter target letter: ", 0
count BYTE "Total Count: ", 0
error BYTE "Invalid entry", 0


.code
main PROC
	
;get and load user input into arr
mov esi, OFFSET arr             
mov ebx, OFFSET getUserString
call fillArr				
call crlf

cmp ecx, 0                   ;if the number of rows = 0 then user didn't input anything so exit
je terminate


letter:
	
	sub esp, 4               ;make room for return value
	push OFFSET getLetter    ;addr of prompt message
	push OFFSET arr          ;add of array containing user's strings
	push ecx                 ;number of user strings
	call findCount
	pop eax

	printStr OFFSET count    
	call writeDec            ;print number of times letter appeared in array
	call crlf

	jmp letter

terminate:

 exit	
main ENDP


fillArr PROC   

	 mov edx, esi                ;esi = addr of arr
	 mov ecx, COLS
	 xor ebp, ebp
		 
	 getInput:
		printStr ebx             ;ebx = prompt message
		call readString
		cmp BYTE PTR [edx], 0    ;check if user input a string 
		je endInput              ;end loop if no input 
		
		add edx, COLS            ;mov to row (beginning of next string)     
		inc ebp          
		cmp ebp, ROWS            ;compare num of strings received to num rows
		jb getInput     

	endInput:
	mov ecx, ebp                 ;update num strings count
	cmp ecx, 0                   ;if no strings entered return
	je finished
	push ecx
	push esi
	call printArr
	    
	finished:
	ret

fillArr ENDP

;received number of strings and addr of array
;via stack and prints the array
printArr PROC 
	;STACK
	;num strings = [ebp+12]
	;addr of arr = [ebp+8]
	;ret addr
	;ebp
	;save callee ecx val [ebp-4]
	;save callee ebx val [ebp-8]

	push ebp
	mov ebp, esp
	push ecx          
	push ebx          
	mov ecx, [ebp+12]
	mov ebx, [ebp+8]
	
	print:
		printStr ebx
		call crlf           ;print each string on new line
		add ebx, COLS       ;mov to next row of arr (begining of next string)
		loop print

   pop ebx
   pop ecx
   pop ebp
   ret 8             
		
printArr ENDP

findCount PROC
	;STACK
	;return value [ebp+20]
	;letter prompt [ebp+16]
	;addr of arr  [ebp+12]
	;num strings  [ebp+8]
	;ret addr     [ebp+4]
	;ebp
	
	push ebp
	mov ebp, esp
	pushad                ;save callee registers

	printStr [ebp+16]
	call readChar
	call writeChar        ;print user input so they can see their input char
	call crlf

	xor ebx, ebx          ;will store the letter count
	mov ecx, TOTAL_BYTES  ;total bytes in array to be searched
	mov edi, [ebp+12]     ;set to addr of arr
	cld

	search:
		repne scasb
		jnz searchComplete     ;letter not found in string/substring
		
		;EC
		push [ebp+12]   ;printLoc requires addr of arr
		push edi        ;and addr of found letter
		call printLoc	
		inc ebx         ;increment count to track letter occurrences 
		jmp search      ;repeate search to look for next occurrence
	
	searchComplete:
	mov [ebp+20], ebx     ;store return value
	popad
	pop ebp
	ret 12    


findCount ENDP

printLoc PROC
	;STACK
	;addr of arr [ebp+12]
	;addr of location immediately after found letter [ebp+8]
	;ret addr [ebp+4]
	;ebp
	;copy of letter location value [ebp-4]
	
	push ebp
	mov ebp, esp
	pushad

	xor eax, eax
	mov eax, [ebp+8]
	mov ebx, [ebp+12]        ;addr of arr[0]
	sub eax , ebx            ;tells distance between the start and the found letter

	mov bl, COLS         
	div bl                   ;divide the distance by COLS  AH contains row  AL contains col 
	movzx ebx, al
	sub al, 1               ;since arr locations begin with zero subtract one from the row number
	printIndex ebx          ;print row
	
	sub ah, 1               ;since arr cols begin with 0 index subtract 1 ffrom col
	movzx ebx, ah         
	printIndex ebx           ;print col

	call crlf         

	popad
	pop ebp
	ret 8 

printLoc ENDP

END main
