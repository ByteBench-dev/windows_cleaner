@echo off

:menu
cls
echo.
echo   _______
echo  /      \
echo |  Windows Cleaner  |
echo  \      /
echo.
echo 1. Delete files in temporary folders
echo 2. Option 2
echo 3. Exit

set /p choice=Choose an option: 

if %choice%==1 goto option1
if %choice%==2 goto option2
if %choice%==3 goto option3
if %choice%==4 goto option4

goto menu

:option1
echo Deleting files in Temp folders...
del /q /s /f "%temp%\*"
echo Files deleted!
pause
goto menu

:option2
echo Going into site...
open https://github.com/ByteBench-dev/windows_cleaner
pause
goto menu

:option4
echo Exiting...
Exit