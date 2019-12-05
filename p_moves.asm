; PROCÉDURE move_player
; Fait bouger le joueur dans le map_buffer
; paramètre : code de la touche appuyée (renvoyé dans AH depuis INT16h AH0)

move_player:
	pusha

	mov si, sp		   ; copie de SP dans DI
	add si, 12h        ; on retrouve le paramètre de touche
	mov dx, [si]	   ; DH = touche appuyée

	mov bx, [adresse_pos_perso] ; BX = position perso sur la grille

	mov di, bx ; DI = position +1 selon direction (devant à un pas du joueur)
	mov si, bx ; SI = position +2 selon direction (devant à deux pas du joueur)

	cmp dh, 4Dh
	je move_r
	cmp dh, 4Bh
	je move_l
	cmp dh, 48h
	je move_u
	cmp dh, 50h
	je move_d

	cmp dh, 20h
	je move_r
	cmp dh, 1Eh
	je move_l
	cmp dh, 11h
	je move_u
	cmp dh, 1Fh
	je move_d

	jmp move_fin

	move_r:
		inc di
		add si, 2
		jmp move_regles

	move_l:
		dec di
		sub si, 2
		jmp move_regles

	move_u:
		sub di, TAILLE_MAP_X
		sub si, TAILLE_MAP_X*2
		jmp move_regles

	move_d:
		add di, TAILLE_MAP_X
		add si, TAILLE_MAP_X*2

	move_regles:
		verif_boite_enlevee:
			cmp [di], byte C_CAISSE_POSEE
			jne verif_boite_ajoutee
			cmp [si], byte C_SOL
			jne verif_boite_ajoutee

			dec byte [nb_boites_placees]
			push str_boites_placees
			push 2
			call dec_strvar

		verif_boite_ajoutee:
			cmp [di], byte C_CAISSE
			jne maj_map_selon_deplacement
			cmp [si], byte C_MARQUE
			jne maj_map_selon_deplacement

			inc byte [nb_boites_placees]
			push str_boites_placees
			push 2
			call inc_strvar


		maj_map_selon_deplacement:
		mov ah, C_SOL ; caractère effacement par défaut
		mov al, C_JOUEUR ; caractère personnage par défaut

		cmp [di], byte C_MUR ; mur
		je move_fin
		cmp [di], byte C_CAISSE ; caisse
		je caisse_devant
		cmp [di], byte C_CAISSE_POSEE ; caisse posée
		je caisse_devant_posee
		jmp move_suite

		caisse_devant_posee:
		mov al, C_JOUEUR_MARQUE ; s'il bouge, le perso sera sur marque
		caisse_devant:
		cmp [si], byte C_SOL ; vide
		je caisse_ok
		cmp [si], byte C_MARQUE ; marque
		je caisse_posee
		jmp move_fin

		caisse_ok:
		mov [si], byte C_CAISSE
		jmp move_suite

		caisse_posee:
		mov [si], byte C_CAISSE_POSEE

		move_suite:
		cmp [bx], byte C_JOUEUR_MARQUE
		jne verif_marque_devant
		mov ah, C_MARQUE
		verif_marque_devant:
		cmp [di], byte C_MARQUE
		jne move_maj_infos
		mov al, C_JOUEUR_MARQUE
		move_maj_infos:
		mov [bx], byte ah
		mov [adresse_pos_perso], di
		mov [di], byte al
		; màj des infos de score
			push str_coups
			push 5
			call inc_strvar

	move_fin:
		popa
		ret 2
