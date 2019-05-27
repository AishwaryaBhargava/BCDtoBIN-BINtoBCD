INCLUDE 'EMU8086.INC'

ORG 100H

PRINTN '$ CALCULATOR FOR BASE CONVERSION $'

PRINTN '$ PRESS 1 FOR BCD TO BINARY CONVERSION AND PRESS 2 FOR BINARY TO BCD CONVERION $'
MOV AH,1H
INT 21H                                  ;take input from user according to their choices
SUB AL,30H
PRINTN '$'

CMP AL,1H
JZ LABEL1                                ;go to label1 if user opted the first choice

CMP AL,2H
JZ LABEL2                                ;go to label2 if user opted the second choice

RET                                      ;get out of the program if the user entered any other no.

LABEL1: PRINTN '$ BCD TO BINARY CONVERSION $'
        MOV CX,02H
        L1: MOV AH,01H
            INT 21H
            MOV AH,0
            SUB AL,30H
            PUSH AX
            LOOP L1                      ;takes the input from the user
        CALL BINCONV                     ;calls the procedure binconv
        RET

LABEL2: PRINTN '$ BINARY TO BCD CONVERSION $'
        MOV CX,02H
        L2: MOV AH,01H
            INT 21H
            MOV AH,0
            SUB AL,30H
            PUSH AX
            LOOP L2                      ;takes the input from the user
        CALL BCDCONV                     ;calls the procedure bcdconv
        RET

BINCONV PROC NEAR                        ;declaration of the procedure binconv
    BIN_VALUE DW ?                       ;variable is declared
    MOV BX,AX                            ;move the value stored in ax to bx
    MOV CX,0H                            ;move the value of 0h in cx
    CONTINUE1:  CMP BX,0H                ;compares the value in bx with the value of 0h and accordingly sets the flags
                JZ ENDPROG1              ;jumps to the label endprog1 if zf=1
                MOV AL,BL                ;move the value stored in bl to al
                SUB AL,01H               ;subtract 1h from al and then store the result in al
                DAS                      ;decimal adjust after subtraction
                LAHF                     ;loads ah from lower byte of flag
                AND AH,11101111B         ;performs and function in order to reset auxillary flag
                SAHF                     ;store ah to lower byte of flag register
                MOV BL,AL                ;move the value stored in al to bl 
                MOV AL,BH                ;move the value stored in bh to al
                SBB AL,00H               ;subtraction with borrow
                DAS                      ;decimal adjust after subtraction
                MOV BH,AL                ;move the value stored in al to bh
                INC CX                   ;increase the value stored in cx by 1
                JMP CONTINUE1            ;unconditional jump to the label continue1
    ENDPROG1:   MOV BIN_VALUE,CX         ;move the value stored in cx to the variable which we decalred earlier
    MOV AH,4CH                           
    INT 21H                              ;termination of program
    RET                                  
BINCONV ENDP                             ;end of procedure

BCDCONV PROC NEAR                        ;declaration of the procedure bcdconv
    BCD_VALUE DW ?                       ;variable is declared
    MOV BX,AX                            ;move the value stored in ax to bx
    MOV AX,0H                            ;move the value of 0h in ax
    MOV CX,0H                            ;move the value of 0h in cx
    CONTINUE2:  CMP BX,0H                ;compares the value in bx with the value of 0h and accordingly sets the flags
                JZ ENDPROG2              ;jumps to the endprog2 if zf=1
                DEC BX                   ;decrements the value stored in bx by 1
                MOV AL,CL                ;move the value stored in cl to al
                ADD AL,01H               ;adds the value stored in al and 1h and then stores the result in al
                DAA                      ;decimal adjust after addition
                LAHF                     ;loads ah from lower byte of flag
                AND AH,11101111B         ;performs and function in order to reset auxillary flag
                SAHF                     ;store ah to lower byte of flag register
                MOV CL,AL                ;move the value stored in al to cl
                MOV AL,CH                ;move the value stored in ch to al
                ADC AL,00H               ;addition with carry
                DAA                      ;decimal adjust after addition
                MOV CH,AL                ;move the value stored in al to ch
                JMP CONTINUE2            ;unconditional jump to the label continue2
    ENDPROG2:   MOV BCD_VALUE,CX         ;move the value stored in cx to the variable which we decalred earlier
    MOV AH,4CH                           
    INT 21H                              ;termination of program
    RET                                  
BCDCONV ENDP                             ;end of procedure

RET