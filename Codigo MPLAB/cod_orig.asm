  		   LIST    p=16F84A ; PIC16F844 is the target processor

           #include "P16F84A.INC" ; Inclui cabeçalho
			
			;Espaço das variáveis
			num1	equ	  0x20 ;pode declarar variáveis em 0x21, 0x22 ...
	
;----------------------------------------------------------------------------------------------
;Não editar esta seção
;----------------------------------------------------------------------------------------------			
			;endereço de inicio do programa
			org     00 ;origem no endereço 0
			
setports    clrw                    ; Zero em W.
            movwf   PORTA           ; certifica que PORTA é zero antes de habilita-la.
            movwf   PORTB           ; certifica que PORTB é zero antes de habilita-la.
			
            
			bsf     STATUS,RP0      ; Seleciona o Banco 1 (banco do TRIS)
            
			;Setando entradas e saidas
			movlw	b'01100000'
			movwf	TRISB
			movlw	b'00000000'
			movwf	TRISA
            bcf		STATUS,RP0      ; Reseleciona o Banco 0 (banco do PORT).
			
			
;---------------------------------------------------------------------------------------------
;Desenvolver código a partir daqui
;---------------------------------------------------------------------------------------------			

;Estado Inicial			
inicial		clrf	PORTA 	;Apaga os leds da esquerda
			
			btfsc	PORTB,5 ;Verifica se a chave 'sensor' foi ligada
			call	passar  ;Se foi pressionado, vá para o estado passar
							;Senão						
			goto	inicial
			

passar		bsf		PORTA,0	;Liga apenas o led vermelho (conectado ao RA0)
			bsf		PORTA,1	;Liga apenas o led verde (conectado ao RA1)
			
			btfss	PORTB,5 ;checa se o botão do 'sensor' permanece ligado
			return			;se não permanece, retorne a subrotina de origem
			
			
			goto	passar
			
			
            END