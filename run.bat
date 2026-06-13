@echo off
echo === Docker Homework3 Project ===

if "%1"=="" goto help
if "%1"=="build_generator" goto build_generator
if "%1"=="run_generator" goto run_generator
if "%1"=="create_local_data" goto create_local_data
if "%1"=="build_reporter" goto build_reporter
if "%1"=="run_reporter" goto run_reporter
if "%1"=="structure" goto structure
if "%1"=="clear_data" goto clear_data
if "%1"=="inside_generator" goto inside_generator
if "%1"=="inside_reporter" goto inside_reporter
goto help

:build_generator
echo Building generator image...
docker build -f Dockerfile.generator -t generate-app .
echo Done!
goto :eof

:run_generator
echo Running generator...
if not exist data mkdir data
docker run --rm -v "%cd%/data:/data" generate-app
echo Generated data/data.csv
goto :eof

:create_local_data
echo Creating local data...
if not exist local_data mkdir local_data
python generate.py local_data
echo Generated local_data/data.csv
goto :eof

:build_reporter
echo Building reporter image...
docker build -f Dockerfile.reporter -t report-app .
echo Done!
goto :eof

:run_reporter
echo Running reporter...
if not exist data mkdir data
if not exist data\data.csv (
    echo ERROR: data/data.csv not found. Run "run.bat run_generator" first
    exit /b 1
)
docker run --rm -v "%cd%/data:/data" report-app
echo Generated data/report.html
goto :eof

:structure
echo Project structure:
dir /s /b
goto :eof

:clear_data
echo Cleaning data directory...
if exist data\*.csv del data\*.csv
if exist data\*.html del data\*.html
echo Done!
goto :eof

:inside_generator
echo Entering generator container...
docker run --rm -it -v "%cd%/data:/data" --entrypoint sh generate-app
goto :eof

:inside_reporter
echo Entering reporter container...
docker run --rm -it -v "%cd%/data:/data" --entrypoint sh report-app
goto :eof

:help
echo Available commands:
echo   run.bat build_generator
echo   run.bat run_generator
echo   run.bat create_local_data
echo   run.bat build_reporter
echo   run.bat run_reporter
echo   run.bat structure
echo   run.bat clear_data
echo   run.bat inside_generator
echo   run.bat inside_reporter