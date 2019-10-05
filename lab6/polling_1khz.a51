ORG 00H   
CLR P2.1            ; clears the pin1 of port2
MOV TMOD,#10H        ; set mode 1
L1: MOV TH1,#0FBH
      MOV TL1,#00H
      SETB TR1            ; timer 1 run control bit
      ACALL DELAY
      CPL P2.1            ; Complements the pin1 of port2
      SJMP L1   

DELAY: JNB TF1,DELAY
               CLR TF1        ; Clears timer 1 flag
               CLR TR1        ; Clears timer 1 run control bit
                RET
END