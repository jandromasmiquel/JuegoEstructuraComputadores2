; ==============================================================================
; SYSTEM CONSTANTS
; ==============================================================================

; --- SCREEN RELATED CONSTANTS -------------------------------------------------

SCRWIDTH    EQU     640                  
SCRHEIGH    EQU     480                    
SCRFPS      EQU     100 
TILETAM     EQU     32                  

; --- KEYCODES -----------------------------------------------------------------

KBDW        EQU 'W'
KBDA        EQU 'A'
KBDS        EQU 'S'
KBDD        EQU 'D'
KBDSPACE    EQU ' '
KBDQ        EQU 'Q'
KBDSHIFT    EQU $10
KBDE        EQU 'E'

; --- TRAPS AND INTERRUPT ------------------------------------------------------

INITPLTN    EQU     0
GAMEPLTN    EQU     1
PAUPLTN     EQU     2
ENDTN       EQU     3
SCRUPTN     EQU     4                      
KBDUPTN     EQU     5
AUDPLTN     EQU     6


SCRINTN     EQU     1






*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
