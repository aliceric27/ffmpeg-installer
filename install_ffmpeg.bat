@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo FFmpeg Installer for Windows
echo ============================
echo.

:: Check administrator privileges
echo Checking permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrator privileges detected - installing to system PATH
    set "INSTALL_TYPE=system"
) else (
    echo Warning: No administrator privileges - installing to user PATH
    echo For system-wide installation, please run as administrator
    set "INSTALL_TYPE=user"
)
echo.

:: Set installation path
set "INSTALL_DIR=%USERPROFILE%\ffmpeg"
if "%INSTALL_TYPE%"=="system" (
    set "INSTALL_DIR=C:\ffmpeg"
)

echo Installation settings:
echo   Install location: %INSTALL_DIR%
echo   Environment variable: %INSTALL_TYPE%
echo.

:: Create installation directory
echo Creating installation directory...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
    if !errorlevel! neq 0 (
        echo Error: Cannot create directory %INSTALL_DIR%
        pause
        exit /b 1
    )
)

:: Download FFmpeg
echo.
echo Downloading FFmpeg...
echo Source: https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip' -OutFile '%INSTALL_DIR%\ffmpeg.zip' -UseBasicParsing"

if %errorlevel% neq 0 (
    echo Error: FFmpeg download failed
    pause
    exit /b 1
)

:: Extract files
echo.
echo Extracting FFmpeg...
powershell -Command "Expand-Archive -Path '%INSTALL_DIR%\ffmpeg.zip' -DestinationPath '%INSTALL_DIR%' -Force"

if %errorlevel% neq 0 (
    echo Error: FFmpeg extraction failed
    pause
    exit /b 1
)

:: Find bin directory
echo.
echo Configuring environment variables...
for /d %%i in ("%INSTALL_DIR%\ffmpeg-*") do (
    if exist "%%i\bin\ffmpeg.exe" (
        set "FFMPEG_BIN_PATH=%%i\bin"
        goto :found_bin
    )
)

echo Error: Cannot find FFmpeg executable
pause
exit /b 1

:found_bin
echo Found FFmpeg path: %FFMPEG_BIN_PATH%

:: Validate FFmpeg path before proceeding
if not exist "%FFMPEG_BIN_PATH%\ffmpeg.exe" (
    echo Error: FFmpeg executable not found at %FFMPEG_BIN_PATH%\ffmpeg.exe
    pause
    exit /b 1
)

:: Safely add to PATH using PowerShell with secure parameter passing
echo Checking and updating PATH environment variable...

if "%INSTALL_TYPE%"=="system" (
    echo Adding to system environment variables...
    set "TARGET_SCOPE=Machine"
) else (
    echo Adding to user environment variables...
    set "TARGET_SCOPE=User"
)

:: Set secure environment variables for PowerShell
set "FFMPEG_PATH_TO_ADD=%FFMPEG_BIN_PATH%"
set "TARGET_SCOPE_TO_USE=%TARGET_SCOPE%"

:: Execute PowerShell command with secure parameter passing
set "PS_COMMAND=try { $ffmpegPath = $env:FFMPEG_PATH_TO_ADD; $scope = [System.EnvironmentVariableTarget]::$env:TARGET_SCOPE_TO_USE; Write-Host 'Reading current PATH from registry...'; $currentPath = [System.Environment]::GetEnvironmentVariable('Path', $scope); if ([string]::IsNullOrEmpty($currentPath)) { $currentPath = ''; }; $pathElements = $currentPath -split ';' | Where-Object { $_.Trim() -ne '' }; if ($pathElements -notcontains $ffmpegPath) { Write-Host 'Adding FFmpeg to PATH...'; $newPath = ($pathElements + $ffmpegPath) -join ';'; [System.Environment]::SetEnvironmentVariable('Path', $newPath, $scope); Write-Host 'SUCCESS: FFmpeg path has been added to your PATH.'; Write-Host 'Please restart your terminal for the changes to take effect.'; } else { Write-Host 'INFO: FFmpeg path already exists in your PATH. No changes made.'; } } catch { Write-Error \"ERROR: Failed to update PATH - $_\"; exit 1; }"

powershell -NoProfile -ExecutionPolicy Bypass -Command "%PS_COMMAND%"

if !errorlevel! neq 0 (
    echo Error: Failed to update PATH environment variable
    echo Your PATH has not been modified
    pause
    exit /b 1
)

:: Clean up
echo.
echo Cleaning up temporary files...
if exist "%INSTALL_DIR%\ffmpeg.zip" (
    del "%INSTALL_DIR%\ffmpeg.zip"
    echo Deleted ffmpeg.zip
)

:: Verify installation
echo.
echo Verifying installation...
"%FFMPEG_BIN_PATH%\ffmpeg.exe" -version >nul 2>&1
if %errorlevel% equ 0 (
    echo SUCCESS: FFmpeg installed successfully!
) else (
    echo ERROR: FFmpeg verification failed
)

:: Display completion message
echo.
echo =====================================
echo        FFmpeg Installation Complete
echo =====================================
echo.
echo Installation details:
echo   Install location: %INSTALL_DIR%
echo   Executable path: %FFMPEG_BIN_PATH%
echo   Environment variable: Added to %INSTALL_TYPE% PATH
echo.
echo IMPORTANT:
echo Please restart your command prompt or PowerShell window
echo for the new environment variables to take effect
echo.
echo To verify installation:
echo   Open a new command window and type: ffmpeg -version
echo.

pause