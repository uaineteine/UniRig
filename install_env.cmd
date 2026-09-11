@echo off
setlocal

set "VENV_DIR=%~dp0.venv"
set "PYTHON_VERSION=3.11"
set "TORCH_VERSION=2.14.0"
set "CUDA_VERSION=cu132"
set "CPU_ONLY=1"

if not exist "%VENV_DIR%\Scripts\python.exe" (
	py -%PYTHON_VERSION% -m venv "%VENV_DIR%"
	if errorlevel 1 (
		echo Failed to create the Python %PYTHON_VERSION% virtual environment.
		exit /b 1
	)
)

call "%VENV_DIR%\Scripts\activate"
if errorlevel 1 exit /b 1

python -m pip install --upgrade pip
if errorlevel 1 exit /b 1

python -m pip install uv
if errorlevel 1 exit /b 1

if /I "%CPU_ONLY%"=="1" (
	python -m pip install "torch==%TORCH_VERSION%" torchvision
) else (
	python -m pip install "torch==%TORCH_VERSION%" torchvision --index-url https://download.pytorch.org/whl/%CUDA_VERSION%
)
if errorlevel 1 exit /b 1

uv pip install -r "%~dp0reqs\requirements_general.txt"
if errorlevel 1 exit /b 1

echo Environment setup complete: %VENV_DIR%
endlocal
