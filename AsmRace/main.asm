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
	
	msgMenu BYTE "* Bienvenido a la VERDADERA CARRERA 3000 *",0Ah, 0
	espacio BYTE "  ",0Ah, 0
	MenuPrincipal BYTE "* Menu Principal *  ",0Ah, 0
	OP1 BYTE "* 1. Jugar",0Ah, 0
	OP2 BYTE "* 2. Instrucciones",0Ah, 0
	OP3 BYTE "* 3. Salir ",0Ah, 0
	IngresarOpcion BYTE "* Ingrese la opcion: ", 0
	OpcionFormat BYTE "%d",0
	Opcion DWORD 0

	; How to play screen variables.

	; Main Loop variables.
	gameBoardFormat01 BYTE 01Bh,"[1;32m              ...........                                          ...................              ",01Bh,"[0m",0Ah,0
	gameBoardFormat02 BYTE "           .......'........                                  ..............'...............         ",0Ah,0
	gameBoardFormat03 BYTE "         ......'''''''''.....                             .......'''''''''',,'''',''''''.....       ",0Ah,0
	gameBoardFormat04 BYTE "       .......,13'',;14'''....                         ......'''37,'',38,,''39''',40''',41'.....     ",0Ah,0
	gameBoardFormat05 BYTE "      ....'12''''..'''''15''...                     .......'36'',,,'..''............'',,,'''....    ",0Ah,0
	gameBoardFormat06 BYTE "     ...'',;,'..........','''..                   ........',,,'................ .  ....'''42''..    ",0Ah,0
	gameBoardFormat07 BYTE "    ...''11,'.....   ....'16'...                ......'35,'...........                ..'',,'''..   ",0Ah,0
	gameBoardFormat08 BYTE "    ..'',,''...       ...,;,''..               ...''''',,'.......                      ..''''''.    ",0Ah,0
	gameBoardFormat09 BYTE "   ..''10,''..        ...'17''..             ...'',,34'......                         ..'',43'..    ",0Ah,0
	gameBoardFormat10 BYTE "  ..'''''''..         ..'',,''..            ...'''',,'.....                        ....''',,''..    ",0Ah,0
	gameBoardFormat11 BYTE "  ..''09,'..          ..''18''..           ...',,33''....                      .......''44'.....    ",0Ah,0
	gameBoardFormat12 BYTE " ..''',''..           ..''''''..           ..',,,'''...                  ..........'''',,,.....     ",0Ah,0
	gameBoardFormat13 BYTE " ..'08,''..           ..',19''..          ..'''32'''..               .........''''45,''.......      ",0Ah,0
	gameBoardFormat14 BYTE " ..'',,''.            ..''''''..          ..',;,'''..             .......''''',,'',,'.......        ",0Ah,0
	gameBoardFormat15 BYTE " .''07,'..            ..',20'..          ..'''31'...           .......'',46''',,'.........          ",0Ah,0
	gameBoardFormat16 BYTE "..'',,,'..           ..'',,''..         ..'',,'''...        ........',,'','...........              ",0Ah,0
	gameBoardFormat17 BYTE "..''06''..           ..''21''..        ..'''30''..        ......'''''47...........                  ",0Ah,0
	gameBoardFormat18 BYTE "..'',,,'..           ..',;,'..        ...',,,''..       .......',,,..........                       ",0Ah,0
	gameBoardFormat19 BYTE "..''05''..           .''22''..       ...''29,'..      .....'',48'........                           ",0Ah,0
	gameBoardFormat20 BYTE "...',,''..          ...'',,'..      ...'''''''..      ...''',,'.......                              ",0Ah,0
	gameBoardFormat21 BYTE "...'04''..          ...'23,'...    ...''28,''..      ..''49''......     ,oc.                        ",0Ah,0
	gameBoardFormat22 BYTE "..''',''..           ...'''''.......''''',''..      ..''',,'....        'oc. ..                     ",0Ah,0
	gameBoardFormat23 BYTE "..''03,'..           ....'24,'''''.'27,''....       ..''''''..         .::. :Oo.                    ",0Ah,0
	gameBoardFormat24 BYTE "..''''''..            ...'',,''',,'''''.....       ..''',50'.. ........,dd,.',',;.                  ",0Ah,0
	gameBoardFormat25 BYTE "..''02,'..             ....'25''26''.......       ....''',''........'''...:0o..xk,                  ",0Ah,0
	gameBoardFormat26 BYTE "....,,''..                ...............         .....''',,,''',,'',;,''..'.  ...                  ",0Ah,0
	gameBoardFormat27 BYTE "....01....                      ......             ....''',,'''',,''''....                          ",0Ah,0
	gameBoardFormat28 BYTE "   .....                                           ....''''''''''....                             ",0Ah,00

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

		;call clearConsole
		
		invoke printf, addr goodbyeMessage
		RET
	main ENDP

	;----Menu------------------------------------
	; Display Menu options
		; 1) Start Game
		; 2) How to play?
		; 3) Quit
	mainMenu PROC; Angela
		ploop:
			;-----prints-------
			invoke printf, addr espacio
			invoke printf, addr msgMenu
			invoke printf, addr espacio
			invoke printf, addr MenuPrincipal
			invoke printf, addr OP1
			invoke printf, addr OP2
			invoke printf, addr OP3
			;----Ingreso de la opcion----
			invoke printf, addr IngresarOpcion
			invoke scanf, addr OpcionFormat, addr Opcion

			;comparador
			cmp Opcion, 1
			je lp1
			jne lp2

		lp1: ;si es igual a 1, entonces se va al juego
			call mainLoop
			jmp ploop
		lp2: ;En el caso que no se vaya a jugar entonces compara entre el valor 2 y 3 
			
			;segundo comparador 
			cmp Opcion, 2
			je lp3
			jne lp4
			
		lp3: ;si es igual a 2, va a mostrar las instrucciones
			call howToPlayScreen 
			jmp ploop

		lp4: ;si es igual a 3, entonces sale del programa
			cmp Opcion, 3
			je endd

	endd: 
		invoke scanf
		RET; This is already option 3

		mainLoop:; Flavio
		 	call clearConsole
			call showBoard
			RET
		howToPlayScreen:; Fernando
			; Code goes here....	
			RET
	mainMenu ENDP

	; Shows the board of the game.
	showBoard PROC
		invoke printf, addr gameBoardFormat01
		invoke printf, addr gameBoardFormat02
		invoke printf, addr gameBoardFormat03
		invoke printf, addr gameBoardFormat04
		invoke printf, addr gameBoardFormat05
		invoke printf, addr gameBoardFormat06
		invoke printf, addr gameBoardFormat07
		invoke printf, addr gameBoardFormat08
		invoke printf, addr gameBoardFormat09
		invoke printf, addr gameBoardFormat10
		invoke printf, addr gameBoardFormat11
		invoke printf, addr gameBoardFormat12
		invoke printf, addr gameBoardFormat13
		invoke printf, addr gameBoardFormat14
		invoke printf, addr gameBoardFormat15
		invoke printf, addr gameBoardFormat16
		invoke printf, addr gameBoardFormat17
		invoke printf, addr gameBoardFormat18
		invoke printf, addr gameBoardFormat19
		invoke printf, addr gameBoardFormat20
		invoke printf, addr gameBoardFormat21
		invoke printf, addr gameBoardFormat22
		invoke printf, addr gameBoardFormat23
		invoke printf, addr gameBoardFormat24
		invoke printf, addr gameBoardFormat25
		invoke printf, addr gameBoardFormat26
		invoke printf, addr gameBoardFormat27
		invoke printf, addr gameBoardFormat28
		RET
	showBoard ENDP

	; Clears the console calling the system "cls" command.
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