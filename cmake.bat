@ECHO OFF

rmdir /s /q CMakeFiles
del /f /q CMakeCache.txt

cmake^
 -G "Unix Makefiles"^
 .