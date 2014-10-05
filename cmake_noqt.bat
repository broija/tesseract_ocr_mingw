@ECHO OFF

rmdir /s /q CMakeFiles
del /f /q CMakeCache.txt

cmake^
 -G"Unix Makefiles"^
 -D"CMAKE_MAKE_PROGRAM:PATH=C:/MinGW/bin/mingw32-make.exe"^
 .