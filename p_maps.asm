; PROCÉDURE load_map
; Charge une carte dans le buffer map_buffer
; paramètre : adresse de la carte

load_map:
	pusha

	mov di, sp		   ; copie de SP dans DI
	add di, 10h        ; décalage lié à pusha
	mov bx, [di+2]     ; BX = adresse ressource de map source
	mov si, map_buffer ; SI = adresse de la map tampon

	; décalage permanent d'une ligne pour laisse libre la ligne du score
	add si, TAILLE_MAP_X

	mov dx, 0 ; DX = nb de caractères sur la ligne en cours

	charge_caractere:
		mov ax, [bx] ; AL = nombre de fois ; AH = caractère

		cmp al, 0FFh ; dernier caractère de la map
		je fin_load_map
		cmp al, 0EEh ; dernier caractère de chaque ligne
		je nouvelle_ligne
		cmp ah, C_JOUEUR
		jne suite_charge_caractere
		mov [adresse_pos_perso], word si ; renvoi position personnage

		suite_charge_caractere:
			mov cx, ax
			xor ch, ch ; on veut juste AL dans CX

		repetition_caractere:
			cmp ah, C_CAISSE
			je ajouter_compte_caisse
			cmp ah, C_CAISSE_POSEE
			je ajouter_compte_caisse_placee
			jmp suite_repetition
			ajouter_compte_caisse:
				inc byte [nb_boites_total]
				push str_boites_total
				push 2
				call inc_strvar
				jmp suite_repetition
			ajouter_compte_caisse_placee:
				inc byte [nb_boites_placees]
				push str_boites_placees
				push 2
				call inc_strvar
			suite_repetition:
			mov [si], ah
			inc si
			inc dx
		loop repetition_caractere

		add bx, 2 ; on se déplace de mot en mot sur la map source
	
		jmp charge_caractere

	nouvelle_ligne:
		inc bx
		inc bp
		add si, TAILLE_MAP_X
		sub si, dx
		mov dx, 0 ; réinitialisation compteur ligne
		jmp charge_caractere

	fin_load_map:
		popa
		ret 2

; PROCÉDURE view_map
; Affiche la carte à l'écran

view_map:
	pusha

	mov si, map_buffer ; index début map
	mov di, si
	add di, TAILLE_MAP_XY ; index fin map

	mov ax, 0
	mov bx, 0
	mov cx, TAILLE_MAP_X
	trace_ligne_map:
		mov dx, [si]

		cmp dl, 00h
		je pas_de_bloc
		cmp dl, C_JOUEUR
		je push_sprite_perso
		cmp dl, C_JOUEUR_MARQUE
		je push_sprite_perso_sur_marque
		cmp dl, C_MARQUE
		je push_sprite_marque
		cmp dl, C_MUR
		je push_sprite_mur
		cmp dl, C_SOL
		je push_sprite_sol
		cmp dl, C_CAISSE_POSEE
		je push_sprite_caisseok
		cmp dl, C_CAISSE
		je push_sprite_caisse

		jmp pas_de_bloc

		push_sprite_perso:
			push perso
			jmp trace_ligne_suite
		push_sprite_perso_sur_marque:
			push perso_sur_marque
			jmp trace_ligne_suite
		push_sprite_marque:
			push marque
			jmp trace_ligne_suite
		push_sprite_mur:
			push mur
			jmp trace_ligne_suite
		push_sprite_sol:
			push sol
			jmp trace_ligne_suite
		push_sprite_caisseok:
			push caisseok
			jmp trace_ligne_suite
		push_sprite_caisse:
			push caisse
			jmp trace_ligne_suite

		trace_ligne_suite:
			push bx ; pox X
			push ax ; pos Y
			call sprite
		pas_de_bloc:
			inc si
			add bx, PAS_DEPL_X
	loop trace_ligne_map

	; ligne suivante
	add ax, PAS_DEPL_Y
	mov bx, 0
	mov cx, TAILLE_MAP_X
	cmp byte [no_niveau], 1
	cmp si, di
	jne trace_ligne_map

	; fin
	popa
	ret

; PROCÉDURE effacement_map_buffer
; Efface le map_buffer avec des 0

effacement_map_buffer:
    mov bx, map_buffer
    mov cx, TAILLE_MAP_XY
    boucle_eff_map_buffer:
        mov [bx], word 00h
        inc bx
    loop boucle_eff_map_buffer
    ret

; PROCÉDURE map_avance
; Avance le pointeur adresse_map_ouverte à la map suivante

map_avance:
	pusha
    mov bx, [adresse_map_ouverte]
    boucle_map_avance:
        inc bx
        cmp [bx], byte 0FFh
    jne boucle_map_avance
    inc bx
    mov [adresse_map_ouverte], bx
	popa
	ret

; PROCÉDURE map_recule
; Recule le pointeur adresse_map_ouverte à la map précédente

map_recule:
	pusha
    mov bx, [adresse_map_ouverte]
    dec bx
    boucle_map_recule:
        dec bx
        cmp [bx], byte 0FFh
    jne boucle_map_recule
    inc bx
    mov [adresse_map_ouverte], bx
	popa
	ret
