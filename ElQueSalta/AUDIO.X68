;-----------------------------------------------------------
; AUDIO
;-----------------------------------------------------------


; ------------------------------------------------------------------------------
AUDINIT
; INITIALIZE SOUND.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

                MOVEM.L D0-D1/A0-A1,-(A7)
                CLR.B   D1
                LEA     .SNDLIST,A0
         
.LOOP           MOVE.L  (A0)+,D0
                BEQ     .DONE
            
                MOVE.L  D0,A1
          
                MOVE.B  #74,D0
                TRAP    #15
                ADDQ.B  #1,D1
          
                BRA     .LOOP
.DONE           MOVEM.L (A7)+,D0-D1/A0-A1
                RTS

.SNDJUMP    DC.B 'SOUND/JUMP.WAV',0
.SNDMOVE    DC.B 'SOUND/MOVE.WAV',0
.SNDMUS     DC.B 'SOUND/MUS.WAV',0
.SNDFALL    DC.B 'SOUND/FALL.WAV',0
.SNDLIST    DC.L .SNDJUMP,.SNDMOVE,.SNDMUS,.SNDFALL,0
    
; ------------------------------------------------------------------------------
AUDPLAY
; INITIALIZE PLAY SOUND.
; INPUT    : D7 SOUND
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
 
                MOVEM.W D0-D2,-(A7)
            
                MOVE.B  #75,D0
                MOVE.B  D7,D1
                MOVE.B  #1,D2
                TRAP    #15
            
                MOVEM.W (A7)+,D0-D2
    
                RTS




*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
