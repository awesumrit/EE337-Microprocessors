;--upon wake-up go to main, avoid using
;memory allocated to Interrupt Vector Table
ORG 0000H
LJMP MAIN ;by-pass interrupt vector table
;
;--ISR for timer 0 to generate square wave
ORG 000BH ;Timer 0 interrupt vector table
	CPL P3.2 ;toggle P2.1 pin
	RETI ;return from ISR

;--The main program for initialization
ORG 0030H ;after vector table space
MAIN: MOV TMOD,#34H        ; set mode 1
	  MOV TH0,#0FeH
      MOV TL0,#00H
	MOV IE,#82H ;IE=10000010 (bin) enable
	;Timer 0
	SETB TR0;Start Timer 0

here: sjmp here
END