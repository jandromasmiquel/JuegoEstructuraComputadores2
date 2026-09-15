; =============================================================================
; PLAYER
; =============================================================================


; -----------------------------------------------------------------------------
PLAYERINIT
; INITALIZES THE PALYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------    
 
            MOVE.W  #48,POSX
            MOVE.W  #400,POSY
            MOVE.W  #0,PLSTATE
            MOVE.W  #1,VERT
            MOVE.W  #0,FALLCONT
            MOVE.W  #0,SHIFT
            MOVE.W  #1,JMPSTATE
            RTS 
        
; -----------------------------------------------------------------------------
PLAYERUPD
; UPDATES THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            JSR     MOVEVERT
            
            CMP     #1,SHIFT
            BEQ     .DONE
            BTST    #0,KBDVAL
            BNE     .NL 
            BTST    #2,KBDVAL   ;LEFT
            BNE     .L
            BRA     .DONE   ;RIGHT AND LEFT
.NL         BTST    #2,KBDVAL
            BNE     .DONE
            JSR     MOVRIGHT    ;RIGHT AND NO LEFT
            BRA     .DONE
.L          JSR     MOVELEFT

.DONE       RTS

; -----------------------------------------------------------------------------
MOVEVERT
; PLAYER MOVE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
           
            CMP     #1,SHIFT
            BEQ     .SHIFTING
            CMP     #0,JMPSTATE
            BNE     .MOVING
            JSR     CANJUMP     ;MIRA SI DEBAJO HAY SUELO
            CMP     #1,D7
            BNE     .MOVING
            BTST    #3,KBDVAL
            BEQ     .DONE
            MOVE.W  #1,SHIFT
            ADD.W   #5,JMPSTATE     ;SALTO MINIMO      
            BRA     .DONE
            
.SHIFTING   BTST    #3,KBDVAL
            BEQ     .END
            ADD.W   #1,JMPSTATE
            CMP     #MAXJUMP,JMPSTATE
            BEQ     .END          
            BRA     .DONE
            
.END        MOVE.W  #0,SHIFT
            MOVE.W  #0,VERT
            MOVE.W  #0,D7
            JSR     AUDPLAY
            BRA     .DONE 
       
.MOVING     CMP     #1,VERT             ;YA HA SALTADO
            BEQ     .DOWN
            JSR     MOVEUP
            BRA     .DONE
.DOWN       JSR     MOVEDOWN
.DONE       RTS

; -----------------------------------------------------------------------------
MOVELEFT
; PLAYER MOVE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        
            MOVE.W  #0,PLSTATE
.RETRY      MOVE.W  POSX,D1
            SUB.W   #SPEED,D1
            SUB.W   #15,D1
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            SUB.W   #15,D2
            LSR.W   #5,D2  
            
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .NEXT
            ADD.W   #1,POSX
            MOVE.W  #1,PLSTATE
            BRA     .RETRY  
      
.NEXT       CMP     #1,PLSTATE
            BEQ     .DONE
            MOVE.W  POSX,D1
            SUB.W   #SPEED,D1
            SUB.W   #15,D1
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            ADD.W   #15,D2
            LSR.W   #5,D2
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .DONE
            ADD.W   #1,POSX
            BRA     .NEXT
        
.DONE       SUB.W   #SPEED,POSX
            RTS
        
; -----------------------------------------------------------------------------
MOVRIGHT
; PLAYER MOVE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        
        
            MOVE.W  #0,PLSTATE
.RETRY      MOVE.W  POSX,D1
            ADD.W   #SPEED,D1
            ADD.W   #16,D1
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            SUB.W   #15,D2
            LSR.W   #5,D2  
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .NEXT
            SUB.W   #1,POSX
            MOVE.W  #1,PLSTATE
            BRA     .RETRY  
      
.NEXT       CMP     #1,PLSTATE
            BEQ     .DONE
            MOVE.W  POSX,D1
            ADD.W   #SPEED,D1
            ADD.W   #16,D1
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            ADD.W   #15,D2
            LSR.W   #5,D2
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .DONE
            SUB.W   #1,POSX
            BRA     .NEXT
        
.DONE       ADD.W   #SPEED,POSX
            RTS
; -----------------------------------------------------------------------------
MOVEUP
; PLAYER MOVE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------   
        
            MOVE.W  #0,PLSTATE
            JSR     PARABOLA        ;BAJA LA VELOCIDAD DE SUBIDA EN FUNCION DE JMPSTATE
.RETRY      MOVE.W  POSX,D1
            SUB.W   #15,D1
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            SUB.W   #16,D2
            SUB.W   D5,D2
            LSR.W   #5,D2  
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .NEXT
            MOVE.W  #1,JMPSTATE
            MOVE.W  #1,VERT
            ADD.W   #1,POSY
            MOVE.W  #1,PLSTATE
            BRA     .RETRY  
              
.NEXT       CMP     #1,PLSTATE
            BEQ     .DONE
            MOVE.W  POSX,D1
            ADD.W   #15,D1
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            SUB.W   #16,D2
            SUB.W   D5,D2
            LSR.W   #5,D2
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .DONE
            MOVE.W  #1,JMPSTATE
            MOVE.W  #1,VERT
            ADD.W   #1,POSY
            BRA     .NEXT
        
.DONE       SUB.W   #1,JMPSTATE
            CMP     #0,JMPSTATE
            BNE     .END
            MOVE.W  #1,JMPSTATE
            MOVE.W  #1,VERT
            SUB.W   #1,POSY
.END        SUB.W   D5,POSY        
            RTS
    
; -----------------------------------------------------------------------------
CANJUMP
; CHECKS IF HE CAN JUMP
; INPUT    - NONE
; OUTPUT   - D7 - 1 IF CAN 0 IF NOT
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR     D7
.RETRY      MOVE.W  POSX,D1
            SUB.W   #15,D1 
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            ADD.W   #17,D2
            LSR.W   #5,D2  
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .NEXT
            MOVE.W  #1,D7
            BRA     .DONE
      
.NEXT       MOVE.W  POSX,D1
            ADD.W   #15,D1 
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            ADD.W   #17,D2
            LSR.W   #5,D2  
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .DONE
            MOVE.W  #1,D7

.DONE       RTS

; -----------------------------------------------------------------------------
PARABOLA
; PLAYER MOVE
; INPUT    - NONE
; OUTPUT   - D5 - JUMP VALUE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        
            CMP     #24,JMPSTATE
            BLT     TRAM1
            MOVE.W  #7,D5
            BRA     STOP
TRAM1       CMP     #15,JMPSTATE
            BLT     TRAM2
            MOVE.W  #6,D5
            BRA     STOP   
TRAM2       CMP     #8,JMPSTATE
            BLT     TRAM3
            MOVE.W  #4,D5
            BRA     STOP   
TRAM3       CMP     #3,JMPSTATE
            BLT     TRAM4
            MOVE.W  #3,D5
            BRA     STOP   
TRAM4       MOVE.W  #2,D5
STOP        RTS
       
; -----------------------------------------------------------------------------
MOVEDOWN
; PLAYER MOVE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            CMP     #1,JMPSTATE
            BNE     .INITED
            MOVE.W  #4,FALLCONT       
.INITED     
            CMP     #4,FALLCONT
            BNE     .PASS
            ADD.W   #1,JMPSTATE
            MOVE.W  #0,FALLCONT            
.PASS       ADD.W   #1,FALLCONT
            MOVE.W  (JMPSTATE),D2
            MOVE.W  #0,PLSTATE               
.RETRY
            MOVE.W  POSX,D1
            SUB.W   #15,D1 
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            ADD.W   #16,D2
            ADD.W   (JMPSTATE),D2
            LSR.W   #5,D2  
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .NEXT
            SUB.W   #1,POSY
            MOVE.W  #1,PLSTATE    ;SI CHOCA REINICIA LA GRAVEDAD Y EL CONTADOR
            CMP     #10,JMPSTATE
            BLE     .NSND1
            MOVE.W  #3,D7
            JSR     AUDPLAY
.NSND1      MOVE.W  #0,JMPSTATE
            MOVE.W  #1,VERT
            BRA     .RETRY  
      
.NEXT       CMP     #1,PLSTATE
            BEQ     .DONE
            MOVE.W  POSX,D1
            ADD.W   #15,D1
            LSR.W   #5,D1
        
            MOVE.W  POSY,D2
            ADD.W   #16,D2
            ADD.W   (JMPSTATE),D2
            LSR.W   #5,D2
        
            JSR     MAPLOAD
            JSR     PREPTILE
            MOVE.W  (A0),D3
            CMP     #$01,D3
            BNE     .DONE
            SUB.W   #1,POSY ;SI CHOCA REINICIA LA GRAVEDAD Y EL CONTADOR
            CMP     #10,JMPSTATE
            BLE     .NSND2
            MOVE.W  #3,D7
            JSR     AUDPLAY
.NSND2      MOVE.W  #0,JMPSTATE
            MOVE.W  #1,VERT
            BRA     .NEXT
        
.DONE  
            MOVE.W  (JMPSTATE),D0
            ADD.W   D0,POSY
            MOVE.W  (POSY),D0
            BTST    #0,D0
            BNE     .NOAJUST
            ADD.W   #1,POSY
.NOAJUST    RTS
; -----------------------------------------------------------------------------
PREPTILE
; PREPARA EL TILE
; INPUT    - D1 POSX, D2 POSY, A0 MAP
; OUTPUT   - A0 TILE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        
        MOVEM.L D0-D4,-(A7)
        
        CLR.W   D3
        MOVE.W  #20,D4
        CMP     #0,D2
        BEQ     .ZERO
        SUB.W   #1,D2
.BUCLE
        ADD.W   D4,D3
        DBRA    D2,.BUCLE
.ZERO
        ADD.W   D1,D3
        ADD.W   D3,D3
        ADD.W   D3,A0 
        
        MOVEM.L (A7)+,D0-D4
        RTS
        
; -----------------------------------------------------------------------------
PLAYERPLOT
; PLOTS THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        MOVEM.L D0-D4,-(A7)
        
        MOVE.W  (POSX),D5
        SUB.W   #15,D5
        MOVE.W  (POSY),D6
        SUB.W   #15,D6
        
        CMP     #1,SHIFT
        BEQ     .JMP
        MOVE.W  #4,D1
        JSR     IMGSEL
        BRA     .DONE
.JMP    MOVE.W  #5,D1
        JSR     IMGSEL
        BRA     .DONE
        
        MOVE.W  #80,D0
        MOVE.L  #$000000FF, D1 
        TRAP    #15 
    
        MOVE.W  #81,D0
        MOVE.L  #$000000FF, D1 
        TRAP    #15
        
        MOVE.W  #87,D0
        
        MOVE.W  POSX,D1     ;pata izq
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        SUB.W   #15,D1
        ADD.W   #8,D2
        SUB.W   #6,D3
        ADD.W   #16,D4
        
        TRAP    #15
        
        MOVE.W  POSX,D1         ;pata der
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        ADD.W   #7,D1
        ADD.W   #8,D2
        ADD.W   #16,D3
        ADD.W   #16,D4
        
        TRAP    #15
        
        CMP     #1,SHIFT
        BEQ     .SALTANDO
    
        MOVE.W  POSX,D1         ;no salta cuerpo
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        SUB.W   #15,D1
        SUB.W   #15,D2
        ADD.W   #16,D3
        ADD.W   #8,D4
    
        TRAP #15
        
        MOVE.W  #80,D0
        MOVE.L  #$00FFFFFF, D1 
        TRAP    #15 
    
        MOVE.W  #81,D0
        MOVE.L  #$00FFFFFF, D1
        TRAP    #15
        
        MOVE.W  #88,D0          ;ns boca
        MOVE.W  POSX,D1
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        SUB.W   #12,D1
        SUB.W   #2,D2
        ADD.W   #13,D3
        ADD.W   #4,D4
        
        TRAP    #15
        
        MOVE.W  #80,D0
        MOVE.L  #$000000FF, D1 
        TRAP    #15 
    
        MOVE.W  #81,D0
        MOVE.L  #$000000FF, D1
        TRAP    #15
        
        MOVE.W  #87,D0
        MOVE.W  POSX,D1
        SUB.W   #12,D1
        SUB.W   #4,D4
        
        TRAP    #15
        
        MOVE.W  #80,D0              ;OJITOS LINDOS
        MOVE.L  #$00000000, D1 
        TRAP    #15 
    
        MOVE.W  #81,D0
        MOVE.L  #$00000000, D1
        TRAP    #15
        
        MOVE.W  #88,D0
        MOVE.W  POSX,D1
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        SUB.W   #10,D1
        SUB.W   #12,D2
        SUB.W   #3,D3
        SUB.W   #4,D4
        
        TRAP    #15
                
        MOVE.W  POSX,D1
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        ADD.W   #12,D1
        SUB.W   #12,D2
        ADD.W   #5,D3
        SUB.W   #4,D4
        
        TRAP    #15

                        
        BRA     .DONE
        
.SALTANDO
    
        MOVE.W  POSX,D1         ;salta cuerpo
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        SUB.W   #15,D1
        SUB.W   #5,D2
        ADD.W   #16,D3
        ADD.W   #12,D4
    
        TRAP #15
        
        MOVE.W  #80,D0
        MOVE.L  #$00FFFFFF, D1 
        TRAP    #15 
    
        MOVE.W  #81,D0
        MOVE.L  #$00FFFFFF, D1
        TRAP    #15
        
        MOVE.W  #88,D0          ;SS boca
        MOVE.W  POSX,D1
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        SUB.W   #12,D1
        ADD.W   #2,D2
        ADD.W   #13,D3
        ADD.W   #8,D4
        
        TRAP    #15
        
        MOVE.W  #80,D0
        MOVE.L  #$000000FF, D1 
        TRAP    #15 
    
        MOVE.W  #81,D0
        MOVE.L  #$000000FF, D1
        TRAP    #15
        
        MOVE.W  #87,D0
        MOVE.W  POSX,D1
        SUB.W   #12,D1
        SUB.W   #4,D4
        
        TRAP    #15
        
        MOVE.W  #80,D0              ;OJITOS LINDOS
        MOVE.L  #$00000000, D1 
        TRAP    #15 
    
        MOVE.W  #81,D0
        MOVE.L  #$00000000, D1
        TRAP    #15
        
        MOVE.W  #87,D0
        MOVE.W  POSX,D1
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        SUB.W   #10,D1
        SUB.W   #4,D2
        SUB.W   #3,D3
        SUB.W   #2,D4

        
        TRAP    #15
                
        MOVE.W  POSX,D1
        MOVE.W  POSY,D2
        MOVE.W  POSX,D3
        MOVE.W  POSY,D4
        ADD.W   #12,D1
        SUB.W   #4,D2
        ADD.W   #5,D3
        SUB.W   #2,D4
        
        TRAP    #15
                     
.DONE        
        MOVEM.L (A7)+,D0-D4    
        RTS








































*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
