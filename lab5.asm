TITLE  Lab 5: Calculate time difference
		
; Name: Nicole Parziale

INCLUDE Irvine32.inc

.data

hour byte "Enter hours: ", 0
min byte "Enter Minutes: ", 0
badInputRange byte "The time entered is out of range", 0DH, 0AH, 0
invalidInput byte "Time entered is too large. ",0
invalidResult byte "Invalid time difference, check your times", 0
continue byte "Would you like to continue? y/n: ", 0
resultHrs byte " hours, ", 0
resultMins byte " minutes", 0DH, 0AH, 0


.code
main PROC

Begin:

mov ecx, 2      ; requires 2 successful cycles to get user input (start and end times)

	getHour:
		mov edx, OFFSET hour
		call writestring
		call readint
		cmp eax, 0                
		jl hourError              ; if input < 0 jump to error case
		cmp eax, 23                 
		jg hourError              ; if input > 23 jump to error case
	                
	getMin:
		mov bl, al                ; store hour input into bl
	
		mov edx, OFFSET min
		call writestring
		call readint
		cmp eax, 0               
		jl minError               ; if input < 0 jump to error case
		cmp eax, 59    
		jg minError               ; if input > 59 jump to error case
   	

		;convert hours to minutes an check for valid time
		xchg al, bl 
		mov dl, 60                ; 60 mins per hour conversion ratio
		mul dl                    ; convert hours to minutes (hrs x 60)
		jc totalError
		add bl, al                ; add converted minutes to input minutes
	
		;determine if we are on the first or second loop pass and branch accordingly
		cmp ecx, 1                
		je calcDiff               ; if second time through skip to calculate differance 
		mov bh, bl                ; store start time 
		loop getHour

;after obtaining valid start and end times from user calculate difference
;then check for valid result
calcDiff:  
    sub bl, bh       ; bl contains endtime, bh contains start time
	jc resultError   ; if sub endtime - starttime results in CF = 1 then jump to error case

	;convert result back into hours and minutes
	movzx ax, bl
	mov bl, 60
	call dumpRegs
	div bl
	mov cl, ah       ; now al contains hours  and cl contains minutes

    ;print results 	
	movsx eax, al    
	call writedec                ;print hours
	mov edx, OFFSET resultHrs 
	call writestring
	
	movsx eax, cl     
	call writedec                ;print minutes
	mov edx, OFFSET resultmins
	call writeString

cont: 
	call crlf
	mov edx, OFFSET continue 
	call writeString             ;prompt user to continue or exit
	call readChar
	call writeChar               ;print so user can see their input
	call crlf

	;check for valid input user must enter 'Y', 'y', 'N', or 'n'
	cmp al, 'Y'
	je begin
	cmp al, 'y'
	je begin
	cmp al, 'N'
	je finished
	cmp al, 'n'
	je finished
	jmp cont


;  -------  Code segments containing error case handling  ---------

hourError:
	mov edx, OFFSET badInputRange 
	call writestring
	jmp getHour             ; invalid hour input start again

minError:
	mov edx, OFFSET badinputRange
	call writestring
	jmp getMin              ; invalid minute input start again

totalError:
	mov edx, OFFSET invalidInput   
	jmp begin              ; conversion to mins result invalid start again

resultError:
	mov edx, OFFSET invalidResult
	call writestring
	jmp cont              ; result of sub endtime - starttime invalid jump to ask user to continue y/n

;       ------ End of error case code segments --------

finished:
	exit	
main ENDP

END main