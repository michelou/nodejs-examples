@echo off
setlocal enabledelayedexpansion

rem enabled only for interactive debugging 
set _DEBUG=1

set _ARG1=%~1
if "%_ARG1%"=="de" ( set _LANG=de
) else ( set _LANG=en
)

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

if defined CURL_HOME (
    set _CURL_HOME=%CURL_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable CURL_HOME
) else (
    where /q curl.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f curl.exe') do set _CURL_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of cURL executable found in PATH
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\curl-*" 2^>NUL') do set _CURL_HOME=!_PATH!\%%f
        if %_DEBUG%==1 echo [%_BASENAME%] Using default cURL installation directory !_CURL_HOME!
    )
)
if not exist "%_CURL_HOME%\curl.exe" (
    if %_DEBUG%==1 echo [%_BASENAME%] cURL installation directory %_CURL_HOME% not found
    set _EXITCODE=1
    goto end
)
set _CURL_CMD=%_CURL_HOME%\curl.exe
set _CURL_OPTS=-H "Accept-Language: %_LANG%"
if %_DEBUG%==1 set _CURL_OPTS=-v %_CURL_OPTS%

if defined JQ_HOME (
    set _JQ_HOME=%JQ_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable JQ_HOME
) else (
    where /q jq.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f jq.exe') do set _JQ_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of jq executable found in PATH
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\jq-*" 2^>NUL') do set _JQ_HOME=!_PATH!\%%f
        if %_DEBUG%==1 echo [%_BASENAME%] Using default jq installation directory !_JQ_HOME!
    )
)
if not exist "%_JQ_HOME%\jq.exe" (
    if %_DEBUG%==1 echo [%_BASENAME%] jq installation directory %_JQ_HOME% not found
    set _EXITCODE=1
    goto end
)
set _JQ_CMD=%_JQ_HOME%\jq.exe
set _JQ_OPTS=

set _CONFIG_FILE=%_ROOT_DIR%config.json
if not exist "%_CONFIG_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Config file not found ^(%_CONFIG_FILE%^)
    set _EXITCODE=1
    goto end
)

rem ##########################################################################
rem ## Main

for /f %%i in ('%_JQ_CMD% .host "%_CONFIG_FILE%"') do set _HOST=%%~i
for /f %%i in ('%_JQ_CMD% .port "%_CONFIG_FILE%"') do set _PORT=%%~i
set _URL=http://%_HOST%:%_PORT%

if %_DEBUG%==1 echo [%_BASENAME%] %_CURL_CMD% %_CURL_OPTS% %_URL%
%_CURL_CMD% %_CURL_OPTS% %_URL%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] cURL operation failed ^(%_URL%^)
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
