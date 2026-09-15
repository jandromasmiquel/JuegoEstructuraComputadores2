;--------------------------------------------------------------------
; STATES
;--------------------------------------------------------------------

; -----------------------------------------------------------------------------
STATINIT
; INITALIZES THE STATES
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVE.B      #0,STATETN
                      
            MOVE.L      #INITPLOT,($80+INITPLTN*4)
            MOVE.L      #GAMEPLOT,($80+GAMEPLTN*4)
            MOVE.L      #PAUPLOT,($80+PAUPLTN*4)
            MOVE.L      #ENDGPLOT,($80+ENDTN*4)

        
            JSR         PLAYERINIT
            JSR         MAPINIT

            RTS
    
; -----------------------------------------------------------------------------
STATUPD
; UPDATES BASED ON THE STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            JSR     KBDUPD
        
            CMP     #0,STATETN
            BEQ     .INIT
            CMP     #1,STATETN
            BEQ     .GAME
            CMP     #3,STATETN
            BEQ     .ENDGAME
        
.INIT       JSR     CLICKUPD
            CMP     #1,D1
            BNE     .DONE
            MOVE.W  #1,STATETN
            BRA     .DONE
        
.GAME       BTST    #6,KBDVAL
            BEQ     .PASS
            MOVE.W  #2,STATETN
.PASS       JSR     MAPUPD
            JSR     PLAYERUPD
            JSR     ENDGAME
            CMP     #0,D0
            BEQ     .DONE
            MOVE.W  #3,STATETN 
            BRA     .DONE
.ENDGAME    BTST    #7,KBDVAL
            BEQ     .DONE
            BRA     .END          
.DONE       RTS
.END        MOVE.W  #9,D0   
            TRAP    #15
            
; -----------------------------------------------------------------------------
ENDGAME
; CHECKS IF HAS TO END THE GAME
; INPUT    - NONE
; OUTPUT   - D0 != 0 IF HAS TO END
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVE.L  (MAP),D0
            LSR.L   #2,D0
            CMP     #10,D0
            BNE     .NO
            CMP     #112,POSX
            BGT     .NO
            CMP     #80,POSY
            BGT     .NO
            MOVE.W  #1,D0
            RTS

.NO         MOVE.W  #0,D0
            RTS
        
; -----------------------------------------------------------------------------
STATPLOT
; PLOTS BASED ON THE STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------     

            CMP     #0,STATETN
            BNE     .GAME
            JSR     INITPLOT
            BRA     .DONE
.GAME       CMP     #2,STATETN
            BEQ     .PAUSE
            CMP     #3,STATETN
            BEQ     .ENDGAME
            JSR     GAMEPLOT
            BRA     .DONE
.PAUSE      JSR     PAUPLOT
            BRA     .DONE
.ENDGAME    JSR     ENDGPLOT
.DONE       JSR     FPSPLOT
            JSR     SCRPLOT
                    
            RTS
                
; -----------------------------------------------------------------------------
INITPLOT
; PLOTS INITIAL STAGE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
                
            MOVE.L  #81,D0
            MOVE.L  #$00000000,D1
            TRAP    #15
        
            MOVE.W  #95,D0
            LEA.L   .TXT1,A1
            MOVE.W  #200,D1
            MOVE.W  #400,D2
            TRAP    #15
                       
            MOVE.W  #6,D1
            MOVE.W  #86,D5
            MOVE.W  #20,D6
            JSR     IMGSEL
            
            MOVE.W  #4,D1
            MOVE.W  #320,D5
            MOVE.W  #240,D6
            JSR     IMGSEL
            
            MOVE.W  #2,D1
            MOVE.W  #320,D5
            MOVE.W  #272,D6
            JSR     IMGSEL
            MOVE.W  #352,D5
            JSR     IMGSEL
            MOVE.W  #288,D5
            JSR     IMGSEL
                
.DONE       RTS    
        
.TXT1   DC.B    'HAZ CLICK EN EL LOGO PARA INICIAR',0

; -----------------------------------------------------------------------------
GAMEPLOT
; PLOTS GAME STAGE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    
            JSR     MAPPLOT
            JSR     PLAYERPLOT
                
            RTS

; -----------------------------------------------------------------------------
PAUPLOT
; PLOTS PAUSE STAGE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVE.W  #6,D1
            MOVE.W  #86,D5
            MOVE.W  #20,D6
            JSR     IMGSEL
            
            MOVE.L  #81,D0
            MOVE.L  #$00000000,D1
            TRAP    #15
        
            MOVE.W  #95,D0
            LEA.L   .TXT2,A1
            MOVE.W  #180,D1
            MOVE.W  #220,D2
            TRAP    #15
        
            RTS    
        
.TXT2   DC.B    'EN PAUSA, HAZ CLICK PARA CONTINUAR',0
        DC.B    0
        
; -----------------------------------------------------------------------------
ENDGPLOT
; PLOTS ENDGAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVE.L  #81,D0
            MOVE.L  #$00000000,D1
            TRAP    #15
        
            MOVE.W  #95,D0
            LEA.L   .TXT3,A1
            MOVE.W  #200,D1
            MOVE.W  #400,D2
            TRAP    #15
            
            MOVE.W  #7,D1
            MOVE.W  #86,D5
            MOVE.W  #20,D6
            JSR     IMGSEL
                         
.DONE       RTS    
        
.TXT3   DC.B    'HAS GANADO, PULSA ESPACIO PARA CERRAR EL JUEGO',0
        DC.B    0
        
; -----------------------------------------------------------------------------
FPSPLOT
; PLOTS CURRENT AND TARGET FPS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            CMP     #240,(POSX)
            BGE     .LEFT
            
            MOVE.W  #11,D0
            MOVE.W  #$3A00,D1
            TRAP    #15

.LEFT      
            MOVE.L  #81,D0
            MOVE.L  #$00000000,D1
            TRAP    #15
                                  
            MOVE.W  #17,D0
            MOVE.W  #SCRFPS,D1
            LEA.L   .TXT4,A1
            TRAP    #15
            MOVE.W  (CURRFPS),D1
            LEA.L   .TXT5,A1
            TRAP    #15

           
.DONE       RTS
            
.TXT4   DC.B    'GOAL: ',0
.TXT5   DC.B    ' - ACTUAL:',0        















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
