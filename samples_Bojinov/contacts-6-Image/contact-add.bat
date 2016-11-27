@echo off
setlocal enabledelayedexpansion

rem enabled only for interactive debugging 
set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

if defined CURL_HOME (
    set _CURL_HOME=%CURL_HOME%
) else (
    if %_DEBUG%==1 echo [%_BASENAME%] Environment variable CURL_HOME is not defined
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

set _JSON_FILE=%_ROOT_DIR%\contact.json
if not exist "%_JSON_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] JSON file not found ^(%_JSON_FILE%^)
    set _EXITCODE=1
	goto end
)

set _CURL_CMD=%_CURL_HOME%\curl.exe
set _CURL_OPTS=-H "Content-Type: application/json" -X PUT -d "@%_JSON_FILE%"
if %_DEBUG%==1 set _CURL_OPTS=-v %_CURL_OPTS%

rem ##########################################################################
rem ## Main

set _URL=http://127.0.0.1:8180/contacts

if %_DEBUG%==1 echo [%_BASENAME%] %_CURL_CMD% %_CURL_OPTS% %_URL%
%_CURL_CMD% %_CURL_OPTS% %_URL%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] cUrl operation failed
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
