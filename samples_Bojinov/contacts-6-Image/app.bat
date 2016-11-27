@echo off
setlocal enabledelayedexpansion

rem enabled only for interactive debugging 
set _DEBUG=1

rem enabled to access local database
set _LOCAL_DATABASE=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for %%f in ("%~dp0..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _NODE_CMD=node.exe
set _NODE_OPTS=

set _JQ_CMD=jq.exe
set _JQ_OPTS=

set _MONGOD_CMD=mongod.exe
set _MONGOD_OPTS=

set _CONFIG_FILE=%_ROOT_DIR%package.json
rem test for file existence performed in setenv.bat

if %_DEBUG%==1 echo [%_BASENAME%] %_JQ_CMD% .name %_CONFIG_FILE%
for /f %%n in ('%_JQ_CMD% .name "%_CONFIG_FILE%" 2^>NUL') do set _APP_NAME=%%~n
if "%_APP_NAME%"=="" (
    if %_DEBUG%==1 echo [%_BASENAME%] Field 'name' not found ^(%_CONFIG_FILE%^)
    for %%f in ("%~dp0\.") do set _DIR_NAME=%%~nf
	if %_DEBUG%==1 echo [%_BASENAME%] Use parent directory name ^(!_DIR_NAME!^)
	set _APP_NAME=!_DIR_NAME!-app
)

set _CONFIG_FILE=%_ROOT_DIR%config.json
if not exist "%_ROOT_DIR%config.json" (
    if %_DEBUG%==1 echo [%_BASENAME%] Configuration file not found ^(%_CONFIG_FILE%^)
    set _EXITCODE=1
    goto end
)

if %_DEBUG%==1 echo [%_BASENAME%] %_JQ_CMD% .dbpath %_CONFIG_FILE%
for /f %%n in ('%_JQ_CMD% .dbpath "%_CONFIG_FILE%" 2^>NUL') do set _MONGO_DBPATH=%%~n
if "%_MONGO_DBPATH%"=="" (
    if %_DEBUG%==1 echo [%_BASENAME%] Field 'dbpath' not found ^(%_CONFIG_FILE%^)
	set _MONGO_DBPATH=C:\Temp\MongoDB
)
if not exist "%_MONGO_DBPATH%" mkdir "%_MONGO_DBPATH%"
set _MONGOD_OPTS=--dbpath %_MONGO_DBPATH% --httpinterface --rest

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
set _URL=http://%_HOST%:%_PORT%/contacts

set _NODE_FILE=%_ROOT_DIR%app\%_BASENAME%.js
if not exist "%_NODE_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Node source file not found
    set _EXITCODE=1
    goto end
)

rem ##########################################################################
rem ## Main

if %_LOCAL_DATABASE%==1 (
    set _JQ_KEY=.local_uri
    set _IS_LOCAL=true
) else (
    set _JQ_KEY=.remote_uri
    set _IS_LOCAL=false
)
for /f %%i in ('%_JQ_CMD% %_JQ_KEY% "%_CONFIG_FILE%" 2^>NUL') do set _URI=%%~i
echo module.exports = { uri: '%_URI%', is_local: %_IS_LOCAL% } > %_ROOT_DIR%app\db.js

set _ACTION=%~1
if "%_ACTION%"=="" set _ACTION=start

set NODE_ENV=production
if %_DEBUG%==1 set NODE_ENV=development

if %_LOCAL_DATABASE%==1 (
    call :mongod
    if not %ERRORLEVEL%==0 (
        if %_DEBUG%==1 echo [%_BASENAME%] MongoDB daemon not started
	    set _EXITCODE=1
        goto end
    )
)

rem open url with default browser
if %_DEBUG%==1 echo [%_BASENAME%] start "" %_URL%
start "" %_URL%

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

:mongod
set _TASK_NAME=mongod.exe
for /f %%i in ('tasklist /nh /fi "Imagename eq %_TASK_NAME%" 2^>NUL') do (
    set _LINE=%%i
	if "!_LINE:~0,10!"=="%_TASK_NAME%" goto :eof
)
if %_DEBUG%==1 echo [%_BASENAME%] start "%_TASK_NAME%" %_MONGOD_CMD% %_MONGOD_OPTS%
start "%_TASK_NAME%" %_MONGOD_CMD% %_MONGOD_OPTS%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] mongod execution failed
	set _EXITCODE=1
    goto end
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal
