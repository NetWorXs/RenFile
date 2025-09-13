@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title RenFile
mode 110,35

:: ────────────────────────────────────────────────
::  INTRO SCREEN
:: ────────────────────────────────────────────────
:INTRO
cls
echo.
echo  ██████╗ ███████╗███╗   ██╗ ███████╗██╗██╗     ███████╗   
echo  ██╔══██╗██╔════╝████╗  ██║ ██╔════╝██║██║     ██╔════╝
echo  ██████╔╝█████╗  ██╔██╗ ██║ █████╗  ██║██║     █████╗    
echo  ██╔═██║ ██╔══╝  ██║╚██╗██║ ██╔══╝  ██║██║     ██╔══╝    
echo  ██║ ██║ ███████╗██║ ╚████║ ██║     ██║███████╗███████╗
echo  ╚═╝ ╚═╝ ╚══════╝╚═╝  ╚═══╝ ╚═╝     ╚═╝╚══════╝╚══════╝
echo.
echo                RenFile - File Rename Tool
echo                      Github: woxcv
echo.
echo  [About]
echo    RenFile is a simple but powerful batch tool that lets you
echo    rename every file in a folder automatically. It supports
echo    several renaming rules so you can organize your files
echo    exactly the way you want.
echo.
echo  [Rename Modes]
echo      [number] → Sequential numbers like 001, 002, 003...
echo      [alpha]  → Alphabetical IDs like aaaa, aaab, aaac...
echo      [crypt]  → Unique random GUIDs (unbreakable IDs)
echo      [date]   → Last modified date, e.g. 12_09_2025
echo      [size]   → File size in KB, e.g. 234KB
echo      [custom] → Custom text prefix, e.g. mytext_001
echo.
echo  [Navigation]
echo    start → Begin renaming
echo    exit  → Quit program
echo.
set /p choice="► Enter Command: "
if /i "%choice%"=="exit" exit /b
if /i "%choice%"=="start" goto START
goto INTRO

:: ────────────────────────────────────────────────
::  ASK FOR PATH
:: ────────────────────────────────────────────────
:START
cls
echo.
echo  Please enter the full folder path where your files are located.
echo  Example: C:\Users\File
echo.
:ASKPATH
set /p folder="► Enter folder path: "
if /i "%folder%"=="exit" exit /b
if /i "%folder%"=="home" goto INTRO

if not exist "%folder%" (
    echo.
    color 0C
    echo  [Error] The folder "%folder%" was not found!
    color 07
    echo  Please check the path and try again.
    echo.
    goto ASKPATH
)

goto MENU

:: ────────────────────────────────────────────────
::  MENU
:: ────────────────────────────────────────────────
:MENU
cls
echo  [Rename Options]
echo     [number] → Sequential numbers (001.jpg, 002.png, ...)
echo     [alpha]  → Alphabetical IDs (aaaa.jpg, aaab.png, ...)
echo     [crypt]  → Random GUIDs (08e94883-b463-....png)
echo     [date]   → Last modified date + index (12_09_2025_001.png)
echo     [size]   → File size in KB + index (234KB_001.mp3)
echo     [custom] → Custom text + sequential numbers (MyText_001.jpg)
echo.
echo  [Navigation]
echo    home  → Return to main menu
echo    exit  → Quit program
echo.
set /p mode="► Select mode: "

if /i "%mode%"=="exit" exit /b
if /i "%mode%"=="home" goto INTRO
if /i "%mode%"=="back" goto START

if /i "%mode%"=="number" goto RENUMERIC
if /i "%mode%"=="alpha"  goto REALPHA
if /i "%mode%"=="crypt"  goto RECRYPT
if /i "%mode%"=="date"   goto REDATE
if /i "%mode%"=="size"   goto RESIZE
if /i "%mode%"=="custom" goto RECUSTOM
goto MENU

:: ────────────────────────────────────────────────
::  CUSTOM PREFIX MODE
:: ────────────────────────────────────────────────
:RECUSTOM
cls
echo.
set /p customprefix="► Enter your custom prefix (e.g. MyFiles): "
echo.
call :TMPNAMES
set /a done=0
for /f "delims=" %%f in ('dir /b "%folder%\__tmp*"') do (
    set /a done+=1
    set "num=000!done!"
    ren "%folder%\%%f" "%customprefix%_!num:~-3!%%~xf" 2>nul
    call :BAR !done! %count%
)
goto FINISH

:: ────────────────────────────────────────────────
::  TEMPORARY FILENAMES
:: ────────────────────────────────────────────────
:TMPNAMES
set /a count=0
set /a done=0
for /f "delims=" %%f in ('dir /b /a-d "%folder%"') do (
    set /a count+=1
    set /a done+=1
    set "num=000!done!"
    ren "%folder%\%%f" "__tmp!num:~-4!%%~xf" 2>nul
)
exit /b

:: ────────────────────────────────────────────────
::  NUMERIC MODE
:: ────────────────────────────────────────────────
:RENUMERIC
call :TMPNAMES
set /a done=0
for /f "delims=" %%f in ('dir /b "%folder%\__tmp*"') do (
    set /a done+=1
    set "num=000!done!"
    ren "%folder%\%%f" "!num:~-3!%%~xf" 2>nul
    call :BAR !done! %count%
)
goto FINISH

:: ────────────────────────────────────────────────
::  ALPHA MODE
:: ────────────────────────────────────────────────
:REALPHA
call :TMPNAMES
set /a done=0
for /f "delims=" %%f in ('dir /b "%folder%\__tmp*"') do (
    set /a done+=1
    call :NUMTOALPHA4 !done! letter
    ren "%folder%\%%f" "!letter!_!done!%%~xf" 2>nul
    call :BAR !done! %count%
)
goto FINISH

:NUMTOALPHA4
setlocal enabledelayedexpansion
set "letters=abcdefghijklmnopqrstuvwxyz"
set /a n=%1
set "result="
:loopAlpha4
set /a n-=1
set /a r=n%%26
set "ch=!letters:~%r%,1!"
set "result=%ch%%result%"
set /a n=n/26
if %n% gtr 0 goto loopAlpha4
:padLoop
if "!result:~3!"=="" (
    set "result=a!result!"
    goto padLoop
)
endlocal & set "%2=%result%"
exit /b

:: ────────────────────────────────────────────────
::  CRYPT MODE (GUID)
:: ────────────────────────────────────────────────
:RECRYPT
call :TMPNAMES
set /a done=0
for /f "delims=" %%f in ('dir /b "%folder%\__tmp*"') do (
    set /a done+=1
    for /f %%g in ('powershell -command "[guid]::NewGuid().ToString()"') do (
        ren "%folder%\%%f" "%%g%%~xf" 2>nul
    )
    call :BAR !done! %count%
)
goto FINISH

:: ────────────────────────────────────────────────
::  DATE MODE
:: ────────────────────────────────────────────────
:REDATE
call :TMPNAMES
set /a done=0
for /f "delims=" %%f in ('dir /b "%folder%\__tmp*"') do (
    set /a done+=1
    for /f %%g in ('powershell -command "(Get-Item \"%folder%\%%f\").LastWriteTime.ToString(\"dd_MM_yyyy\")"') do (
        ren "%folder%\%%f" "%%g_!done!%%~xf" 2>nul
    )
    call :BAR !done! %count%
)
goto FINISH

:: ────────────────────────────────────────────────
::  SIZE MODE
:: ────────────────────────────────────────────────
:RESIZE
call :TMPNAMES
set /a done=0
for /f "delims=" %%f in ('dir /b "%folder%\__tmp*"') do (
    set /a done+=1
    for /f %%g in ('powershell -command "(Get-Item \"%folder%\%%f\").Length"') do (
        set /a sizeKB=%%g/1024
        ren "%folder%\%%f" "!sizeKB!KB_!done!%%~xf" 2>nul
    )
    call :BAR !done! %count%
)
goto FINISH

:: ────────────────────────────────────────────────
::  FINISH SCREEN
:: ────────────────────────────────────────────────
:FINISH
echo.
echo               [ Task Completed ]                 
echo.
echo  All files in "%folder%" have been renamed successfully.
echo.
echo  [Next Action]
echo    again → Rename again in the same folder
echo    new   → Choose a new folder
echo    home  → Return to main menu
echo    exit  → Quit program
echo.
set /p next="► Choice: "
if /i "%next%"=="again" goto MENU
if /i "%next%"=="new"   goto START
if /i "%next%"=="home"  goto INTRO
if /i "%next%"=="exit"  exit /b
goto FINISH

:: ────────────────────────────────────────────────
::  PROGRESS BAR
:: ────────────────────────────────────────────────
:BAR
set /a perc=(%1*100)/%2
set /a bars=perc/5
set "bar="
for /l %%i in (1,1,%bars%) do set "bar=!bar!█"
for /l %%i in (%bars%,1,20) do set "bar=!bar! "
echo [%bar%] Progress: %perc%%% (%1/%2)
exit /b
