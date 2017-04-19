TITLE "Integer Averaging"     (intAvgr-Cordero.asm)
; Author: Ava Cordero
; Course / Project ID: CS271 Program 6A		Date: 12/3/2016
; Description: Gets 10 valid integers from the user and stores the numeric
;   values in an array. Displays the integers, their sum, and their average.

INCLUDE Irvine32.inc
ARR_LEN = 10				;	length of integer array to be processed
INPUT_MAX = 50				;	max size of input string
;	General Purpose Macros
wrtStr MACRO string			;	general purpose macro to print a string
	push	edx
	mov		edx, OFFSET string
	call	WriteString
	pop		edx
ENDM
rdStr MACRO	inp				;	gen. purp. macro to read a string
	push	ecx
	push	edx
	mov		edx, OFFSET inp
	mov		ecx, (SIZEOF inp) - 1
	call	ReadString
	pop		edx
	pop		ecx
ENDM
;	Program Dependency Macros
getString MACRO input		;	GETSTRING: prompts user for integer input,
	wrtStr	prompt			;		saves the integer to memory
	rdStr	input
ENDM
getInput MACRO outArray
	push	ecx
	push	edi
	mov		ecx, LENGTHOF outArray
	mov		edi, OFFSET outArray
	get:
		call	readVal
		add		edi, 4
		loop	get
	pop		edi
	push	edi
ENDM

.data
	intro1		BYTE	"Integer Averaging			By: Ava", 0
	prompt		BYTE	"Enter an unsigned integer: ", 0
	err			BYTE	"ERROR: Not an unsigned int OR too large!", 0
	inputStr	BYTE	INPUT_MAX DUP(?)		;	user input string
	array		DWORD	ARR_LEN DUP(?)			;	integer array
	val			DWORD	?
	tmp			DWORD	?
.code
main PROC
	getInput	array

	exit
main ENDP

readVal PROC							;	invoke getString - gets user input string
	pushad								;		store in next empty index of array
	start:
		getString	inputStr			
		mov		ecx, eax
		mov		esi, OFFSET inputStr
		cld
		mov		val, 0
	convert:
		lodsb
		cmp		al, 48
		jb		bad
		cmp		al, 57
		ja		bad
		mov		ah, 0					;	val = (10 * val) + (ax-48)
		push	ax	
		mov		ax, 10
		mov		bx, WORD PTR val
		mul		bx
		jo		ovFlo
		mov		WORD PTR tmp, ax
		mov		ebx, tmp
		pop		ax
		sub		ax, 48
		mov		WORD PTR tmp, ax
		add		ebx, tmp
		mov		val, ebx
		loop	convert
		jmp		done
	bad:
		wrtStr	err
		call	CrLf
		jmp		start
	ovFlo:
		pop		ax
		jmp		bad
	done:
		mov		eax, ebx
		stosd
	popad
	ret
readVal ENDP

END main
