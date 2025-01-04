@echo off
echo Creating distributable package...

:: Set variables
set "PACKAGE_NAME=AHK-Collection"
set "VERSION=1.1.0"
set "DIST_DIR=dist"
set "PACKAGE_DIR=%DIST_DIR%\%PACKAGE_NAME%-%VERSION%"

:: Create distribution directory
if exist "%DIST_DIR%" rd /s /q "%DIST_DIR%"
mkdir "%PACKAGE_DIR%"
mkdir "%PACKAGE_DIR%\individual_scripts"

:: Copy main files
echo Copying main files...
copy "Windows_AHK_Startup_Keys_v2.ahk" "%PACKAGE_DIR%"
copy "giphy_picker.html" "%PACKAGE_DIR%"
copy "install_startup.bat" "%PACKAGE_DIR%"
copy "README.md" "%PACKAGE_DIR%"
copy "LICENSE" "%PACKAGE_DIR%"
copy "CHANGELOG.md" "%PACKAGE_DIR%"

:: Copy individual scripts
echo Copying individual scripts...
copy "individual_scripts\*.ahk" "%PACKAGE_DIR%\individual_scripts"

:: Create ZIP file using PowerShell
echo Creating ZIP archive...
powershell -Command "Compress-Archive -Path '%PACKAGE_DIR%\*' -DestinationPath '%DIST_DIR%\%PACKAGE_NAME%-%VERSION%.zip' -Force"

:: Clean up temporary directory
rd /s /q "%PACKAGE_DIR%"

echo.
echo Distribution package created successfully!
echo Location: %DIST_DIR%\%PACKAGE_NAME%-%VERSION%.zip
echo.
pause 