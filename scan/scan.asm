bits 64 ; nous sommes sur un système 64 bits

; importe les fonctions windows nécéssaires
extern GetStdHandle   ; gestionnaire de périphériques
extern WriteConsoleA  ; ecrit dans la console
extern ReadConsoleA   ; lit dans la console
extern ExitProcess    ; fini le processus actuel

; constantes
CONSOLE_OUTPUT_VALUE equ -0d11
CONSOLE_INPUT_VALUE equ 0d-10
SHADOW_SPACE equ 0d40
NULL equ 0d0

section .data 

    message:
        db "What's your name ?", 0d10                                   ; le message à sortir
    message_lenght equ $- message                                       ; variable pour la longueur du message

    hello:
        db "Hello "                                                     ; le mot 'hello'
    hello_lenght equ $- hello                                           ; variable pour la longueur de hello 
        
    username_lenght equ 15 + 2                                          ; variable pour la longueur max du nom à entrer, 15 + 2 caractère pour le retour à la ligne

    final_message:
        db message_lenght + username_lenght dup(0)                      ; alloue la place nécessaire à cette chaine de charactère



section .bss

    written:
        resq 1                          ; réserve un espace d'un q(quadruple-word) donc 2 * 2 * 8 bits = 32 bits, pour l'éciture
    read:
        resq 1                          ; réserve un espace d'un q(quadruple-word) donc 2 * 2 * 8 bits = 32 bits, pour la lecture

    username:
        resb username_lenght            ; réserve un espace de 17 b(byte) donc 17 * 8 bits = 136 bits, pour le nom de l'utilisateur


section .text

    global main

    main:

        ; shadow space
        sub rsp, SHADOW_SPACE                   ; 40 + 8 = 48 on a donc un multiple de 16

        ; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        ; initialise l'écriture
        mov rcx, CONSOLE_OUTPUT_VALUE           ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -11 => ce sera une sortie console
        call GetStdHandle                       ; appel de la fonction

        ; affiche le message
        mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
        mov rdx, message                        ; second argument: ce qu'il y a à afficher, message
        mov r8, message_lenght                  ; troisième argument: taille de ce qu'il y a à afficher, taille du message
        mov r9, written                         ; quatrième argument: nombre de caractères ecrits, on lui passe written
        mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
        call WriteConsoleA

        ; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        ; initialise la lecture
        mov rcx, CONSOLE_INPUT_VALUE            ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -10 => ce sera une entrée console
        call GetStdHandle                       ; appel de la fonction

        ; lit la réponse
        mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
        mov rdx, username                       ; second argument: où stocker ce qu'il y a à lire, username
        mov r8, username_lenght                 ; troisème argument: taille de ce qu'il faut lire, max_username_lenght
        mov r9, read                            ; quatrième argument: nombre de caratères lus, on lui passe read
        mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
        call ReadConsoleA                       ; appel de la fonction

        ; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        ; Copier la première chaîne dans la nouvelle chaîne
        mov rsi, hello                          ; premier argument: la source, hello
        mov rdi, final_message                  ; deuxième argument: la destination, final_message
        mov rcx, hello_lenght                   ; troisième argument: nombre de caractères à copier, la taille de hello
        rep movsb

        ; Copier la deuxième chaîne à la suite de la première
        mov rsi, username                       ; premier argument: la source, username
        mov rdi, final_message + hello_lenght   ; deuxième argument: la destination, final_message
        mov rcx, username_lenght                ; troisième argument: nombre de caractères à copier, on additionne la taille de hello et de username
        rep movsb

        ; initialise l'écriture
        mov rcx, CONSOLE_OUTPUT_VALUE           ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -11 => ce sera une sortie console
        call GetStdHandle                       ; appel de la fonction

        ; affiche la réponse
        mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
        mov rdx, final_message                  ; second argument: ce qu'il y a à afficher, nom de l'utilisateur récupéré
        mov r8, hello_lenght + username_lenght  ; troisième argument: taille de ce qu'il y a à afficher, taille max du nom de l'utilisateur récupéré
        mov r9, written                         ; quatrième argument: nombre de caractères ecrits, on lui passe written
        mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
        call WriteConsoleA                      ; appel de la fonction

        ; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        ; récupère le shadow space
        add rsp, SHADOW_SPACE                    ; reprend les octets alloués par WriteConsoleA

        ; fini le programme
        xor rcx, rcx                             ; premier argument: sortie du preogramme : 0, au lieu de faire mov rcx, 0, on fait xor rcx, rcx car c'est plus rapide
        call ExitProcess                         ; appel de la fonction