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
    ret
