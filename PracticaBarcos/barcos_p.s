@;=========== Fichero fuente principal de la práctica de los barcos  ===========
@;== 	define las variables globales principales del juego (matriz_barcos,	  ==
@;== 	matriz_disparos, ...), la rutina principal() y sus rutinas auxiliares ==
@;== 	programador1: maite.bernaus@estudiants.urv.cat							  ==
@;== 	programador2: laura.romeroh@estudiants.urv.cat							  ==


@;-- símbolos habituales ---
NUM_PARTIDAS = 150


@;--- .bss. non-initialized data ---

.bss
	nd8: .space 1					@; promedio de disparos para tableros de 8x8
	nd9: .space 1					@; de 9x9
	nd10: .space 1					@; de 10x10
	matriz_barcos:	 .space 100		@; códigos de los barcos a hundir
	matriz_disparos: .space 100		@; códigos de los disparos realizados


@;-- .text. código de las rutinas ---
.text	
		.align 2
		.arm


@; principal():
@;	rutina principal del programa de los barcos; realiza n partidas para cada
@;	uno de los 3 tamaños de tablero establecidos (8x8, 9x9 y 10x10), calculando
@;	el promedio del número de disparos necesario para hundir toda la flota,
@;	que se inicializará en posiciones aleatorias en cada partida; los valores
@;	promedio se deben escribir en las variables globales 'nd8', 'nd9' y 'nd10',
@;	respectivamente 
		.global principal
principal:
		push {lr}
		
		ldr r1, =matriz_barcos    
		ldr r2, =matriz_disparos
		mov r0, #8				@; passar els parametres a la funció realizar_partidas 	r0=dim
		
		
		bl realizar_partidas	@; realitzar la partida de 8x8
			
		ldr r2,[r2] 		@; recupera el qüocent que es troba a la memòria
		mov r0,r2,lsr #8		@; posem el resultat a r0
		
		ldr r10, =nd8
		strb r0,[r10]
		
		ldr r1, =matriz_barcos
		ldr r2, =matriz_disparos
		mov r0, #9				@; passar els parametres a la funció realizar_partidas	r0=dim

		bl realizar_partidas	@; realitzar la partida de 9x9
		
		ldr r2,[r2] 		@; recupera el qüocent que es troba a la memòria
		mov r0,r2,lsr #8		@; posem el resultat a r0
		
		ldr r10, =nd9
		strb r0,[r10]
		
		ldr r1, =matriz_barcos
		ldr r2, =matriz_disparos
		mov r0, #10				@; passar els parametres a la funció realizar_partidas	r0=dim
			
		bl realizar_partidas	@; realitzar la partida de 10x10
		
		ldr r2,[r2] 		@; recupera el qüocent que es troba a la memòria
		mov r0,r2,lsr #8		@; posem el resultat a r0
		
		ldr r10, =nd10
		strb r0,[r10]
		
		pop {pc}



@; realizar_partidas(int dim, char tablero_barcos[], 
@;								char tablero_disparos[], char *var_promedio):
@;	rutina para realizar un cierto número de partidas (NUM_PARTIDAS) de la
@;	batalla de barcos, sobre un tablero de barcos y un tablero de disparos
@;	pasados por parámetro, junto con la dimensión de dichos tableros, de
@;	modo que se calcula el promedio de disparos de cada partida necesarios para
@;	hundir todos los barcos; dicho promedio se almacena en la posición de
@;	memoria referenciada por el parámetro 'var_promedio'.
@;	Parámetros:
@;		R0: dim; tamaño de los tableros (dimxdim)
@; 		R1: tablero_barcos[]; dirección base del tablero de barcos
@; 		R2: tablero_disparos[]; dirección base del tablero de disparos
@;		R3: var_promedio (dir); dirección de la variable que albergará el pro-
@;								medio de disparos.
realizar_partidas:
		push {r1-r7,lr}
		
		mov r5,#NUM_PARTIDAS
				
		mov r6,#0
		
		.Lbuclecito:
		
			mov r7,r0  @; posem la dimeció a r7 ja que B_ini.... canvia r0.
			
			.Linicialitzar:
			ldr r1,=matriz_barcos		@; ja tenim la dimensió a r0 i el taulell de barcos a r1
			bl B_inicializa_barcos	@; crear distribució del vaixells, retorna  a r0 ,0 si es correcte sino un valor diferent
			
			cmp r0, #0
			beq .Linicialitzar
			
			mov r0,r7					@; retornem el valor de la dimencio a r0 / mira la primera ralla del .Lbucelecito 
			
			
			ldr r2,=matriz_disparos			
			bl i_disparos				@; ja tenim dim a r0 i matriz_disparos a r2
			
			mov r4,r1
			mov r1,r2 					@; passem la matriz_barcos a r4 i la matriz_disparos a r1
			
			bl jugar					@; ja tenim dim a r0 
			
			bl B_num_disparos     		@; cridem a la funció per obtindre el nombre de tirs  a r0
			
			
			add r6, r0				
			
			sub r5, r5,#1
			
			mov r0,r7					@; retornem el valor de la dimencio a r0 / mira la primera ralla del .Lbucelecito 
			cmp r5,#0
			
			bne .Lbuclecito
			
		mov r5,#NUM_PARTIDAS

		mov r0, r6			@; numerador= tirs totals
		mov r1, r5			@; denominador= num_partides
		
		bl div_mod			@; retorna la direcció del quocient a r2
	
		
		
		pop {r1-r7, pc}


.end
