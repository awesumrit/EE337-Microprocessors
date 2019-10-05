Org 0h
ljmp main;
Org 100h
main:
MOV R2, 60h;most significant of first number
MOV R3, 61h;least significant of first number
MOV R4, 70h;most significant of first number
MOV R5, 71h;least significant of first number
MOV A, R3;
ADD A, R5;
MOV 64h, A;
MOV A, R2;
ADDC A, R4;
MOV 63h,A;
MOV R6, #0h;
JNC there0;
INC R6;
there0:
MOV A, R2;
RLC A;
JNC there1;
INC R6;
there1:
MOV A, R4;
RLC A;
JNC there2;
INC R6;
there2:
MOV A, R6;
ANL A, #00000001b;
MOV 62h, A;
halt: sjmp halt
end
