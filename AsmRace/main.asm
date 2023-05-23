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

includelib libucrt.lib; se importan librerias
includelib legacy_stdio_definitions.lib
includelib libcmt.lib
includelib libvcruntime.lib

printf proto c : vararg 	; To print to std output.
scanf proto c : vararg 		; To read from std input.
system proto c : vararg 	; To clear the console screen.
rand proto c : vararg 		; To getting a random number.
srand proto c : vararg 		; To change the seed of the random number generator.
_getch proto c : vararg 		; To make the "Press enter to continue" functionality.

.data
	; General formats
	digitFormat		BYTE "%d",0
	stringFormat BYTE "%s",0
	ansiReset BYTE 01Bh,"[0m",0
	boardColor BYTE 01Bh,"[0;95m",0; Purple
	normalCellColor BYTE 01Bh, "[1;93m",0 ; Yellow
	userCellColor BYTE 01Bh,"[0;30m", 01Bh,"[0;46m",0 ; Black with cyan background

	; Main menu variables.
	
	msgMenu BYTE "* Bienvenido a la  * VERDADERA CARRERA 3000 *  *",0Ah, 0
	espacio BYTE "  ",0Ah, 0
	MenuPrincipal BYTE "* ---------------Menu Principal--------------- *  ",0Ah, 0; el menú del juego cuenta con tres opciones
	OP1 BYTE "* 1. Jugar",0Ah, 0
	OP2 BYTE "* 2. Instrucciones",0Ah, 0
	OP3 BYTE "* 3. Salir ",0Ah, 0
	IngresarOpcion BYTE "* Ingrese la opcion: ", 0; para que el usuario ingrese la opción deseada. 
	OpcionFormat BYTE "%d",0
	Opcion DWORD 0

	;dibujito de gratis
	draw1 BYTE "    #######",0Ah, 0
	draw2 BYTE "   #########  ",0Ah, 0
	draw3 BYTE "  ########### ",0Ah, 0
	draw4 BYTE " #### ### ####",0Ah, 0
	draw5 BYTE " #### ### ####",0Ah, 0
	draw6 BYTE " #### ### ####",0Ah, 0
	draw7 BYTE " #############",0Ah, 0
	draw8 BYTE " #W#########W#",0Ah, 0
	draw9 BYTE " #. ####### .#",0Ah, 0
	draw10 BYTE " ### ##### ###",0Ah, 0
	draw11 BYTE "  ###     ### ",0Ah, 0
	draw12 BYTE "   #########",0Ah, 0
	draw13 BYTE "    #######",0Ah, 0
		
	; How to play screen variables. Fernando
	msgInstrucciones BYTE "----- Instrucciones del Juego -----",0Ah, 0; mensajes para las instrucciones del juego
	msg1 BYTE "Instruccion general: ",0Ah, 0
	instruccionGeneral BYTE "1). El jugador lanza dos dados (maximo 6 veces) y tiene que avanzar la cantidad de pasos indicada por los dados.",0Ah, 0
	lineas BYTE "---------------------------------------------------------------------------------------------------------------",0Ah, 0
	msg2 BYTE "Reglas: ",0Ah, 0
	regla1 BYTE "1). Si al tirar los dados ambos son iguales, el jugador retrocede 10 pasos. ",0Ah, 0
	regla2 BYTE "2). No puede haber retrocesos que lleven al jugador antes de la linea de inicio (el limite es la linea de inicio). ",0Ah, 0
	regla3 BYTE "3). Si llega a la meta o la sobrepasa antes de 6 intentos de lanzamientos de dados, quiere decir que, ",0ADh, "Has ganado el juego, felicidades!",0Ah, 0

	; Main Loop variables.
	labelDado1 BYTE "Presione enter para lanzar el primer dado...",0Ah,0
	labelDado2 BYTE "Presione enter para lanzar el segundo dado...",0Ah,0
	diceResultFormat BYTE "El dado dio: %d",0Ah,0
	equalDiceThrowMessage BYTE "Lo sentimos, pero tienes que retroceder 10 casillas!",0Ah,0
	normalDiceThrowMessage BYTE 0ADh,"Avanzas %d casillas!",0Ah,0
	doneThrowingDiceMessage BYTE "Presiona enter para continuar...",0
	dado1 DWORD 0
	dado2 DWORD 0

	userCell DWORD 1
	throwCount BYTE 0

	goBackToMenuMessage BYTE "Presione enter para regresar al menu...",0
	userWonMessage BYTE 0ADh,"Felicidades! Has ganado con %d tiradas.",0Ah,0
	userLostMessage BYTE 0ADh,"Lo sentimos! Pero has acabado tu cantidad limite de tiros",0Ah,0

	gameBoardCell01 BYTE "01",0; variables para cada celda del juego, 50 en total
	gameBoardCell02 BYTE "02",0
	gameBoardCell03 BYTE "03",0
	gameBoardCell04 BYTE "04",0
	gameBoardCell05 BYTE "05",0
	gameBoardCell06 BYTE "06",0
	gameBoardCell07 BYTE "07",0
	gameBoardCell08 BYTE "08",0
	gameBoardCell09 BYTE "09",0
	gameBoardCell10 BYTE "10",0
	gameBoardCell11 BYTE "11",0
	gameBoardCell12 BYTE "12",0
	gameBoardCell13 BYTE "13",0
	gameBoardCell14 BYTE "14",0
	gameBoardCell15 BYTE "15",0
	gameBoardCell16 BYTE "16",0
	gameBoardCell17 BYTE "17",0
	gameBoardCell18 BYTE "18",0
	gameBoardCell19 BYTE "19",0
	gameBoardCell20 BYTE "20",0
	gameBoardCell21 BYTE "21",0
	gameBoardCell22 BYTE "22",0
	gameBoardCell23 BYTE "23",0
	gameBoardCell24 BYTE "24",0
	gameBoardCell25 BYTE "25",0
	gameBoardCell26 BYTE "26",0
	gameBoardCell27 BYTE "27",0
	gameBoardCell28 BYTE "28",0
	gameBoardCell29 BYTE "29",0
	gameBoardCell30 BYTE "30",0
	gameBoardCell31 BYTE "31",0
	gameBoardCell32 BYTE "32",0
	gameBoardCell33 BYTE "33",0
	gameBoardCell34 BYTE "34",0
	gameBoardCell35 BYTE "35",0
	gameBoardCell36 BYTE "36",0
	gameBoardCell37 BYTE "37",0
	gameBoardCell38 BYTE "38",0
	gameBoardCell39 BYTE "39",0
	gameBoardCell40 BYTE "40",0
	gameBoardCell41 BYTE "41",0
	gameBoardCell42 BYTE "42",0
	gameBoardCell43 BYTE "43",0
	gameBoardCell44 BYTE "44",0
	gameBoardCell45 BYTE "45",0
	gameBoardCell46 BYTE "46",0
	gameBoardCell47 BYTE "47",0
	gameBoardCell48 BYTE "48",0
	gameBoardCell49 BYTE "49",0
	gameBoardCell50 BYTE "50",0

	gameBoardFormat01 BYTE 01Bh,"[0;95m              ...........                                          ...................              ",0Ah,0; tablero del juego
	gameBoardFormat02 BYTE "           .......'........                                  ..............'...............         ",0Ah,0
	gameBoardFormat03 BYTE "         ......'''''''''.....                             .......'''''''''',,'''',''''''.....       ",0Ah,0
	gameBoardFormat04_1 BYTE "       .......,%s%s%s%s'',;%s%s%s%s'''....                         ......'''%s%s%s%s,''",0
	gameBoardFormat04_2 BYTE ",%s%s%s%s,,''%s%s%s%s''',%s%s%s%s''',%s%s%s%s'.....     ",0Ah,0
	gameBoardFormat05 BYTE "      ....'%s%s%s%s''''..'''''%s%s%s%s''...                     .......'%s%s%s%s'',,,'..''............'',,,'''....    ",0Ah,0
	gameBoardFormat06 BYTE "     ...'',;,'..........','''..                   ........',,,'................ .  ....'''%s%s%s%s''..    ",0Ah,0
	gameBoardFormat07 BYTE "    ...''%s%s%s%s,'.....   ....'%s%s%s%s'...                ......'%s%s%s%s,'...........                ..'',,'''..   ",0Ah,0
	gameBoardFormat08 BYTE "    ..'',,''...       ...,;,''..               ...''''',,'.......                      ..''''''.    ",0Ah,0
	gameBoardFormat09 BYTE "   ..''%s%s%s%s,''..        ...'%s%s%s%s''..             ...'',,%s%s%s%s'......                         ..'',%s%s%s%s'..    ",0Ah,0
	gameBoardFormat10 BYTE "  ..'''''''..         ..'',,''..            ...'''',,'.....                        ....''',,''..    ",0Ah,0
	gameBoardFormat11 BYTE "  ..''%s%s%s%s,'..          ..''%s%s%s%s''..           ...',,%s%s%s%s''....                      .......''%s%s%s%s'.....    ",0Ah,0
	gameBoardFormat12 BYTE " ..''',''..           ..''''''..           ..',,,'''...                  ..........'''',,,.....     ",0Ah,0
	gameBoardFormat13 BYTE " ..'%s%s%s%s,''..           ..',%s%s%s%s''..          ..'''%s%s%s%s'''..               .........''''%s%s%s%s,''.......      ",0Ah,0
	gameBoardFormat14 BYTE " ..'',,''.            ..''''''..          ..',;,'''..             .......''''',,'',,'.......        ",0Ah,0
	gameBoardFormat15 BYTE " .''%s%s%s%s,'..            ..',%s%s%s%s'..          ..'''%s%s%s%s'...           .......'',%s%s%s%s''',,'.........          ",0Ah,0
	gameBoardFormat16 BYTE "..'',,,'..           ..'',,''..         ..'',,'''...        ........',,'','...........              ",0Ah,0
	gameBoardFormat17 BYTE "..''%s%s%s%s''..           ..''%s%s%s%s''..        ..'''%s%s%s%s''..        ......'''''%s%s%s%s...........                  ",0Ah,0
	gameBoardFormat18 BYTE "..'',,,'..           ..',;,'..        ...',,,''..       .......',,,..........                       ",0Ah,0
	gameBoardFormat19 BYTE "..''%s%s%s%s''..           .''%s%s%s%s''..       ...''%s%s%s%s,'..      .....'',%s%s%s%s'........                           ",0Ah,0
	gameBoardFormat20 BYTE "...',,''..          ...'',,'..      ...'''''''..      ...''',,'.......                              ",0Ah,0
	gameBoardFormat21 BYTE "...'%s%s%s%s''..          ...'%s%s%s%s,'...    ...''%s%s%s%s,''..      ..''%s%s%s%s''......     ,oc.                        ",0Ah,0
	gameBoardFormat22 BYTE "..''',''..           ...'''''.......''''',''..      ..''',,'....        'oc. ..                     ",0Ah,0
	gameBoardFormat23 BYTE "..''%s%s%s%s,'..           ....'%s%s%s%s,'''''.'%s%s%s%s,''....       ..''''''..         .::. :Oo.                    ",0Ah,0
	gameBoardFormat24 BYTE "..''''''..            ...'',,''',,'''''.....       ..''',%s%s%s%s'.. ........,dd,.',',;.                  ",0Ah,0
	gameBoardFormat25 BYTE "..''%s%s%s%s,'..             ....'%s%s%s%s''%s%s%s%s''.......       ....''',''........'''...:0o..xk,                  ",0Ah,0
	gameBoardFormat26 BYTE "....,,''..                ...............         .....''',,,''',,'',;,''..'.  ...                  ",0Ah,0
	gameBoardFormat27 BYTE "....%s%s%s%s....                      ......             ....''',,'''',,''''....                          ",0Ah,0
	gameBoardFormat28 BYTE "   .....                                           ....''''''''''....                             ",01Bh,"[0m",0Ah,00

	; Data for Random number generation.
	randomSeed		DWORD 0
	randomNum		DWORD ?
	RANDOM_MAX		DWORD 6
	message			BYTE "Insert your lucky number: ",0; a base de la seed genera el lucky number


	goodbyeMessage BYTE "Thanks for playing!",0Ah,"Noentiendo TM.",0
	clearConsoleCommand BYTE "cls",0

.code

	main PROC
		call setUpRandomSeed; pide el lucky number
		call mainMenu

		;call clearConsole; limpia a la consola y tira el mensaje de despedida. 
		invoke printf, addr goodbyeMessage
		invoke printf, addr espacio

		RET
	main ENDP

	;----Menu------------------------------------
	; Display Menu options
		; 1) Start Game
		; 2) How to play?
		; 3) Quit
	mainMenu PROC; Angela
		ploop:
			call clearConsole
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
			mov userCell, 1
			mov throwCount, 0
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
			invoke printf, addr espacio
			invoke printf, addr draw1
			invoke printf, addr draw2
			invoke printf, addr draw3
			invoke printf, addr draw4
			invoke printf, addr draw5
			invoke printf, addr draw6
			invoke printf, addr draw7
			invoke printf, addr draw8
			invoke printf, addr draw9
			invoke printf, addr draw10
			invoke printf, addr draw11
			invoke printf, addr draw12
			invoke printf, addr draw13
			je endd

	endd: 
		invoke printf, addr espacio
		invoke scanf
		RET; This is already option 3

		mainLoop:; Flavio
		 	call clearConsole
			call showBoard

			.IF userCell == 50; si el jugador llega a la casilla 50 quiere decir que gano y se muestra el mensaje de felicidades
				invoke printf, addr userWonMessage, throwCount
				invoke printf, addr goBackToMenuMessage
				invoke _getch
				RET
			.ENDIF

			.IF throwCount == 6	; si llego a las 6 lanzadas de dado, el jugador ha perdido y muestra el mensaje de que no ha ganado. 
				invoke printf, addr userLostMessage
				invoke printf, addr goBackToMenuMessage
				invoke _getch
				RET
			.ENDIF

			invoke printf, addr labelDado1; el usuario tiene que presionar enter
			invoke _getch
			call generateRandomNumber; se genera el numero random
			mov eax, randomNum; se mueve el random a un registro
			mov dado1, eax

			invoke printf, addr diceResultFormat, dado1; muestra el resultado del número random obtenido

			invoke printf, addr labelDado2
			invoke _getch
			call generateRandomNumber
			mov eax, randomNum
			mov dado2, eax

			invoke printf, addr diceResultFormat, dado2

			mov eax, dado2
			.IF dado1 == eax
				invoke printf, addr equalDiceThrowMessage
				sub userCell, 10; tiene que retroceder 10
				.IF userCell >= 50; si la celda es mayor o igual a 50
					mov userCell, 1
				.ENDIF
			.ELSE	
				mov eax, dado1
				add eax, dado2
				add userCell, eax

				.IF userCell >= 50
					mov userCell, 50
				.ENDIF

				invoke printf, addr normalDiceThrowMessage, eax
			.ENDIF

			invoke printf, addr doneThrowingDiceMessage
			invoke _getch

			inc throwCount
			jmp mainLoop
			RET
		howToPlayScreen:; Fernando, son las instrucciones del juego
			invoke printf, addr espacio; print de mensajes para las instrucciones
			invoke printf, addr msgInstrucciones
			invoke printf, addr msg1
			invoke printf, addr instruccionGeneral
			invoke printf, addr lineas
			invoke printf, addr msg2
			invoke printf, addr regla1
			invoke printf, addr regla2
			invoke printf, addr regla3
			invoke printf, addr goBackToMenuMessage
			invoke _getch
			RET
	mainMenu ENDP

	; Shows the board of the game.
	showBoard PROC
		invoke printf, addr gameBoardFormat01
		invoke printf, addr gameBoardFormat02
		invoke printf, addr gameBoardFormat03

		; 13, 14, 37
		.IF userCell == 13
			invoke printf, addr gameBoardFormat04_1, addr userCellColor, addr gameBoardCell13, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell14, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell37, addr ansiReset, addr boardColor
		.ELSEIF userCell == 14
			invoke printf, addr gameBoardFormat04_1, addr normalCellColor, addr gameBoardCell13, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell14, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell37, addr ansiReset, addr boardColor
		.ELSEIF userCell == 37
			invoke printf, addr gameBoardFormat04_1, addr normalCellColor, addr gameBoardCell13, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell14, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell37, addr ansiReset, addr boardColor
		.ELSE	
			invoke printf, addr gameBoardFormat04_1, addr normalCellColor, addr gameBoardCell13, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell14, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell37, addr ansiReset, addr boardColor
		.ENDIF

		; 38, 39, 40, 41
		.IF userCell == 38
			invoke printf, addr gameBoardFormat04_2, addr userCellColor, addr gameBoardCell38, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell39, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell40, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell41, addr ansiReset, addr boardColor
		.ELSEIF userCell == 39
			invoke printf, addr gameBoardFormat04_2, addr normalCellColor, addr gameBoardCell38, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell39, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell40, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell41, addr ansiReset, addr boardColor
		.ELSEIF userCell == 40
			invoke printf, addr gameBoardFormat04_2, addr normalCellColor, addr gameBoardCell38, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell39, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell40, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell41, addr ansiReset, addr boardColor
		.ELSEIF userCell == 41
			invoke printf, addr gameBoardFormat04_2, addr normalCellColor, addr gameBoardCell38, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell39, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell40, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell41, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat04_2, addr normalCellColor, addr gameBoardCell38, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell39, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell40, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell41, addr ansiReset, addr boardColor
		.ENDIF

		; 12, 15, 36
		.IF userCell == 12
			invoke printf, addr gameBoardFormat05, addr userCellColor, addr gameBoardCell12, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell15, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell36, addr ansiReset, addr boardColor
		.ELSEIF userCell == 15
			invoke printf, addr gameBoardFormat05, addr normalCellColor, addr gameBoardCell12, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell15, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell36, addr ansiReset, addr boardColor
		.ELSEIF userCell == 36
			invoke printf, addr gameBoardFormat05, addr normalCellColor, addr gameBoardCell12, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell15, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell36, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat05, addr normalCellColor, addr gameBoardCell12, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell15, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell36, addr ansiReset, addr boardColor
		.ENDIF
		
		.IF userCell == 42
			invoke printf, addr gameBoardFormat06, addr userCellColor, addr gameBoardCell42, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat06, addr normalCellColor, addr gameBoardCell42, addr ansiReset, addr boardColor
		.ENDIF

		; 11, 16, 35
		.IF userCell == 11
			invoke printf, addr gameBoardFormat07, addr userCellColor, addr gameBoardCell11, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell16, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell35, addr ansiReset, addr boardColor	
		.ELSEIF userCell == 16
			invoke printf, addr gameBoardFormat07, addr normalCellColor, addr gameBoardCell11, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell16, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell35, addr ansiReset, addr boardColor	
		.ELSEIF userCell == 35
			invoke printf, addr gameBoardFormat07, addr normalCellColor, addr gameBoardCell11, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell16, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell35, addr ansiReset, addr boardColor	
		.ELSE	
			invoke printf, addr gameBoardFormat07, addr normalCellColor, addr gameBoardCell11, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell16, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell35, addr ansiReset, addr boardColor	
		.ENDIF
		invoke printf, addr gameBoardFormat08
		
		; 10, 17, 34, 43
		.IF userCell == 10
			invoke printf, addr gameBoardFormat09, addr userCellColor, addr gameBoardCell10, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell17, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell34, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell43, addr ansiReset, addr boardColor 		
		.ELSEIF userCell == 17
			invoke printf, addr gameBoardFormat09, addr normalCellColor, addr gameBoardCell10, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell17, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell34, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell43, addr ansiReset, addr boardColor 		
		.ELSEIF userCell == 34
			invoke printf, addr gameBoardFormat09, addr normalCellColor, addr gameBoardCell10, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell17, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell34, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell43, addr ansiReset, addr boardColor 		
		.ELSEIF userCell == 43
			invoke printf, addr gameBoardFormat09, addr normalCellColor, addr gameBoardCell10, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell17, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell34, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell43, addr ansiReset, addr boardColor 		
		.ELSE	
			invoke printf, addr gameBoardFormat09, addr normalCellColor, addr gameBoardCell10, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell17, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell34, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell43, addr ansiReset, addr boardColor 		
		.ENDIF
		invoke printf, addr gameBoardFormat10
		
		; 9, 18, 33, 44
		.IF userCell == 9
			invoke printf, addr gameBoardFormat11, addr userCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell18, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell33, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell44, addr ansiReset, addr boardColor   
		.ELSEIF userCell == 18
			invoke printf, addr gameBoardFormat11, addr normalCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell18, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell33, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell44, addr ansiReset, addr boardColor   
		.ELSEIF userCell == 33
			invoke printf, addr gameBoardFormat11, addr normalCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell18, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell33, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell44, addr ansiReset, addr boardColor   
		.ELSEIF userCell == 44
			invoke printf, addr gameBoardFormat11, addr normalCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell18, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell33, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell44, addr ansiReset, addr boardColor   
		.ELSE
			invoke printf, addr gameBoardFormat11, addr normalCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell18, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell33, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell44, addr ansiReset, addr boardColor   
		.ENDIF
		invoke printf, addr gameBoardFormat12

		; 8, 19, 32 45
		.IF userCell == 8
			invoke printf, addr gameBoardFormat13, addr userCellColor, addr gameBoardCell08, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell32, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell45, addr ansiReset, addr boardColor 			
		.ELSEIF userCell == 19
			invoke printf, addr gameBoardFormat13, addr normalCellColor, addr gameBoardCell08, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell32, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell45, addr ansiReset, addr boardColor 		
		.ELSEIF userCell == 32
			invoke printf, addr gameBoardFormat13, addr normalCellColor, addr gameBoardCell08, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell32, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell45, addr ansiReset, addr boardColor 		
		.ELSEIF userCell == 45
			invoke printf, addr gameBoardFormat13, addr normalCellColor, addr gameBoardCell08, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell32, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell45, addr ansiReset, addr boardColor 		
		.ELSE
			invoke printf, addr gameBoardFormat13, addr normalCellColor, addr gameBoardCell08, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell09, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell32, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell45, addr ansiReset, addr boardColor 		
		.ENDIF

		invoke printf, addr gameBoardFormat14
		; 7, 20, 31, 46
		.IF userCell == 7
			invoke printf, addr gameBoardFormat15, addr userCellColor, addr gameBoardCell07, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell20, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell31, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell46, addr ansiReset, addr boardColor
		.ELSEIF userCell == 20
			invoke printf, addr gameBoardFormat15, addr normalCellColor, addr gameBoardCell07, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell20, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell31, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell46, addr ansiReset, addr boardColor
		.ELSEIF userCell == 31
			invoke printf, addr gameBoardFormat15, addr normalCellColor, addr gameBoardCell07, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell20, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell31, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell46, addr ansiReset, addr boardColor
		.ELSEIF userCell == 46
			invoke printf, addr gameBoardFormat15, addr normalCellColor, addr gameBoardCell07, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell20, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell31, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell46, addr ansiReset, addr boardColor
		.ELSE 	
			invoke printf, addr gameBoardFormat15, addr normalCellColor, addr gameBoardCell07, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell20, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell31, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell46, addr ansiReset, addr boardColor
		.ENDIF
		invoke printf, addr gameBoardFormat16

		; 6, 21, 30, 47
		.IF userCell == 6
			invoke printf, addr gameBoardFormat17, addr userCellColor, addr gameBoardCell06, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell21, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell30, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell47, addr ansiReset, addr boardColor
		.ELSEIF userCell == 21
			invoke printf, addr gameBoardFormat17, addr normalCellColor, addr gameBoardCell06, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell21, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell30, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell47, addr ansiReset, addr boardColor
		.ELSEIF userCell == 30
			invoke printf, addr gameBoardFormat17, addr normalCellColor, addr gameBoardCell06, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell21, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell30, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell47, addr ansiReset, addr boardColor
		.ELSEIF userCell == 47
			invoke printf, addr gameBoardFormat17, addr normalCellColor, addr gameBoardCell06, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell21, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell30, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell47, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat17, addr normalCellColor, addr gameBoardCell06, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell21, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell30, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell47, addr ansiReset, addr boardColor
		.ENDIF
		invoke printf, addr gameBoardFormat18

		; 5, 22, 29, 48
		.IF userCell == 5
			invoke printf, addr gameBoardFormat19, addr userCellColor, addr gameBoardCell05, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell22, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell29, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell48, addr ansiReset, addr boardColor
		.ELSEIF userCell == 22
			invoke printf, addr gameBoardFormat19, addr normalCellColor, addr gameBoardCell05, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell22, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell29, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell48, addr ansiReset, addr boardColor
		.ELSEIF userCell == 29
			invoke printf, addr gameBoardFormat19, addr normalCellColor, addr gameBoardCell05, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell22, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell29, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell48, addr ansiReset, addr boardColor
		.ELSEIF userCell == 48	
			invoke printf, addr gameBoardFormat19, addr normalCellColor, addr gameBoardCell05, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell22, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell29, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell48, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat19, addr normalCellColor, addr gameBoardCell05, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell22, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell29, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell48, addr ansiReset, addr boardColor
		.ENDIF
		invoke printf, addr gameBoardFormat20

		; 4, 23, 28, 49
		.IF userCell == 4
			invoke printf, addr gameBoardFormat21, addr userCellColor, addr gameBoardCell04, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell23, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell28, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell49, addr ansiReset, addr boardColor
		.ELSEIF userCell == 23
			invoke printf, addr gameBoardFormat21, addr normalCellColor, addr gameBoardCell04, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell23, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell28, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell49, addr ansiReset, addr boardColor
		.ELSEIF userCell == 28
			invoke printf, addr gameBoardFormat21, addr normalCellColor, addr gameBoardCell04, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell23, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell28, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell49, addr ansiReset, addr boardColor
		.ELSEIF userCell == 49
			invoke printf, addr gameBoardFormat21, addr normalCellColor, addr gameBoardCell04, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell23, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell28, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell49, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat21, addr normalCellColor, addr gameBoardCell04, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell23, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell28, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell49, addr ansiReset, addr boardColor
		.ENDIF
		invoke printf, addr gameBoardFormat22

		.IF userCell == 3
			invoke printf, addr gameBoardFormat23, addr userCellColor, addr gameBoardCell03, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell24, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell27, addr ansiReset, addr boardColor
		.ELSEIF userCell == 24	
			invoke printf, addr gameBoardFormat23, addr normalCellColor, addr gameBoardCell03, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell24, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell27, addr ansiReset, addr boardColor
		.ELSEIF userCell == 27
			invoke printf, addr gameBoardFormat23, addr normalCellColor, addr gameBoardCell03, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell24, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell27, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat23, addr normalCellColor, addr gameBoardCell03, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell24, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell27, addr ansiReset, addr boardColor
		.ENDIF

		.IF userCell == 50
			invoke printf, addr gameBoardFormat24, addr userCellColor, addr gameBoardCell50, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat24, addr normalCellColor, addr gameBoardCell50, addr ansiReset, addr boardColor
		.ENDIF

		.IF userCell == 2
			invoke printf, addr gameBoardFormat25, addr userCellColor, addr gameBoardCell02, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell25, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell26, addr ansiReset, addr boardColor
		.ELSEIF userCell == 25	
			invoke printf, addr gameBoardFormat25, addr normalCellColor, addr gameBoardCell02, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell25, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell26, addr ansiReset, addr boardColor
		.ELSEIF userCell == 26
			invoke printf, addr gameBoardFormat25, addr normalCellColor, addr gameBoardCell02, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell25, addr ansiReset, addr boardColor, addr userCellColor, addr gameBoardCell26, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat25, addr normalCellColor, addr gameBoardCell02, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell25, addr ansiReset, addr boardColor, addr normalCellColor, addr gameBoardCell26, addr ansiReset, addr boardColor
		.ENDIF

		invoke printf, addr gameBoardFormat26
		.IF userCell == 1
			invoke printf, addr gameBoardFormat27, addr userCellColor, addr gameBoardCell01, addr ansiReset, addr boardColor
		.ELSE
			invoke printf, addr gameBoardFormat27, addr normalCellColor, addr gameBoardCell01, addr ansiReset, addr boardColor
		.ENDIF
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