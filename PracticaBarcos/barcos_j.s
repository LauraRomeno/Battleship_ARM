@;=============== Fichero fuente de la pr�ctica de los barcos  =================
@;== 	define las rutinas jugar() y sus rutinas auxiliares					  ==
@;== 	programador1: maite.bernaus@estudiants.urv.cat							  ==
@;== 	programador2: laura.romeroh@estudiants.urv.cat							  ==


@;-- .text. c�digo de las rutinas ---
.text	
		.align 2
		.arm


@; jugar(int dim, char tablero_disparos[]):
@;	rutina para realizar los lanzamientos contra el tablero de barcos iniciali-
@;	zado con la �ltima llamada a B_incializa_barcos(), anotando los resultados
@;	en el tablero de disparos que se pasa por par�metro (por referencia), donde
@;	los dos tableros tienen el mismo tama�o (dim = dimensi�n del tablero de
@;	barcos). La rutina realizar� los disparos necesarios hasta hundir todos los
@;	barcos, devolviendo el n�mero total de disparos realizado.
@;	Par�metros:
@;		R0: dim; tama�o de los tableros (dimxdim)
@; 		R1: char tablero_disparos[]; direcci�n base del tablero de disparos
@;	Resultado:
@;		R0: n�mero total de disparos realizados para completar la partida
		.global jugar
jugar:
		push {r0-r6, lr}
	
		mov r5, #10		@; r5= num de baixells totals qeu cal enfonsar epr acabar al partida
		
		mov r6, r0		@; guardem la dimencio a r6 per poder-la recuperar
				
		.Ljugar:
			mov r0, r6				@; recuperem a r0 la dimenci� que teniem guardada a r6
			bl nou_tir				@; r0= dim r2= fila r3= columna
			
			
			bl efectuar_disparo		@; r0=dim, r1= matriz_disparo,  r2= fila r3= columna  entra
									@; r0= resultat del tir  surt
			
			
			cmp r0, #3				@; r0 indica el resultat de la ultima tirada i ho comparem amb 3 que es vaixell enfonsat
			bne .Ljugar
			sub r5, #1				@; restem 1 als vaixells que queden per enfonsar si el resutat del tir es 3
			
			cmp r5, #0
			bne .Ljugar				@; si els baixells enfonsats s�n diferents a 0 seguim jugant
			
		
		pop {r0-r6, pc}



@; efectuar_disparo(int dim, char tablero_disparos[], int f, int c):
@;	rutina para efectuar un disparo contra el tablero de barcos inicializado
@;	con la �ltima llamada a B_incializa_barcos(), anotando los resultados en
@;	el tablero de disparos que se pasa por par�metro (por referencia), donde los
@;	dos tableros tienen el mismo tama�o (dim = dimensi�n del tablero de barcos).
@;	La rutina realizar� el disparo llamando a la funci�n B_dispara(), y actuali-
@;	zar� el contenido del tablero de disparos consecuentemente, devolviendo
@;	el c�digo de resultado del disparo.
@;	Par�metros:
@;		R0: dim; tama�o de los tableros (dimxdim)
@; 		R1: tablero_disparos[]; direcci�n base del tablero de disparos
@;		R2: f; n�mero de fila (0..dim-1)
@;		R3: c; n�mero de columna (0..dim-1)
@;	Resultado:
@;		R0: c�digo del resultado del disparo (-1: ERROR, 0:REPETIT, 1: AGUA,
@;												2: TOCAT, 3: ENFONSAT)
efectuar_disparo:
		push {r1-r8, lr}
		
		mov r4, r0		@; posem la dimensi� a r4
		mov r5, r1		@; posem la matriu_disparos a r5
		
		add r0, r2, #65			@;posem  r0=fila (lletra)
		add r1, r3, #1			@; r1= columna (numero) entre 1 i dim
								@; r3= columna entre 0 i dim -1
								@; r2 = fila entre 0 i dim -1
		
		bl B_dispara 	@; retorna el resultat a r0 i la matriz_barcos ja est� actualitzada
		
			
			mov r7,#'@'     @;  r6= aigua	r7= tocat 	registres que emmagatgemen els simbols de aigua i tocat
			mov r6,#'-'
				
			mul r8,r4,r2			@; r8=posici� en vector 
			add r3,r3,r5
			add r8,r3,r8
				
			cmp r0,#2				@; comparem si s'ha tocat algun vaixell
			blt .Lno				@; saltem si no s'ha tocat cap vaixell
			
			strb r7,[r8]
			bl .Lfinal
			
			.Lno:			
			cmp r0,#1				@; comprovar si hem tocat aigua
			bne .Lfinal				@; si no es aigua saltem
			
			strb r6,[r8]		@; si es aigua posem el dibuix d'aigua
			
			.Lfinal:
			
		pop {r1-r8, pc}

@;	inicialitzar_disaros 
@;	aquesta funci� omlple el taulell de llen�ament amb ? 
@;  abans de cridar guardar R0: dim; R2: tablero_disparos; 
		.global i_disparos
i_disparos:

		push {r0-r6,lr}
		
		mov r3,#'?'	@; guardem a r3 un interrogant
			
					
		mul r6,r0,r0	@; r6=dim x dim
		
		add r4,r6,r2	@; r4= ultima posici� del vecot; que es @base + /dim x dim/
		sub r4,r4,#1
		
		
		
		.Linterrogant:
		
			strb r3,[r4]		@; posem interrogant a la posici� del vector r4
			sub r4,r4,#1			@; restem 1 a la posici� del vector
			cmp r4,r2			@; comparem la posici� actual amb la priemra
		
		bge .Linterrogant 	@; si la posici� actual es major o igual a la primera seguim posant ?

		pop {r0-r6,pc}

@; nou_tir s'ha de fer
@; r0= dim
@; r1= matriz_disp

nou_tir:

		push {r0, r4-r6, lr}

		@; R0=dim=r7 r1= matriz_disp
		
		mov r6,#'?'			@; r6= ?
		mov r4, r0			@; mantenim la dimensi� a r4

		.Lbusca:			@; busca ens generar� un nou tir
			
			
			bl mod_random 	@; ens generar� un nombre aleatori entre 0 i n-1 /n=dim / retorna a r0 el nombre
			mov r2,r0		@; r2= fila entre 0 i dim -1
			mov r0,r4		@; recuperem dim a r0
			
			bl mod_random	@; ens generar� un nombre aleatori entre 0 i n-1 /n=dim / retorna a r0 el nombre
			mov r3,r0		@; r3= columna entre 0 i dim -1
			mov r0,r4		@; recuperem dim a r0
			
			mul r5,r0,r2	@; r5=posici� en vector 
			add r5,r5,r3
			add r5,r5,r1
			
			ldrb r5, [r5]	@; guardem a r5 el contingut de la posici� 
			cmp r5,r6
			bne .Lbusca		@; si no es interrogant seguim buscant r0=dim
		
		pop {r0, r4-r6, pc}


.end


