nasm -f win64 main.asm -o main.obj 
golink.exe main.obj /entry main /console kernel32.dll 
main.exe 
