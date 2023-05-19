; Universidad del Valle de Guatemala
; Organización de Computadoras y Assembler
; Angela García
; Fernando Echeverría
; Daniel Rayo 22933
; Flavio Galán 22386
; Description: Juego de carreras en MASM para x86.

.386
.model flat, stdcall, c
.stack 4096

includelib libucrt.lib
includelib legacy_stdio_definitions.lib
includelib libcmt.lib
includelib libvcruntime.lib

printf proto c : vararg
scanf proto c : vararg
exit proto c : vararg
system proto c : vararg
rand proto c : vararg
srand proto c : vararg

.data
	; General formats
	digitFormat		BYTE "%d",0
	stringFormat BYTE "%s",0

	; Main menu variables.

	; How to play screen variables.

	; Main Loop variables.

	; Data for Random number generation.
	randomSeed		DWORD 0
	randomNum		DWORD ?
	RANDOM_MAX		DWORD 6
	message			BYTE "Insert your lucky number: ",0


	goodbyeMessage BYTE "Thanks for playing!",0Ah,"Noentiendo TM.",0
	clearConsoleCommand BYTE "cls",0

.code

	main PROC
		call setUpRandomSeed
		call mainMenu

		call clearConsole
		
		invoke printf, addr goodbyeMessage
		RET
	main ENDP

	mainMenu PROC; Angela

		; Display Menu options
		; 1) Start Game
		; 2) How to play?
		; 3) Quit

		RET; This is already option 3

		mainLoop:; Flavio
			; Code goes here...
			RET
		howToPlayScreen:; Fernando
			; Code goes here....	
			RET
	mainMenu ENDP

	; Clears the console calling the system "cls" command.
	; This only works on windows.
	clearConsole PROC
		invoke system, addr clearConsoleCommand
		RET
	clearConsole ENDP
 
	; Let's the user set up a random seed for the dies in the game.
	setUpRandomSeed PROC
	;		Let the user input a seed for generating randomNumbers
		invoke printf, addr message
		invoke scanf, addr digitFormat, addr randomSeed
		invoke srand, randomSeed

		RET
	setUpRandomSeed ENDP

	; Generates a random number between 1-RANDOM_MAX (inclusive).
	; The number is saved to `randomNum`.
	generateRandomNumber PROC
		invoke rand
		mov ebx, RANDOM_MAX
		SUB EDX, EDX
		div ebx ; The formula its (RandomNum % RANDOM_MAX)
		
		; edx is a value between 0-RANDOM_MAX. We add 1 to make it between 1-RANDOM_MAX.
		inc edx

		mov randomNum, edx

		RET

	generateRandomNumber ENDP

END