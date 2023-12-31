		PROCESSOR P16F887
		INCLUDE<P16F887.INC>
		
		__CONFIG _CONFIG1, (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOR_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF & _DEBUG_OFF)
		__CONFIG _CONFIG2, (_WRT_OFF & _BOR40V)
	
		ORG			0x00		

UNI 	EQU			0x20
DEC 	EQU			0x21
CEN		EQU			0x22
MIL		EQU			0x23
CON		EQU			0x24
AD		EQU			0x25
TME		EQU			0x26		
TCE		EQU			0x27	
TTC		EQU			0x28		
TTD		EQU			0x29	
C51		EQU			0x2A
C05		EQU			0x2B
X40		EQU			0x2C


		BANKSEL		ANSEL
		MOVLW		0x20
		MOVWF		ANSEL
		CLRF		ANSELH
		
		BANKSEL		TRISA 
		CLRF		TRISA
		CLRF		TRISB
		MOVLW		0x01		; CARGA W EN ALTO
		MOVWF		TRISE	
		CLRF		TRISC	
		CLRF		TRISD
		CLRF 		ADCON1		
		MOVLW		0xD4

		MOVWF		OPTION_REG
		BANKSEL		PORTA
		MOVLW		0xD5
		MOVWF		ADCON0
		
C_P		CLRF		MIL
		CLRF		CEN
		CLRF		DEC
		CLRF		UNI

		BSF			ADCON0,GO_DONE
ADC		BTFSC		ADCON0,GO_DONE
		GOTO		ADC	
		MOVF		ADRESH,W
		

		MOVLW		.25			; SE CARGA UN VALOR EN BINARIO
		MOVWF		AD
		CALL		RCX
		MOVWF		CEN	

		MOVF		TTC,W		; COPIA ADRESS A W
		CALL		RDX		
		MOVWF		DEC
	
		MOVF		TTC,W		; COPIA ADRESS A W
		CALL		RUX		
		MOVWF		UNI
		
		CALL		VALDX
		NOP

CX40	MOVF		UNI,W
		CALL		T7S
		MOVWF		PORTB
		MOVLW		0x01
		MOVWF		PORTC
		CALL		R625

		MOVF		DEC,W
		CALL		T7S
		MOVWF		PORTB
		MOVLW		0x02
		MOVWF		PORTC
		CALL		R625	

		MOVF		CEN,W
		CALL		T7S
		MOVWF		PORTB
		MOVLW		0x04
		MOVWF		PORTC
		CALL		R625

		MOVF		MIL,W
		CALL		T7S
		MOVWF		PORTB
		MOVLW		0x08
		MOVWF		PORTC
		CALL		R625

		DECFSZ		X40,F
		GOTO		CX40
		GOTO 		C_P
	
RCX		MOVWF		CENT		;	CENTENAS
		CLRF		C51
		CLRF		TTC	
R51		MOVLW		.51	
		SUBWF		TCE,W		
		BTFSS		STATUS,C	
		GOTO		R751
		MOVWF		ICE
		MOVWF		TTC
		INCF		C51,F
		GOTO		R51
R751	MOVF		C51,F
		BTFSS		STATUS
		GOTO		X751
		MOVF		TCE,W
		MOVWF		TTC
X751	MOVF		C51,W
		RETURN

RDX		MOVWF		TDE			; DECENAS
		CLRF		C05
		CLRF		TTD	
R05		MOVLW		.51	
		SUBWF		TDE,W		
		BTFSS		STATUS,C	
		GOTO		R705
		MOVWF		TDE
		MOVWF		TTD
		INCF		C51,F
		GOTO		R51
R705	MOVF		C51,F
		BTFSC		STATUS,Z
		GOTO		C05CP
		GOTO		C05CN

C05CP	MOVF		TDE,W
		MOVWF		TTD
		GOTO		XRF05
		
C05CN	MOVF		TTD,F
		BTFSS		STATUS,Z
		GOTO		C05X
		MOVLW		0x05
		MOVWF		TTD
C05X	MOVLW		0x0A
		SUBWF		C05,W

		BTFSC		STATUS,Z
		GOTO		ERR
		MOVLW		0.20	
		SUBWF		TTC,W
		BTFSC		STATUS,Z 
		GOTO		ERR	
		MOVLW		.25
		SUBWF		TTC,W
		BTFSC		STATUS,Z
		GOTO		ERR
		MOVLW		0.30	
		SUBWF		TTC,W
		BTFSC		STATUS,Z
		GOTO		ERR
		MOVLW		0.35	
		SUBWF		TTC,W
		BTFSC		STATUS,Z
		GOTO		ERR
		MOVLW		0.40	
		SUBWF		TTC,W
		BTFSC		STATUS,Z
		GOTO		ERR
		MOVLW		0.45	
		SUBWF		TTC,W
		RETURN 		
ERR		DECF		DX,F
		RETURN
	
TC7S	ADDWF	PCL,F
		RETLW	0x3F
		RETLW	0x06
		RETLW	0x5B
		RETLW	0x4F
		RETLW	0x66
		RETLW	0x6D
		RETLW	0x7D
		RETLW	0x07
		RETLW	0x7F
		RETLW	0x67



R625	MOVLW	0xBE
		MOVWF	TMR0
ST0		BTFSS	INTCON,T0IF
		GOTO	ET0
		BCF		INTCON,T0IF
		RETURN


		END