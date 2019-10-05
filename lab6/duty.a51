org 00h
	
ljmp main
org  50h
duty20: setb p3.2
	acall delay
	acall delay
	
	clr p3.2
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay

	sjmp duty20
	RET
	
duty30: setb p3.2
	acall delay
	acall delay
	acall delay
	clr p3.2
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay

	sjmp duty30
	RET
	
duty40: setb p3.2
	acall delay
	acall delay
	acall delay
	acall delay
	clr p3.2
	
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay

	sjmp duty40
	RET

duty50: setb p3.2
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	clr p3.2
	
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay

	sjmp duty50
	RET

duty60: setb p3.2
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	clr p3.2	
	acall delay
	acall delay
	acall delay
	acall delay

	sjmp duty60
	RET
	
duty70: setb p3.2
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	clr p3.2	
	
	acall delay
	acall delay
	acall delay

	sjmp duty70
	RET

duty80: setb p3.2
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	clr p3.2	
	acall delay
	acall delay

	sjmp duty80
	RET
	
duty90: setb p3.2
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	acall delay
	clr p3.2	
	acall delay

	sjmp duty90
	RET
	
	
delay:
	mov tmod,#10h ;timer 1,mode1

	back: mov tl1,#-0c0h
	mov th1,#-01h
	setb tr1
	again: jnb tf1,again
	clr tr1
	clr tf1
	ret
	

main:
	
	mov a, p1

	jnb acc.0, bit0
	jb acc.0, bit1
	
		bit1: jnb acc.1, bit01
				jb acc.1, bit11
				
			bit11: jnb acc.2, dut50
					jb acc.2, dut90	
					
			bit01: jnb acc.2, dut30
					jb acc.2, dut70
				
		bit0: jnb acc.1, bit00
			  jb acc.1, bit10
			  
			bit10: jnb acc.2, dut40
					jb acc.2, dut80
					
			bit00: jnb acc.2, dut20
					jb acc.2, dut60
					
	dut20: lcall duty20
			sjmp main
	dut30: lcall duty30
			sjmp main					
	dut40: lcall duty40
			sjmp main		
	dut50: lcall duty50
			sjmp main
	dut60: lcall duty60
			sjmp main
	dut70: lcall duty70
			sjmp main
	dut80: lcall duty80
			sjmp main
	dut90: lcall duty90
			sjmp main


end