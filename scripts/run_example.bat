@echo off
setlocal

set exe_path=.\examples\.temp.exe
set app_path=.\examples\_001_hello.d
set compiler=dmd
set "extra_flags="

if not "%~1"=="" set app_path=%~1
if not "%~2"=="" set compiler=%~2
%compiler% ^
    -of=%exe_path% ^
    -I=source -i %extra_flags% ^
    -run %app_path%

endlocal
