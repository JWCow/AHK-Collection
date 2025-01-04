@echo off
echo Adding Windows_AHK_Startup_Keys_v2.ahk to Startup folder...

:: Get the current directory where the batch file is located
set "SCRIPT_DIR=%~dp0"

:: Use environment variable for AppData to get Startup folder path
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Create shortcut instead of copying the file
powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%STARTUP_FOLDER%\Windows_AHK_Startup_Keys_v2.lnk'); $SC.TargetPath = '%SCRIPT_DIR%Windows_AHK_Startup_Keys_v2.ahk'; $SC.WorkingDirectory = '%SCRIPT_DIR%'; $SC.Save()"

if %ERRORLEVEL% EQU 0 (
    echo Successfully added script to Startup!
    echo Startup location: %STARTUP_FOLDER%
) else (
    echo Failed to add script to Startup.
    echo Please try running this file as administrator.
)

pause 