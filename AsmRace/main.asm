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

extrn printf:near
extrn scanf:near
extrn exit:near
extrn srand:near
extrn rand:near

.data
	randomSeed		DWORD 0
	randomNum		DWORD ?
	RANDOM_MAX		DWORD 7
	message			BYTE "Insert your lucky number: ", 0, 0
	digitFormat		BYTE "%d", 0, 0

.code

main PROC
;	--- PREPARE STACK ---
	push ebp
	mov ebp, esp

;   --- SETTING RANDOM ---
	call generateRandomNumber

;	--- CLEAN STACK ---
	add esp, 0
	push 0
	call exit

	RET
main ENDP

generateRandomNumber PROC
;		Let the user input a seed, generate a random number
;		between 1 and RANDOM_MAX (exclusive).

	push offset message
	call printf
	add esp, 4

	lea eax, randomSeed
	push eax
	push offset digitFormat
	call scanf
	add esp, 8

	push randomSeed
	call srand
	call rand
	add esp, 4

	mov ebx, RANDOM_MAX
	SUB EDX, EDX
	div ebx

	inc edx
	mov randomNum, edx

	RET

generateRandomNumber ENDP

END