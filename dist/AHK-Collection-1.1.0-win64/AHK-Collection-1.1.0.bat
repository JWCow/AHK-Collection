::@echo off
setlocal EnableDelayedExpansion

:: Check for administrative privileges
NET SESSION >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

echo AHK Collection Setup
echo ==================
echo.

:: Set paths with proper concatenation (moved to top for global use)
set "CURRENT_DIR=%~dp0"
set "SCRIPT_DIR=%CURRENT_DIR%AHK-Collection-1.1.0"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Debug output with quotes to show exact paths
echo [DEBUG] Current directory: "%CURRENT_DIR%"
echo [DEBUG] Script directory: "%SCRIPT_DIR%"

:: Function to check if AutoHotkey is installed
:: Check both registry and directory existence
set "AHK_INSTALL_DIR_V2=C:\Program Files\AutoHotkey\v2"
set "AHK_EXE_V2=%AHK_INSTALL_DIR_V2%\AutoHotkey.exe"

echo [i] Checking AutoHotkey installation...
echo [i] Checking registry entries...
reg query "HKLM\SOFTWARE\AutoHotkey" /ve >nul 2>&1
set "REG_CHECK=%ERRORLEVEL%"

echo [i] Checking installation directory...
if exist "%AHK_EXE_V2%" (
    set "DIR_CHECK=0"
) else (
    set "DIR_CHECK=1"
)

if %REG_CHECK% NEQ 0 (
    echo [!] Registry entries not found
) else (
    echo [✓] Registry entries found
)

if %DIR_CHECK% NEQ 0 (
    echo [!] Installation directory not found
) else (
    echo [✓] Installation directory found
)

if %REG_CHECK% NEQ 0 ( 
    echo AutoHotkey is not installed or registry entries are missing.
    echo Installing AutoHotkey v2...
    echo.
    
    set "INSTALLER="

    :: Check in current directory first
    if exist "%CURRENT_DIR%\AutoHotkey_2.0.18_setup.exe" (
        set "INSTALLER=%CURRENT_DIR%\AutoHotkey_2.0.18_setup.exe"
        echo [i] Found installer in current directory: "!INSTALLER!"
    )

    :: Check in script directory
    if "!INSTALLER!"=="" (
        if exist "%SCRIPT_DIR%\AutoHotkey_2.0.18_setup.exe" (
            set "INSTALLER=%SCRIPT_DIR%\AutoHotkey_2.0.18_setup.exe"
            echo [i] Found installer in script directory: "!INSTALLER!"
        )
    )

    :: Try wildcard in current directory
    if "!INSTALLER!"=="" (
        for /f "delims=" %%i in ('dir /b "%CURRENT_DIR%\AutoHotkey_*_setup.exe" 2^>nul') do (
            set "INSTALLER=%CURRENT_DIR%\%%i"
            echo [i] Found installer using wildcard in current directory: "!INSTALLER!"
        )
    )

    :: Try wildcard in script directory
    if "!INSTALLER!"=="" (
        for /f "delims=" %%i in ('dir /b "%SCRIPT_DIR%\AutoHotkey_*_setup.exe" 2^>nul') do (
            set "INSTALLER=%SCRIPT_DIR%\%%i"
            echo [i] Found installer using wildcard in script directory: "!INSTALLER!"
        )
    )

    if "!INSTALLER!"=="" (
        echo [!] Error: AutoHotkey installer not found!
        echo [!] Please ensure the installer is in one of these locations:
        echo [!] 1. "%CURRENT_DIR%"
        echo [!] 2. "%SCRIPT_DIR%"
        echo [i] Expected file: AutoHotkey_2.0.18_setup.exe or similar
        timeout /t 5
        exit /b 1
    )
    
    :: Run the AutoHotkey installer
    echo [i] Found installer: "!INSTALLER!"
    echo [i] Starting installation...
    start "" "!INSTALLER!"
    
    :: Wait for installation to complete by checking directory and executable
    echo [i] Waiting for installation to complete...
    set /a attempts=0
    
    :: Define expected installation paths
    set "AHK_INSTALL_DIR_V2=C:\Program Files\AutoHotkey\v2"
    set "AHK_EXE_V2=%AHK_INSTALL_DIR_V2%\AutoHotkey.exe"
    
    echo [i] Checking for installation in: "%AHK_INSTALL_DIR_V2%"
    
    :WAIT_LOOP
    :: Wait a bit before checking
    timeout /t 2 /nobreak >nul
    
    :: Check if AutoHotkey directory and executable exist
    if exist "%AHK_EXE_V2%" (
        echo [✓] Found AutoHotkey executable: "%AHK_EXE_V2%"
        echo [✓] AutoHotkey installation completed successfully!
        echo.
        goto INSTALL_COMPLETE
    ) else (
        set /a attempts+=1
        echo [i] Still installing... (!attempts! of 30 seconds)
        echo [i] Waiting for: "%AHK_EXE_V2%"
        
        if !attempts! LSS 30 (
            goto WAIT_LOOP
        ) else (
            echo [!] Failed to install AutoHotkey: Timeout
            echo [!] Could not find AutoHotkey in: "%AHK_INSTALL_DIR_V2%"
            echo [!] Please try running "!INSTALLER!" manually.
            timeout /t 5
            exit /b 1
        )
    )

:INSTALL_COMPLETE

echo Adding script to startup folder...
echo --------------------------------
echo.

:: Create shortcut using PowerShell
powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%STARTUP_FOLDER%\Windows_AHK_Startup_Keys_v2.lnk'); $SC.TargetPath = '%SCRIPT_DIR%\Windows_AHK_Startup_Keys_v2.ahk'; $SC.WorkingDirectory = '%SCRIPT_DIR%'; $SC.Save()"

if !ERRORLEVEL! EQU 0 (
    echo [✓] Successfully added script to Startup!
    echo [i] Startup location: "%STARTUP_FOLDER%"
    echo.
    echo [i] Starting AHK script...
    start "" "%SCRIPT_DIR%\Windows_AHK_Startup_Keys_v2.ahk"
    echo.
    echo [✓] Setup complete! The script will now run automatically when you start Windows.
    echo.
    echo [✓] Installation successful! Window will close in 5 seconds...
    timeout /t 5 >nul
) else (
    echo [!] Failed to add script to Startup.
    echo [!] Please ensure you're running this as administrator.
    echo.
    echo Press any key to exit...
    pause >nul
) 