main_texts:
	push txt_touches
    push 39
    push 0  ; X
    push 24 ; Y
    push 0Fh
    call write_text

	push txt_score
    push 40
    push 0  ; X
    push 0  ; Y
    push 0Fh
    call write_text

    push str_no_niveau
    push 2
    push 8  ; X
    push 0  ; Y
    push 0Fh
    call write_text

    push str_boites_placees
    push 2
    push 20 ; X
    push 0  ; Y
    push 0Fh
    call write_text

    push str_boites_total
    push 2
    push 23 ; X
    push 0  ; Y
    push 0Fh
    call write_text

    push str_coups
    push 5
    push 34 ; X
    push 0  ; Y
    push 0Fh
    call write_text

	ret

; PROCÉDURE write_text
; Affiche une chaine de caractère à l'endroit indiqué
; Paramètres : adresse du texte, longueur, pos X, pos Y, couleurs

write_text:
    pusha
	mov si, sp
    add si, 10h

    mov al, 1
	mov bh, 0
	mov cx, [si+8] ; taille
	mov dl, [si+6] ; pos X
	mov dh, [si+4] ; pos Y
	mov bl, [si+2] ; paramètres couleurs
	push cs
	pop es
	mov bp, [si+10] ; adresse texte
	mov ah, 13h
	int 10h

    popa
    ret 10

; PROCÉDURE inc_strvar
; Incrémente une chaine de caractères contenant un nombre
; Paramètres : adresse de la chaine, nombre de caractères

inc_strvar:
    pusha
    mov si, sp  ; SP copié dans SI
    add si, 10h ; décalage lié à pusha

    mov bx, [si+4] ; adresse strvar
    mov cx, bx
    mov ax, [si+2] ; longueur strvar
    add bx, ax

    boucle_inc_strvar:
        dec bx
        cmp byte [bx], '9'
        je change_dizaine
        inc byte [bx]
        jmp fin_inc_strvar

        change_dizaine:
            mov byte [bx], '0'

    cmp bx, cx
    jne boucle_inc_strvar

    fin_inc_strvar:
    popa
    ret 4

dec_strvar:
    pusha
    mov si, sp  ; SP copié dans SI
    add si, 10h ; décalage lié à pusha

    mov bx, [si+4] ; adresse strvar
    mov cx, bx
    mov ax, [si+2] ; longueur strvar
    add bx, ax

    boucle_dec_strvar:
        dec bx
        cmp byte [bx], '0'
        je change_dizaine_dec
        dec byte [bx]
        jmp fin_dec_strvar

        change_dizaine_dec:
            mov byte [bx], '9'

    cmp bx, cx
    jne boucle_dec_strvar

    fin_dec_strvar:
    popa
    ret 4

txt_titre:
db "         YASS-SOKOBAN POUR DOS          "
db "   Appuyez sur ENTREE pour continuer    "

txt_credits:
db "        Version de developpement        "
db "           hyakosm.net ", 0B8h, " 2019           "

txt_score: db   " Niveau 00 - Boites 00/00 - Coups 00000 "
txt_touches: db " ESC Quitter - F1 Recommencer le niveau "

txt_fin:
db "MERCI D'AVOIR JOUE !", 10, 13, 10, 13

db "YASS-SOKOBAN pour DOS par Maya Friedrichs", 10, 13, 10, 13

db "Le Sokoban est un jeu cr", 130, 130, " par Hiroyuki Imabayashi en 1981"
db 10, 13, "Niveaux extraits de XSokoban pour UNIX "
db "(www.cs.cornell.edu/andru/xsokoban.html)", 10, 13, 10, 13

db "hyakosm.net ", 0B8h, " 2019", 10, 13, 10, 13, 10, 13


db "Appuyez sur une touche pour revenir au DOS...$"