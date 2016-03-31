  		   LIST    p=16F84A ; PIC16F844 is the target processor

           #include "P16F84A.INC" ; Inclui cabe�alho
			
			;Espa�o das vari�veis
			num_acc equ	  0x20 ;pode declarar vari�veis em 0x21, 0x22 ...
			
;----------------------------------------------------------------------------------------------
;N�o editar esta se��o
;----------------------------------------------------------------------------------------------			
			;endere�o de inicio do programa
			org     00 ;origem no endere�o 0
			
setports    clrw                    ; Zero em W.
            movwf   PORTA           ; certifica que PORTA � zero antes de habilita-la.
            movwf   PORTB           ; certifica que PORTB � zero antes de habilita-la.
			
            
			bsf     STATUS,RP0      ; Seleciona o Banco 1 (banco do TRIS)
            
			;Setando entradas e saidas
			movlw	b'01100000'
			movwf	TRISB
			movlw	b'00000000'
			movwf	TRISA
            bcf		STATUS,RP0      ; Reseleciona o Banco 0 (banco do PORT).
			
			
;---------------------------------------------------------------------------------------------
;Desenvolver c�digo a partir daqui
;---------------------------------------------------------------------------------------------			
		    clrf num_acc ;zera valor do contador
;Estado Inicial			
inicial		
			bsf		PORTA,0	;Liga apenas o led vermelho
			bcf		PORTA,1	;Desliga apenas o led verde

			btfsc	PORTB,5 ;Verifica se a chave 'sensor' foi ligada
			call	passar  ;Se foi pressionado, v� para o estado passar
			btfsc   PORTB,6 ;Verifica se a chave 'manutencao' foi ligada						
			call    manutencao

			goto	inicial
			
			

passar		bcf		PORTA,0	;Desliga apenas o led vermelho (conectado ao RA0)
			bsf		PORTA,1	;Liga apenas o led verde (conectado ao RA1)
			incf    num_acc ;incrementa 1 sempre que o bot�o � ligado
passar_loop			
			btfss	PORTB,5 ;checa se o bot�o do 'sensor' permanece ligado
			return			;se n�o permanece, retorne a subrotina de origem			

			goto	passar_loop




manutencao  bcf   PORTA,0
			bcf   PORTA,1 
manutencao_loop
			btfss PORTB,6
			return

			goto manutencao_loop 			
			


;---------------------------------------------------------------------------------------------			
;Fun��o para a compara��o da magnitude de dois n�meros
;---------------------------------------------------------------------------------------------
;quando retornar da fun��o cmp, o registrador w ter� o valor:
;
;w=0 (quando num_acc for menor ou igual a 10)
;ou
;w=1 (quando num_acc for maior que 10)

cmp
			movlw D'10'
   			subwf num_acc,0
   			btfsc STATUS,Z
   			goto  menor_igual
   			btfsc STATUS,C
   			goto  maior
   			;se chegar aqui 'num_acc' � menor que 10
   			;retlw 0
menor_igual
   			retlw 0 ;retorna da fun��o com o w_reg com valor 0

maior
   			retlw 1 ;retorna da fun��o com o w_reg com valor 1
			
			
            END