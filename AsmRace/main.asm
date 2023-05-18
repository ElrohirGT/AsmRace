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
	randomSeed DWORD ?
	message BYTE "Insert your lucky number: " 0, 0

	digitFormat "%d", 0, 0

	call  generateRandomNumber

.code

main PROC
	call generateRandomNumber
main ENDP

generateRandomNumber PROC
	push message
	call printf
	RET

generateRandomNumber ENDP

end