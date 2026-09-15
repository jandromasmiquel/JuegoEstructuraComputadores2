; -----------------------------------------------------------------------------
IMGSEL     
; SELECTS A PICTURE
; INPUT    -D1.W QUE IMAGEN ES
;           D5.W X OFFSET
;           D6.W Y OFFSET
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A0-A1,-(A7)
            
            LEA.L       GFXLST,A0
            ROL.W       #2,D1
            MOVE.L      (A0,D1.W),A1
            ROR.W       #2,D1
                            
DRPIC
; DRAWS A PICTURE
; INPUT    - A1 POINTER TO THE PICTURE
;            D5.W X OFFSET
;            D6.W Y OFFSET
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
DRWPIC      
.LOOP       MOVE.W  (A1)+,D0                ; COMMAND ID
            BEQ     .END
            LEA     .JMPTBL,A0
            ROL.W   #2,D0                   ; TIMES 4 SINCE WE ACCESS LONG
            MOVE.L  (A0,D0.W),A0            ; GET THE JUMP ADDRESS
            ROR.W   #2,D0                   ; RESTORE D0
            ADD.W   #79,D0                  ; CREATE THE TRAP CODE
            JMP     (A0)                    ; JUMP!
.END        MOVEM.L (A7)+,D0-D4/A0-A1
            RTS
.JMPTBL     DC.L    .LOOP                   ; 00 PASS
            DC.L    .D1L                    ; 01 SET PEN
            DC.L    .D1L                    ; 02 SET FILL
            DC.L    .D1D2W                  ; 03 DRAW PIXEL
            DC.L    .D1L2                   ; 04 SET PEN AND FILL
            DC.L    .D1D4W                  ; 05 DRAW LINE FULL SPECS
            DC.L    .D1D2W                  ; 06 DRAW LINE POLYLINE VERSION
            DC.L    .D1D2W                  ; 07 MOVE TO
            DC.L    .D1D4W                  ; 08 DRAW FILLED RECTANGLE
            DC.L    .D1D4W                  ; 09 DRAW FILLED ELLIPSE
            DC.L    .D1D2W                  ; 10 FLOOD FILL
            DC.L    .D1D4W                  ; 11 DRAW UNFILLED RECTANGLE
            DC.L    .D1D4W                  ; 12 DRAW UNFILLED ELLIPSE
            DC.L    .D1W                    ; 13 SET DRAWING MODE
            DC.L    .D1W                    ; 14 SET PEN WIDTH
.D1W        MOVE.W  (A1)+,D1                ; GET WORD
            TRAP    #15
            JMP     .LOOP
.D1L        MOVE.L  (A1)+,D1                ; GET LONG
            TRAP    #15
            JMP     .LOOP
.D1L2       MOVE.L  (A1)+,D1                ; GET LONG AND DO SET PEN AND FILL
            MOVE.B  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            JMP     .LOOP
.D1D2W      MOVEM.W (A1)+,D1-D2             ; GET 2 WORDS
            ADD.W   D5,D1
            ADD.W   D6,D2
            TRAP    #15
            JMP     .LOOP
.D1D4W      MOVEM.W (A1)+,D1-D4             ; GET 4 WORDS
            ADD.W   D5,D1
            ADD.W   D6,D2
            ADD.W   D5,D3
            ADD.W   D6,D4
            TRAP    #15
            JMP     .LOOP
            
            
            




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
