  		   LIST    p=16F84A ; PIC16F844 is the target processor

           #include "P16F84A.INC" ; Inclui cabeçalho
			
			;Espaço das variáveis
			num_acc equ	  0x20 ;pode declarar variáveis em 0x21, 0x22 ...
			delayl  equ   0x30
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
		    clrf num_acc ;zera valor do contador
;Estado Inicial			
inicial		
			bsf		PORTA,0	;Liga apenas o led vermelho
			bcf		PORTA,1	;Desliga apenas o led verde

			btfsc	PORTB,5 ;Verifica se a chave 'sensor' foi ligada
			call	passar  ;Se foi pressionado, vá para o estado passar
			btfsc   PORTB,6 ;Verifica se a chave 'manutencao' foi ligada						
			call    manutencao

			goto	inicial
			

passar		bcf		PORTA,0	;Desliga apenas o led vermelho (conectado ao RA0)
			bsf		PORTA,1	;Liga apenas o led verde (conectado ao RA1)
			incf    num_acc ;incrementa 1 sempre que o botão é ligado

passar_loop			
			btfss	PORTB,5 ;checa se o botão do 'sensor' permanece ligado
			return			;se não permanece, retorne a subrotina de origem			

			goto	passar_loop


manutencao  bcf   PORTA,0; Desliga led vermelho
			bcf   PORTA,1; Desliga led verde
			call cmp

manutencao_loop
			btfss PORTB,6; Checa se o botão do 'manutenção' permanece ligado
			return; Verificação da variavel 0x20

			goto manutencao_loop

apagaLed	bcf   PORTA,0;liga led vermelho
			bcf   PORTA,1;liga led verde
			btfss PORTB,6
			goto  inicial
				

apagaLed_loop
			btfss PORTB,6;checa se o botão do 'manutenção' permanece ligado
			return; Verificação da variavel 0x20
			
			goto apagaLed_loop

acendeLed	bsf   PORTA,0;liga led vermelho
			bsf   PORTA,1;liga led verde

acendeLed_loop
			btfss PORTB,6; Checa se o botão do 'manutenção' permanece ligado
			call apagaLed;verificação da variavel 0x20
		
			goto acendeLed_loop




;---------------------------------------------------------------------------------------------			
;Função para a comparação da magnitude de dois números
;---------------------------------------------------------------------------------------------
;quando retornar da função cmp, o registrador w terá o valor:
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
   			;se chegar aqui 'num_acc' é menor que 10
   			;retlw 0
menor_igual
			call apagaLed
   			retlw 0 ;retorna da função com o w_reg com valor 0

maior
			call acendeLed
   			retlw 1 ;retorna da função com o w_reg com valor 1

			
            END