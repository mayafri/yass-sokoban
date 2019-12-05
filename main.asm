CPU 286 ; directive pour NASM
org 100h
            
mov ax, 13h ; mode VGA 320x200 en 256 couleurs
int 10h       

jmp ecran_titre

; inclusion procédure icone  
%include "const.asm"
%include "p_maps.asm"        
%include "p_screen.asm"
%include "p_text.asm"
%include "p_moves.asm"
%include "r_maps.asm"
%include "r_graph.asm"

map_buffer: times TAILLE_MAP_XY db 00h ; buffer de la map en cours

adresse_pos_perso: dw 0 ; adresse du personnage sur la map
adresse_map_ouverte: dw map_titre ; map à l'ouverture

no_niveau: db 0
nb_boites_total: db 0
nb_boites_placees: db 0

str_no_niveau: db "00"
str_boites_total: db "00"
str_boites_placees: db "00"
str_coups: db "00000"

couleur_ecran: db 020h

init_niveau:
    ; nettoyage écran et buffer
    push 058h
    call effacer_ecran
    call effacement_map_buffer

    ; nettoyage variables
    mov [nb_boites_placees], byte 0
    mov [str_boites_placees], word "00"
    mov [nb_boites_total], byte 0
    mov [str_boites_total], word "00"

    ; charger map
    push word [adresse_map_ouverte]
    call load_map

    ; attendre un peu (effet de transition)
    mov ah, 86h
	mov cx, 5h
	mov dx, 9680h
	int 15h

trame:
    ; si le niveau est fini, on passe au suivant
    mov al, byte [nb_boites_placees]
    cmp [nb_boites_total], al
    je niveau_suivant

    ; dessiner textes
    call main_texts

    ; dessiner map
    call view_map

    ; frappe clavier
    mov ah, 00h
    int 16h
    
    ; si ECHAP, fin du jeu
    cmp ah, 01h
    je quitter

    ; si F1, on recommence le niveau
    cmp ah, 3Bh
    je init_niveau

    ; si F2, on recule d'une map
    cmp ah, 3Ch
    je niveau_precedent

    ; si F3, on avance d'une map
    cmp ah, 3Dh
    je niveau_suivant

    ; si autre touche
    push ax
    call move_player
    jmp trame

niveau_precedent:
    call map_recule

    push str_no_niveau
    push 2
    call dec_strvar

    dec byte [no_niveau]

    jmp init_niveau

niveau_suivant:
    call map_avance

    mov bx, [adresse_map_ouverte]
    cmp [bx], word 0xCAFE ; test si fin du jeu
    je quitter

    push str_no_niveau
    push 2
    call inc_strvar

    inc byte [no_niveau]

    jmp init_niveau

quitter:
    mov ax, 03h
    int 10h

    mov dx, txt_fin
    mov ah, 09h
    int 21h

    ; après frappe d'une touche, fin programme
    mov ah, 00h
    int 16h

    ; effacement écran
    mov ax, 03h
    int 10h

    ret

ecran_titre:
    ; charger map
    push word [adresse_map_ouverte]
    call load_map

    ; dessiner map
    call view_map

    push txt_credits
    push 80
    push 0  ; X
    push 0  ; Y
    push 0Fh
    call write_text

    push txt_titre
    push 80
    push 0  ; X
    push 22 ; Y
    push 0Fh
    call write_text

    mov ah, 00h
    int 16h

    ; si ECHAP, quitter
    cmp ah, 01h
    je quitter

    ; si autre touche, début jeu
    jmp niveau_suivant
