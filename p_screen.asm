; PROCÉDURE sprite
; Affiche un sprite à l'écran
; paramètres : adresse de la ressource, position X, position Y
; format de la resource : taille X (octet), taille Y (octet), pixels (array)

sprite:
    pusha          
    ; Définition du segment du framebuffer VGA (dans ES)          
    mov ax, 0A000h 
    mov es, ax

    ; Conversion position vers offset array (dans DI)
    mov si, sp  ; SP copié dans SI
    add si, 10h ; décalage lié à pusha
    
    ; Y 
    mov ax, [si+2]
    mov bx, ax
    shl ax, 8 ;    * 256
    shl bx, 6 ;  + * 64 (= * 320)
    add ax, bx
    
    ; X
    add ax, [si+4]
    mov di, ax
    
    ; adresse de début de la ressource
    mov bx, [si+6] 

    ; Calcul de l'adresse de fin du bitmap (dans AX)
    mov ax, [bx] ; taille du bitmap (ah = X, al = Y)
    mul ah       ; AX = AH * AL
    add ax, bx   ; + début ressource
    add ax, 2    ; + décalage des 2 octets du début
                  
    ; Balayage des lignes
    mov cx, [bx]
    xor ch, ch   ; taille ligne bitmap (compteur boucle) (on efface coor Y)
    mov dh, cl   ; taille ligne bitmap (référence)
    add bx, 2    ; adresse de début du bitmap

    trace_ligne_sprite:
        mov dl, [bx]    ; DL car 1 pixel = 1 octet
        mov [es:di], dl ; écriture du pixel dans le framebuffer
        inc di
        inc bx
    loop trace_ligne_sprite
    
    mov cl, dh   ; reset compteur ligne
    add di, 320
    sub di, cx   ; saut de ligne
    cmp bx, ax
    jnge trace_ligne_sprite
    
    popa
    ret 6

; PROCÉDURE effacer écran
; paramètre : couleur VGA de l'écran

effacer_ecran:
    pusha    
    mov ax, 0A000h 
    mov es, ax ; ES = segment du framebuffer VGA
    mov di, 00h

    mov si, sp  ; SP copié dans SI
    add si, 10h ; décalage lié à pusha

    mov ax, [si+2] ; couleur

    mov cx, 64000
    boucle_effacement:
        mov [es:di], ax
        inc di
    loop boucle_effacement

    popa
    ret 2