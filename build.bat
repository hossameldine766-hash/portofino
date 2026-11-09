@echo off
chcp 65001 >nul
title Build Porto Bazar System
color 0A

cls
echo ============================================================
echo              Build Porto Bazar System
echo ============================================================
echo.

cd /d "%~dp0"
echo [0/6] Current folder: %cd%
echo.

if not exist "porto3.py" (
    echo [ERROR] porto3.py not found!
    pause
    exit /b 1
)
echo   [OK] porto3.py found
echo.

echo [1/6] Checking .venv folder...
if not exist ".venv" (
    echo [ERROR] .venv NOT found!
    pause
    exit /b 1
)
echo   [OK] .venv found
echo.

echo [2/6] Cleaning old build files...
if exist "dist" rmdir /s /q "dist" >nul 2>&1
if exist "build" rmdir /s /q "build" >nul 2>&1
if exist "PortoBazar.spec" del /q "PortoBazar.spec" >nul 2>&1
echo   [OK] Cleaned
echo.

echo [3/6] Activating virtual environment...
call ".venv\Scripts\activate.bat"
if errorlevel 1 (
    echo [ERROR] Failed to activate .venv!
    pause
    exit /b 1
)
echo   [OK] Activated
echo.

echo [4/6] Checking PyInstaller...
python -c "import PyInstaller" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] PyInstaller NOT installed!
    pause
    exit /b 1
)
echo   [OK] PyInstaller found
echo.

echo [5/6] Checking required files...
if not exist "logo_porto.png" echo   [WARN] logo_porto.png not found
if not exist "splash.png" echo   [WARN] splash.png not found
if not exist "app.ico" echo   [WARN] app.ico not found
echo   [OK] File check complete
echo.

echo [6/6] Building EXE...
echo.
echo Please wait 3-7 minutes. DO NOT close this window.
echo.

python -m PyInstaller --onefile --windowed ^
    --icon=app.ico ^
    --name="PortoBazar" ^
    --splash splash.png ^
    --add-data "logo_porto.jpg;." ^
    --add-data "splash.png;." ^
    --add-data "app.ico;." ^
    --hidden-import=tkcalendar ^
    --hidden-import=PIL._tkinter_finder ^
    --hidden-import=bidi ^
    --hidden-import=arabic_reshaper ^
    --hidden-import=openpyxl ^
    --hidden-import=openpyxl.drawing ^
    --hidden-import=openpyxl.drawing.image ^
    --hidden-import=openpyxl.styles ^
    --hidden-import=pyi_splash ^
    --collect-all openpyxl ^
    --clean ^
    porto3.py

if errorlevel 1 (
    echo.
    echo ============================================================
    echo  [ERROR] Build FAILED!
    echo ============================================================
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  [SUCCESS] Build completed!
echo.
echo  File: dist\PortoBazar.exe
echo ============================================================
echo.

if exist "dist" (
    echo Opening dist folder...
    start "" "dist"
)

echo.
echo Done! Press any key to close...
pause >nul