@echo off
setlocal

set exe_path=.\examples\.temp.exe
set app_path=.\examples\_001_hello.d
set compiler=dmd
set "extra_flags=-debug"

if not "%~1"=="" set app_path=%~1
if not "%~2"=="" set compiler=%~2

if "%compiler%"=="ldc2" set "extra_flags=--d-debug"

%compiler% ^
    -of=%exe_path% ^
    -I=source -i %extra_flags% ^
    -run %app_path%

endlocal
