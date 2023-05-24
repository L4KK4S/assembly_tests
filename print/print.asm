bits 64 

; importe les fonctions windows nécéssaires
extern GetStdHandle   ; gestionnaire de périphériques
extern WriteConsoleA  ; met la sortie en mode console
extern ExitProcess    ; fini le processus actuel

section .data 

    message:
        db 'Hello World !', 10     ; le message à sortir
    message_lenght equ $- message  ; variable pour la longueur du message


section .bss

    written:
        resq 1 ; réserve un espace d'un q(quadruple-word) donc 2 * 2 * 8 bits = 32 bits


section .text

    global main

    main:

        mov rcx, -11            ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -11 => ce sera une sortie console
        call GetStdHandle

        sub rsp, 32             ; allocation d'un espace fantôme de 32 octets nécéssaire pour le fonctionnement de windoxs, +8 octets pour le retour de la fonction, donc 40
        sub rsp, 8              ; 40 + 8 = 48 on a donc un multiple de 16

        mov rcx, rax            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
        mov rdx, message        ; second argument: message
        mov r8, message_lenght  ; troisième argument: taille du message
        mov r9, written         ; quatrième argument: nombre de caractères ecrits, on lui passe written
        mov qword [rsp+23], 0   ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
        call WriteConsoleA

        add rsp, 32+8           ; reprend les octets alloués par WriteConsoleA

        xor rcx, rcx            ; premier argument: sortie du preogramme : 0, au lieu de faire mov rcx, 0, on fait xor rcx, rcx car c'est plus rapide
        call ExitProcess