;-----------------------------------------------------------
; SYSTEM
;-----------------------------------------------------------


; ------------------------------------------------------------------------------
SYSINIT
; INITIALIZE SYSTEM.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVE.L  #SCRPLOT,($80+SCRUPTN*4)
            MOVE.L  #KBDUPD,($80+KBDUPTN*4)
            MOVE.L  #AUDPLAY,($80+AUDPLTN*4)
            MOVE.L  #SCRTIM,$64
            MOVE.L  #SCRTIM,$68
            MOVE.L  #SCRTIM,$6C
            MOVE.L  #SCRTIM,$70
            MOVE.L  #SCRTIM,$74
            MOVE.L  #SCRTIM,$78
            MOVE.L  #SCRTIM,$7C
            MOVE.L  #SCRTIM,$200
            MOVE.L  #SCRTIM,$204
            
            JSR SCRINIT
            JSR KBDINIT
            JSR AUDINIT
               
            ANDI.W  #$F8FF,SR
            RTS
    
; ------------------------------------------------------------------------------
SCRINIT
; INITI SCREEN. SET RES, SET WIND, CLEAR, BUFFER ON, WINDOW TIMER START
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D0-D3,-(A7)
               
            MOVE.W  #33,D0
            MOVE.L  #SCRWIDTH<<16|SCRHEIGH, D1
            TRAP    #15
            
            MOVE.L  #1,D1
            TRAP    #15
            
            MOVE.W  #11,D0
            MOVE.L  #$FF00,D1
            TRAP    #15
           
            MOVE.W  #92,D0
            MOVE.W  #17,D1
            TRAP    #15
            
            CLR.B   (SCRINTCT)
            CLR.W   CURRFPS
            
            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.B  #$81,D2
            MOVE.L  #1000/SCRFPS,D3
            TRAP    #15
           
            MOVEM.W (A7)+,D0-D3
          
            RTS
            
; ------------------------------------------------------------------------------
SCRPLOT
; UPDATE DOUBLE BUFFER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D0/D1,-(A7)
            MOVE.W #94,D0
            TRAP #15
            
            MOVE.W #11,D0
            MOVE.W #$FF00,D1
            TRAP #15
            MOVEM.W (A7)+,D0/D1
            
            RTS

; ------------------------------------------------------------------------------
SCRTIM
; TIMED INTERRUPT SERVICE ROUTINE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
           
            ADDQ.B  #1,(SCRINTCT)
            RTE
            
; ------------------------------------------------------------------------------
KBDINIT
; INIT KEYBOARD
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.B   (KBDVAL)
            CLR.B   (KBDEDGE)
            RTS
            
; ------------------------------------------------------------------------------
KBDUPD
; READ KEYBOARD
; INPUT    : NONE   7     6 5     4 3 2 1 0
; OUTPUT   : NONE   SPACE Q SHIFT E W A S D
; MODIFIES : NONE
; ------------------------------------------------------------------------------
         
            MOVEM.L D0-D3,-(A7)
          
            MOVE.B  #19,D0
            MOVE.L  #KBDSPACE<<24|KBDQ<<16|KBDSHIFT<<8|KBDE,D1
            TRAP    #15
            JSR     .PACK
            
            MOVE.L  #KBDW<<24|KBDA<<16|KBDS<<8|KBDD,D1
            TRAP    #15
            JSR     .PACK
            MOVE.B  (KBDVAL),D0
            NOT.B   D0
            AND.B   D2,D0
            MOVE.B  D0,(KBDEDGE)
            MOVE.B  D2,(KBDVAL)
            
            MOVEM.L (A7)+,D0-D3
            
            RTS
            
.PACK       MOVE.W  #3,D3
.LOOP       LSL.L   #8,D1
            ROXL.B  #1,D2
            DBRA.W  D3,.LOOP
            RTS
; ------------------------------------------------------------------------------
CLICKUPD
; READ KEYBOARD
; INPUT    : NONE
; OUTPUT   : D1 = $0001 SI CLICK ES TRUE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR     D1
            MOVE.W  #61, D0
            TRAP    #15
            CMP     #0,D0
            BEQ     .DONE
            MOVE.W  D1,D0  ;X
            LSR.L   #8,D1
            LSR.L   #8,D1 ;Y
            CMP     #83,D0 ;X IZQ
            BLT     .DONE
            CMP     #548,D0 ;X DER
            BGT     .DONE     ;COMPRUEBA SI COINCIDE HORIZONTALENTE
        
            CMP     #30,D1 ;Y ARRIBA
            BLT     .DONE
            CMP     #170,D1 ;Y ABAJO
            BGT     .DONE   ;COMPRUEBA SI COINCIDE VERTICALMENTE
        
            CLR.L   D1
            MOVE.W  #1,D1
.DONE   
            RTS
































*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
