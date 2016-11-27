@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _NODE_CMD=node.exe
set _NODE_OPTS=

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

set _CONFIG_FILE=%_ROOT_DIR%package.json
if not exist "%_CONFIG_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Configuration file not found ^(%_CONFIG_FILE%^)
    set _EXITCODE=1
	goto end
)

set _NODE_FILE=%_ROOT_DIR%app\%_BASENAME%.js
if not exist "%_NODE_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Node source file not found ^(%_NODE_FILE%^)
	set _EXITCODE=1
	goto end
)

if exist "%_ROOT_DIR%config.json" (
    for /f %%i in ('jq .host "%_ROOT_DIR%config.json" 2^>NUL') do set _HOST=%%~i
    for /f %%i in ('jq .port "%_ROOT_DIR%config.json" 2^>NUL') do set _PORT=%%~i
)
if not defined _HOST set _HOST=localhost
if not defined _PORT set _PORT=8180
set _URL=http://!_HOST!:!_PORT!

rem ##########################################################################
rem ## Main

rem open url with default browser
if %_DEBUG%==1 echo [%_BASENAME%] start "" %_URL%
start "" %_URL%

if %_DEBUG%==1 echo [%_BASENAME%] %_NODE_CMD% %_NODE_OPTS% %_NODE_FILE%
%_NODE_CMD% %_NODE_OPTS% %_NODE_FILE%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] Node execution failed ^(%_NODE_FILE%^)
	set _EXITCODE=1
    goto end
)

goto end

rem ##########################################################################
rem ## Subroutines

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal
