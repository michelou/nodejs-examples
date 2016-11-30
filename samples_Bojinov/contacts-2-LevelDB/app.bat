@echo off
setlocal enabledelayedexpansion

rem enabled only for interactive debugging 
set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for %%f in ("%~dp0..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _NODE_CMD=node.exe
set _NODE_OPTS=

set _JQ_CMD=jq-win32.exe
set _JQ_OPTS=

set _NPM_CMD=npm.cmd
set _NPM_OPTS=

set _PM2_CMD=pm2.cmd
set _PM2_OPTS=

set _CONFIG_FILE=%ROOT_DIR%package.json

if %_DEBUG%==1 echo [%_BASENAME%] %_JQ_CMD% .name %_CONFIG_FILE%
for /f %%n in ('%_JQ_CMD% .name %_CONFIG_FILE% 2^>NUL') do set _APP_NAME=%%~n
if "%_APP_NAME%"=="" (
    if %_DEBUG%==1 echo [%_BASENAME%] JSON field 'name' not found ^(%_CONFIG_FILE%^)
    for %%f in ("%~dp0\.") do set _DIR_NAME=%%~nf
	if %_DEBUG%==1 echo [%_BASENAME%] Use parent directory name ^(!_DIR_NAME!^)
	set _APP_NAME=!_DIR_NAME!-app
)

set _NODE_FILE=%_ROOT_DIR%app\%_BASENAME%.js
if not exist "%_NODE_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Node source file not found ^(%_NODE_FILE%^)
	set _EXITCODE=1
	goto end
)

if exist "%_ROOT_DIR%config.json" (
    for /f %%i in ('jq .host "%_ROOT_DIR%config.json"') do set _HOST=%%~i
    for /f %%i in ('jq .port "%_ROOT_DIR%config.json"') do set _PORT=%%~i
)
if not defined _HOST set _HOST=localhost
if not defined _PORT set _PORT=8180
set _URL=http://!_HOST!:!_PORT!/contacts/+359777123456

rem ##########################################################################
rem ## Main

rem open url with default browser
if %_DEBUG%==1 echo [%_BASENAME%] start "" %_URL%
start "" %_URL%

set _ACTION=%~1
if "%_ACTION%"=="" set _ACTION=start

set NODE_ENV=production
if %_DEBUG%==1 set NODE_ENV=development

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
