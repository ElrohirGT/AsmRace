; Universidad del Valle de Guatemala
; Organizaci�n de Computadoras y Assembler
; Angela Garc�a
; Fernando Echeverr�a
; Daniel Rayo 22933
; Flavio Gal�n 22386
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
rand proto c : vararg
srand proto c : vararg

.data
	randomSeed		DWORD 0
	randomNum		DWORD ?
	RANDOM_MAX		DWORD 7
	message			BYTE "Insert your lucky number: ", 0, 0
	digitFormat		BYTE "%d", 0, 0

.code

	main PROC

	;   --- SETTING RANDOM SEED ---
		call setUpRandomSeed


		RET

	setUpRandomSeed PROC
	;		Let the user input a seed for generating randomNumbers
		invoke printf, offset message
		invoke scanf, addr digitFormat, addr randomSeed
		invoke srand, randomSeed
		RET

	setUpRandomSeed ENDP

	generateRandomNumber PROC
	;		Generate a random number between 1 and RANDOM_MAX (exclusive).
		invoke rand
		mov ebx, RANDOM_MAX
		SUB EDX, EDX
		div ebx			    ; The formula its (RandomNum % RANDOM_MAX)
		
		.IF edx == 0		; Not admiting 0 values.
			inc edx
		.ENDIF

		mov randomNum, edx

		RET

	generateRandomNumber ENDP

main ENDP
	END