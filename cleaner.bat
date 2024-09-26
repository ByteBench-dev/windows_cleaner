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
echo 3. Disable Windows Telemetry(tested in Windows 11 only)
echo 4. Exit

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

:option3 
echo Disabling Windows Telemetry...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
echo Telemetry disabled! Disabling more telemetry...
@echo off

taskkill /im diagtrack.exe /f

echo " " > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
cacls C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl /D SYSTEM

sc stop DiagTrack
sc config DiagTrack start= disabled

sc stop WbioSrvc
sc config WbioSrvc start= disabled

sc stop lfsvc
sc config lfsvc start= disabled
pause
goto menu

:option4
echo Exiting...
Exit