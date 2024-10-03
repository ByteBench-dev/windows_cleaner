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
echo 2. Disable Windows Telemetry(tested in Windows 11 only)
echo 3. Optimize C: Disk
echo 4. Restore system files
echo 5. Clean registry
echo 5. Exit

set /p choice=Choose an option: 

if %choice%==1 goto option1
if %choice%==2 goto option2
if %choice%==3 goto option3
if %choice%==4 goto option4
if %choice%==5 goto option5
if %choice%==6 goto option6

goto menu

:option1
cls
echo Deleting files in Temp folders...
del /q /s /f %temp%\*.*
del /q /s /f %tmp%\*.*
del /q /s /f %systemdrive%\*.tmp
del /q /s /f %systemdrive%\*._mp
del /q /s /f %AppData%\temp\*.*
del /q /s /f %HomePath%\AppData\LocalLow\Temp\*.*
echo Files deleted!
pause
goto menu

:option2
echo Disabling Windows Telemetry...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
echo Telemetry disabled! Disabling more telemetry...

:: Error handling for taskkill
taskkill /im diagtrack.exe /f >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Unable to terminate diagtrack.exe process.
    pause
) else (
    echo diagtrack.exe process terminated successfully.
)

echo " " > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
icacls C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl /D SYSTEM

sc stop DiagTrack
sc config DiagTrack start= disabled

sc stop WbioSrvc
sc config WbioSrvc start= disabled

sc stop lfsvc
sc config lfsvc start= disabled
pause
goto menu
)

:option3
cls
defrag C: /O /W /V /U
chkdsk C: /f /r /x
echo "Optimization completed"
pause
goto menu

:option4
sfc /scannow
dism /online /cleanup-image /scanhealth
dism /online /cleanup-image /restorehealth
pause
goto menu

:option5
@echo off
setlocal enabledelayedexpansion

:: Set registry keys to clean
set "reg_keys_to_clean=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

:: Set registry values to clean
set "reg_values_to_clean=IconCache_*"

:: Create a system restore point
echo Creating a system restore point...
powershell -Command "Checkpoint-Computer -Description 'Registry Cleaning' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
if %errorlevel% neq 0 (
    echo Error creating system restore point!
    pause
    exit /b 1
)

:: Clean registry keys
echo Cleaning registry keys...
for /f "tokens=2 delims==" %%a in ('reg query "%reg_keys_to_clean%"') do (
    reg delete "%%a" /f >nul 2>&1
    if %errorlevel% neq 0 (
        echo Error deleting registry key: %%a
        pause
        exit /b 1
    )
)

:: Clean registry values
echo Cleaning registry values...
for /f "tokens=2 delims==" %%a in ('reg query "%reg_keys_to_clean%" /v "%reg_values_to_clean%"') do (
    reg delete "%%a" /v "%%~b" /f >nul 2>&1
    if %errorlevel% neq 0 (
        echo Error deleting registry value: %%a\%%~b
        pause
        exit /b 1
    )
)

:: Compact registry
echo Compacting registry...
reg compact >nul 2>&1
if %errorlevel% neq 0 (
    echo Error compacting registry!
    pause
    exit /b 1
)

echo Registry cleaning complete!
pause

:option6
Exit