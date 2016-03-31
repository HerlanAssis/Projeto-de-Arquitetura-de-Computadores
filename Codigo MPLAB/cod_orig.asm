  		   LIST    p=16F84A ; PIC16F844 is the target processor

           #include "P16F84A.INC" ; Inclui cabe�alho
			
			;Espa�o das vari�veis
			num1	equ	  0x20 ;pode declarar vari�veis em 0x21, 0x22 ...
	
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

;Estado Inicial			
inicial		clrf	PORTA 	;Apaga os leds da esquerda
			
			btfsc	PORTB,5 ;Verifica se a chave 'sensor' foi ligada
			call	passar  ;Se foi pressionado, v� para o estado passar
							;Sen�o						
			goto	inicial
			

passar		bsf		PORTA,0	;Liga apenas o led vermelho (conectado ao RA0)
			bsf		PORTA,1	;Liga apenas o led verde (conectado ao RA1)
			
			btfss	PORTB,5 ;checa se o bot�o do 'sensor' permanece ligado
			return			;se n�o permanece, retorne a subrotina de origem
			
			
			goto	passar
			
			
            END