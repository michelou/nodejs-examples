@echo off
setlocal enabledelayedexpansion

rem enabled only for interactive debugging 
set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

rem for %%f in ("%~dp0..") do call %%~sf\setenv.bat
rem if not %ERRORLEVEL%==0 goto end

set _NODE_CMD=node.exe
set _NODE_OPTS=

set _JQ_CMD=jq.exe
set _JQ_OPTS=

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

if %_DEBUG%==1 echo [%_BASENAME%] %_JQ_CMD% .name %_CONFIG_FILE%
for /f %%n in ('%_JQ_CMD% .name %_CONFIG_FILE% 2^>NUL') do set _APP_NAME=%%~n
if "%_APP_NAME%"=="" (
    if %_DEBUG%==1 echo [%_BASENAME%] JSON field 'name' not found ^(%_CONFIG_FILE%^)
    for %%f in ("%~dp0\.") do set _DIR_NAME=%%~nf
	if %_DEBUG%==1 echo [%_BASENAME%] Use parent directory name ^(!_DIR_NAME!^)
	set _APP_NAME=!_DIR_NAME!-app
)

if exist "%_ROOT_DIR%config.json" (
    for /f %%i in ('%_JQ_CMD% .host "%_ROOT_DIR%config.json"') do set _HOST=%%~i
    for /f %%i in ('%_JQ_CMD% .port "%_ROOT_DIR%config.json"') do set _PORT=%%~i
)
if not defined _HOST set _HOST=localhost
if not defined _PORT set _PORT=8180
set _URL=http://!_HOST!:!_PORT!

rem ##########################################################################
rem ## Main

rem open url with default browser
if %_DEBUG%==1 echo [%_BASENAME%] start "" %_URL%
start "" %_URL%

set _ACTION=%~1
if "%_ACTION%"=="" set _ACTION=start

:node
if %_DEBUG%==1 echo [%_BASENAME%] %_NODE_CMD% %_NODE_OPTS% %_NODE_FILE%
%_NODE_CMD% %_NODE_OPTS% %_NODE_FILE%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] node execution failed ^(%_NODE_FILE%^)
	set _EXITCODE=1
    goto end
)
goto end

:pm2
if %_DEBUG%==1 echo [%_BASENAME%] %_PM2_CMD% %_PM2_OPTS% %_ACTION% %_NODE_FILE%
%_PM2_CMD% %_PM2_OPTS% %_ACTION% %_NODE_FILE%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] pm2 execution failed ^(%_NODE_FILE%^)
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
