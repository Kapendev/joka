@echo off
setlocal enabledelayedexpansion

:: A WASM-4 project should look like this:
::    +- Folder -+
::    | app.d    |
::    | joka     |
::    | run.bat  |
::    +----------+

set "output=app.wasm"
set "files=app.d"
set "flags="

:: Change directory to where the script is located
cd /d "%~dp0"

ldc2 -of=%output% ^
    %files% %flags% ^
    -i -betterC ^
    --mtriple=wasm32 ^
    --checkaction=halt ^
    --d-version=JokaSmallFootprint ^
    --d-version=JokaMathStubs ^
    -L--export=update ^
    -L--strip-all ^
    -L--no-entry ^
    -L--stack-first ^
    -L--import-memory ^
    -L--initial-memory=65536 ^
    -L--max-memory=65536 ^
    -L-zstack-size=14752

if %errorlevel% neq 0 (
    echo Build failed!
    exit /b %errorlevel%
)

w4 run-native "%output%"
