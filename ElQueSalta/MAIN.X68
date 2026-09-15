            ORG    $1000
        
        INCLUDE "MAPDATA.X68"
        INCLUDE "CONST.X68"
        INCLUDE "SYSCONST.X68"
        INCLUDE "GFXDATA.X68"
        
        INCLUDE "MAP.X68"       
        INCLUDE "SYSTEM.X68"
        INCLUDE "STATES.X68"
        INCLUDE "AUDIO.X68" 
        INCLUDE "PLAYER.X68"
        INCLUDE "GFX.X68"

START:

; --- INICIALIZACION ---

            ORI.W   #$0700,SR  ;MODO SUPERVISOR
            JSR     SYSINIT
            JSR     STATINIT
            JSR     STATPLOT
                    
.LOOP
    ; --- UPDATE ---
    
            JSR STATUPD       
    
    ; --- SYNC ---
      
            MOVE.W  #200,D0
.WINT       TST.B   (SCRINTCT)
            BNE     .SYNC_OK
            SUBQ.W  #1,D0
            BNE     .WINT
            MOVE.B  #1,(SCRINTCT)

.SYNC_OK    MOVE.W  #SCRFPS,D0
            MOVE.B  (SCRINTCT),D1
            AND.W   #$00FF,D1
            DIVS.W  D1,D0
            
            MOVE.W  D0,CURRFPS
            CLR.B   (SCRINTCT)
    
    ; --- PLOT --- 
    
            JSR STATPLOT
        
            BRA     .LOOP
                 
            SIMHALT    

        INCLUDE "VARS.X68"
        INCLUDE "SYSVARS.X68"

    END    START
       









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
