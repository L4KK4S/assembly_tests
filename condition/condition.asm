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

; variables initialisés nécéssaires
section .data 

    input_message:
        db "Are you good? (y/n)", 0d10, ">> "                           ; le message à sortir pour demander si l'utilisateur va bien
    input_message_lenght equ $- input_message                           ; variable pour la longueur du message

    second_message:
        db "Answer by y or n", 0d10, 0d10                               .\golink.exe main.obj /entry main /console kernel32.dll ; le message à sortir si l'utilisateur n'a pas répondu par y ou n
    second_message_lenght equ $- second_message                         ; variable pour la longueur du second_message    

    yes_message:
        db "Im good too!", 0d10                                         ; le message à sortir si il va bien
    yes_message_lenght equ $- yes_message                               ; variable pour la longueur de yes_message 
    
    no_message:
        db "Oh noo!", 0d10                                              ; le message à sortir si il ne l'est pas
    no_message_lenght equ $- no_message                                 ; variable pour la longueur de no_message 
        
    yes_answer:
        db "y", 0d10                                                    ; la réponse si il va bien
    no_anwser:
        db "n", 0d10                                                    ; la réponse si il ne l'est pas    

    answer_lenght equ 1 + 2                                             ; variable pour la longueur max de la réponse à entrer, 1 + 2 donc 3 caractères pour le retour à la ligne
    


; variables non-initialisés nécéssaires
section .bss

    written:
        resq 1                          ; réserve un espace d'un q(quadruple-word) donc 2 * 2 * 8 bits = 32 bits, pour l'éciture
    read:
        resq 1                          ; réserve un espace d'un q(quadruple-word) donc 2 * 2 * 8 bits = 32 bits, pour la lecture
    answer:
        resb answer_lenght             ; réserve un espace de 5 b(byte) donc 5 * 8 bits = 40 bits, pour l'age de l'utilisateur

; code
section .text


    global main

    main:

        ; shadow space, espace nécessaire pour le bon fonctionnement du code, c'est une convention
        sub rsp, SHADOW_SPACE                       ; 40 + 8 = 48 on a donc un multiple de 16

        ; label pour le message pour demander si l'utilisateur va bien
        input_message_label:

            ; initialise l'écriture
            mov rcx, CONSOLE_OUTPUT_VALUE           ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -11 => ce sera une sortie console
            call GetStdHandle                       ; appel de la fonction

            ; affiche le message
            mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
            mov rdx, input_message                  ; second argument: ce qu'il y a à afficher, message
            mov r8, input_message_lenght            ; troisième argument: taille de ce qu'il y a à afficher, taille du message
            mov r9, written                         ; quatrième argument: nombre de caractères ecrits, on lui passe written
            mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
            call WriteConsoleA                      ; appel de la fonction

        
            
        scan_answer_label:

            ; initialise la lecture
            mov rcx, CONSOLE_INPUT_VALUE            ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -10 => ce sera une entrée console
            call GetStdHandle                       ; appel de la fonction

            ; lit la réponse
            mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
            mov rdx, answer                         ; second argument: où stocker ce qu'il y a à lire, answer
            mov r8, answer_lenght                   ; troisème argument: taille de ce qu'il faut lire, answer_lenght
            mov r9, read                            ; quatrième argument: nombre de caratères lus, on lui passe read
            mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
            call ReadConsoleA                       ; appel de la fonction
            jmp yes_condition_label                 ; on va à yes_condition_label
    
        display_answer_label:

            ; affiche la réponse
            mov rcx, CONSOLE_OUTPUT_VALUE           ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -11 => ce sera une sortie console
            call GetStdHandle                       ; appel de la fonction
            ; affiche la réponse
            mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
            mov rdx, answer                         ; second argument: ce qu'il y a à afficher, answer
            mov r8, answer_lenght                   ; troisième argument: taille de ce qu'il y a à afficher, taille de answer
            mov r9, written                         ; quatrième argument: nombre de caractères ecrits, on lui passe written
            mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
            call WriteConsoleA                      ; appel de la fonction

        yes_condition_label:

            mov rsi, answer                         ; met la réponse dans rsi
            mov rcx, 1                              ; met 1 dans rcx pour la comparaison

            mov rdi, yes_answer                     ; met la réponse attendue dans rdi
            repe cmpsb                              ; compare les octets pointés par RSI et RDI jusqu'à ce que RCX atteigne zéro ou jusqu'à ce que les octets diffèrent
            je yes_label                            ; si les chaînes sont égales, saute à yes_label
            jne no_condition_label                   ; sinon saute à no_condition_label
            
    
        no_condition_label:

        mov rsi, answer                         ; met la réponse dans rsi
            mov rcx, 1                              ; met 1 dans rcx pour la comparaison

            mov rdi, no_anwser                      ; met la réponse attendue si il ne va pas bien dans rbx
            repe cmpsb                              ; compare les octets pointés par RSI et RDI jusqu'à ce que RCX atteigne zéro ou jusqu'à ce que les octets diffèrent
            je no_label                             ; si les chaînes sont égales, saute à no_label

            jmp ask_again_label                     ; sinon on retourne à ask_again_label

            yes_label:

                ; initialise l'écriture
                mov rcx, CONSOLE_OUTPUT_VALUE           ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -11 => ce sera une sortie console
                call GetStdHandle                       ; appel de la fonction

                ; affiche le message
                mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
                mov rdx, yes_message                    ; second argument: ce qu'il y a à afficher, yes_message
                mov r8, yes_message_lenght              ; troisième argument: taille de ce qu'il y a à afficher, yes_message_lenght
                mov r9, written                         ; quatrième argument: nombre de caractères ecrits, on lui passe written
                mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
                call WriteConsoleA                      ; appel de la fonction

                jmp end_label                           ; on va à end_label

            no_label:

                ; initialise l'écriture
                mov rcx, CONSOLE_OUTPUT_VALUE           ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -11 => ce sera une sortie console
                call GetStdHandle                       ; appel de la fonction

                ; affiche le message
                mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
                mov rdx, no_message                     ; second argument: ce qu'il y a à afficher, no_message
                mov r8, no_message_lenght               ; troisième argument: taille de ce qu'il y a à afficher, no_message_lenght
                mov r9, written                         ; quatrième argument: nombre de caractères ecrits, on lui passe written
                mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
                call WriteConsoleA                      ; appel de la fonction

                jmp end_label                           ; on va à end_label

            ask_again_label:

                ; initialise l'écriture
                mov rcx, CONSOLE_OUTPUT_VALUE           ; premier argument: valeur entière (-10, -11, -12), ici l'argument de la fonction est -11 => ce sera une sortie console
                call GetStdHandle                       ; appel de la fonction

                ; affiche le message
                mov rcx, rax                            ; premier argument: gestionnaire actif, on le cherche dans rax qui est l'accumulateur et où est stocké le retour de la fonction GetStdHandle
                mov rdx, second_message                 ; second argument: ce qu'il y a à afficher, second_message
                mov r8, second_message_lenght           ; troisième argument: taille de ce qu'il y a à afficher, second_message_lenght
                mov r9, written                         ; quatrième argument: nombre de caractères ecrits, on lui passe written
                mov qword [rsp+SHADOW_SPACE], NULL      ; cinquième argument: un espace réservé, on lui passe un qword(32 octets), les reserve apres les 32 premiers octets de la pile rsp, on y place que des zéros car c'est un espace vide
                call WriteConsoleA                      ; appel de la fonction

                jmp input_message_label                 ; on retourne à input_message_label

            end_label:

                ;récupère le shadow space
                add rsp, SHADOW_SPACE                    ; reprend les octets alloués par WriteConsoleA

                ; fini le programme
                xor rcx, rcx                             ; premier argument: sortie du preogramme : 0, au lieu de faire mov rcx, 0, on fait xor rcx, rcx car c'est plus rapide
                call ExitProcess                         ; appel de la fonction
