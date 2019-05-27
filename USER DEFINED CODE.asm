DATA SEGMENT                    ;start of the data segment
    BCD_IVALUE DB 56H           ;initialisation of the value
    BIN_OVALUE DB ?             ;space is reserved for the result
    BCD_OVALUE DB ?             ;space is reserved for the result
    BIN_IVALUE DB 0AH           ;iniialisation of the value
    DATA ENDS                   ;data segment ends
                                
CODE SEGMENT                    ;start of the code segment
    ASSUME CS:CODE,DS:DATA      
    START:  MOV BX,DATA         ;initialise the data segment
            MOV DS,BX           
                                
            MOV AL,BCD_IVALUE   ;move the value of bcd_ivalue in al
            CALL BCDTOBIN       ;call the procedure bcdtobin
            MOV BIN_OVALUE,AL   ;result is stored in the data segment
                                
            MOV AL,BIN_IVALUE   ;move the value of bin_ivalue in al
            CALL BINTOBCD       ;call the procedure bintobcd
            MOV BCD_OVALUE,AL   ;result is stored in the data segment
                                
            NOP                 ;no operation
            HLT                 ;halt the processor
                                
            BCDTOBIN PROC NEAR  ;declaration of the procedure bcdtobin
                MOV BL,AL       ;move the value store in al to bl
                AND BL,0FH      ;perform and operation
                AND AL,0F0H     ;perform and operation
                MOV CL,04D      ;move the value of 04d in cl
                ROR AL,CL       ;rotate right without carry
                MOV BH,0AH      ;move the value of 0ah in bh
                MUL BH          ;multiply al with bh and then store the result in ax
                ADD AL,BL       ;add the values stored in al and bl and then store the result in al
                MOV BL,AL       ;move the value stored in al to bl
                RET             
                BCDTOBIN ENDP   ;end of procedure bcdtobin
                                
            BINTOBCD PROC NEAR  ;declaration of the procedure bintobcd
                MOV DL,0AH      ;move the value of 0ah in dl
                DIV DL          ;divides al and dl
                ROR AL,4        ;rotate right without carry
                ADD AL,AH       ;add the values stored in al and ah and then store the result in al
                RET             
                BINTOBCD ENDP   ;end of procedure bintobcd
            CODE ENDS           ;code segment ends
END START                       
RET                             