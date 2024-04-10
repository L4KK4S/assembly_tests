# assembly_tests

**Ce dépôt contient mes tests et exercices pour apprendre l'assembleur, actuellement il y a ces scripts:**
* Script pour afficher du texte [print](https://github.com/L4KK4S/assembly_tests/tree/main/print)
* Script pour faire un input [scan](https://github.com/L4KK4S/assembly_tests/tree/main/scan)
* Script pour effectuer une condition [condition](https://github.com/L4KK4S/assembly_tests/tree/main/condition)

**Comment compiler un .asm ?**
* Vous devez avoir [nasm.exe](https://www.nasm.us/) et [golink.exe](https://www.godevtool.com/) pour compiler votre programme.
* Ouvrez l'invite du terminal dans le dossier du fichier .asm
* Tapez ``nasm -f win64 main.asm -o main.obj`` pour obtenir un fichier .obj à partir de votre fichier .asm (faites attention au nom de votre fichier, si nécessaire changez la ligne de commande pour obtenir le même nom)
* Puis tapez ``golink.exe main.obj /entry main /console kernel32.dll`` pour obtenir un fichier .exe à partir de votre fichier .obj (faites attention au nom de votre fichier, si nécessaire changez la ligne de commande pour obtenir le même nom)
* Lancez maintenant le fichier .exe
* Tous les fichiers sont dans [.tools] (https://github.com/L4KK4S/assembly_tests/tree/main/.tools), vous pouvez utiliser "assembles.bat" pour faire toutes ces commandes en même temps, mais votre fichier doit être "main.asm".

