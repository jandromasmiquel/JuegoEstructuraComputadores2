; =============================================================================
; MAP
; =============================================================================

; -----------------------------------------------------------------------------
MAPINIT
; INITALIZES THE MAP
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        CLR.L MAP
        RTS

; -----------------------------------------------------------------------------
MAPUPD
; UPDATES THE MAP IF PLAYER CHANGES SCREEN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        MOVEM.L D0,-(A7)
        
        MOVE.W  POSY,D0
        CMP     #SCRHEIGH,D0
        BGT     .BAJA
        CMP     #0,D0
        BGE     .DONE
        ADD.L   #4,MAP
        MOVE.W  #SCRHEIGH,D0
        MOVE.W  D0,POSY
        BRA     .DONE
.BAJA   SUB.L   #4,MAP
        MOVE.W  #0,POSY
.DONE   
        MOVEM.L (A7)+,D0
        RTS

CBRCK   DS.W    1 

; -----------------------------------------------------------------------------
MAPPLOT
; PLOTS THE MAP
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        MOVEM.L D0-D7/A0-A1,-(A7)
        JSR     MAPLOAD
        
        CMP.L   #20,(MAP)
        BGT     .HARD
        CMP.L   #4,(MAP)
        BGT     .MEDIUM
        MOVE.W  #1,CBRCK
        BRA     .START
.HARD   MOVE.W  #3,CBRCK
        BRA     .START
.MEDIUM MOVE.W  #2,CBRCK
.START  CLR.W   D6       
        MOVE.W  #14,D2
.LOOP2  MOVE.W  #19,D3
        CLR.W   D5      
.LOOP   MOVE.W  (A0)+,D4

        CMP.W   #1,D4
        BEQ     .BRICK
        MOVE.W  #0,D1
        JSR     IMGSEL
        BRA     .NEXT
.BRICK  MOVE.W  (CBRCK),D1
        JSR     IMGSEL
      
.NEXT   
        ADD.W   #32,D5
        DBRA    D3,.LOOP
        ADD.W   #32,D6 
        DBRA    D2,.LOOP2
        
        MOVEM.L (A7)+,D0-D7/A0-A1
        RTS
        
; -----------------------------------------------------------------------------
MAPLOAD
; LOADS MAP IN A0
; INPUT    - NONE
; OUTPUT   - A0 - MAP
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        MOVEM.L A1,-(A7)
    
        LEA.L   MAPS,A1
        ADD.L   MAP,A1
        MOVE.L  (A1),A0
        
        MOVEM.L (A7)+,A1
        RTS















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
