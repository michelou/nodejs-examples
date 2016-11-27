@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for %%f in ("%~dp0..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _NODE_CMD=node.exe
set _NODE_OPTS=

set _NPM_CMD=npm.cmd
set _NPM_OPTS=

set _JQ_CMD=jq.exe
set _JQ_OPTS=

set _NODE_FILE=%_ROOT_DIR%app\%_BASENAME%.js
if not exist "%_NODE_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Node source file not found ^(%_NODE_FILE%^)
	set _EXITCODE=1
	goto end
)

set _CONFIG_FILE=%_ROOT_DIR%config.json
if not exist "%_CONFIG_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Config file not found ^(%_CONFIG_FILE%^)
    set _EXITCODE=1
    goto end
)
for /f %%i in ('%_JQ_CMD% .host "%_CONFIG_FILE%" 2^>NUL') do set _HOST=%%~i
if "%_HOST%"=="" (
    if %_DEBUG%==1 echo [%_BASENAME%] Field 'host' not found ^(%_CONFIG_FILE%^)
    set _HOST=localhost
)
for /f %%i in ('%_JQ_CMD% .port "%_CONFIG_FILE%" 2^>NUL') do set _PORT=%%~i
if "%_PORT%"=="" (
    if %_DEBUG%==1 echo [%_BASENAME%] Field 'port' not found ^(%_CONFIG_FILE%^)
    set _PORT=8180
)
set _URL=http://%_HOST%:%_PORT%

rem ##########################################################################
rem ## Main

if %_DEBUG%==1 echo [%_BASENAME%] start "" %_URL%
start "" %_URL%

if %_DEBUG%==1 echo [%_BASENAME%] start "cmd.exe" %_ROOT_DIR%client.bat 1
start "cmd.exe" %_ROOT_DIR%client.bat 1

if not exist "%_ROOT_DIR%node_modules" (
    if %_DEBUG%==1 echo [%_BASENAME%] %_NPM_CMD% install
    ( cd %_ROOT_DIR% && %_NPM_CMD% install )
)

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
