# assembly_tests

**This repository contains my tests and exercises to learn assembly, currently there are these scripts:**
* Script to diplay text [print](https://github.com/L4KK4S/assembly_tests/tree/main/print)
* Script to scan text [scan](https://github.com/L4KK4S/assembly_tests/tree/main/scan)

**How to compile .asm?**
* You need to have [nasm.exe](https://www.nasm.us/) and [golink.exe](https://www.godevtool.com/) to compile your program
* Open terminal prompt in the .asm file folder
* Type ``nasm -f win64 main.asm -o main.obj`` to get an .obj file from your .asm file (take care of the name of your file, if need change the command line to get the same name)
* Then type ``golink.exe main.obj /entry main /console kernel32.dll`` to get an .exe file from your .obj file (take care of the name of your file, if need change the command line to get the same name)
* Now just launch the .exe file
* All the files are in [.tools](https://github.com/L4KK4S/assembly_tests/tree/main/.tools) , you can uses "assembles.bat" to do all theses commands in the same time, but your file need to be "main.asm"
