@echo off
setlocal enabledelayedexpansion

rem if "%1"=="" goto noarg
rem if not exist %1\* goto noarg

echo Installing build dependencies...
python -m pip install --upgrade pip
rem python -m pip install setuptools build scikit-build-core ninja cmake conan swig
python -m pip install conan swig

REM Check if Conan default profile exists
conan profile list | findstr /C:"default" >nul
IF ERRORLEVEL 1 (
    echo Conan default profile not found. Detecting...
    conan profile detect -f
) ELSE (
    echo Conan default profile already exists
)

REM Sync version from C++ header
REM Set path to Python executable (adjust if needed)
set PYTHON_EXE=python

REM Path to the C++ header
set HEADER_FILE=ext\ims-lib\include\LibVersion.h

REM Run the Python script
%PYTHON_EXE% sync_version.py %HEADER_FILE%

REM Check for errors
IF ERRORLEVEL 1 (
    echo Failed to sync version!
    exit /b 1
)        

rmdir /S /Q build

conan install . --profile default -s build_type=Release -s compiler.cppstd=17 --build=missing -of .
cd build
call generators\conanbuild.bat
cmake -S .. -B . -DCMAKE_TOOLCHAIN_FILE=generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release
call generators\deactivate_conanbuild.bat
cd ..

goto end

:noarg
echo "usage: build.bat <output folder>"
echo "e.g. build.bat .\venv"

:end
echo on