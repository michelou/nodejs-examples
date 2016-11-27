@echo off
setlocal enabledelayedexpansion

rem enabled only for interactive debugging 
set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

set _ARG=%~1
if defined _ARG if 0%_ARG% gtr 0 (
    if %_DEBUG%==1 echo [%_BASENAME%] timeout /nobreak /t %_ARG% 1^>NUL
    timeout /nobreak /t %_ARG% 1>NUL
)

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for %%f in ("%~dp0..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _CURL_CMD=curl.exe
set _CURL_OPTS=-H "User-Agent: Mozilla/5.0"
if %_DEBUG%==1 set _CURL_OPTS=-v %_CURL_OPTS%

set _JQ_CMD=jq.exe
set _JQ_OPTS=

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

for %%i in (en de fr) do (
    set _CURL_OPTS_LANG=%_CURL_OPTS% --header "Accept-Language: %%i"

    if %_DEBUG%==1 echo [%_BASENAME%] %_CURL_CMD% !_CURL_OPTS_LANG! %_URL%
    %_CURL_CMD% %_CURL_OPTS_LANG% %_URL%
    if not %ERRORLEVEL%==0 (
        if %_DEBUG%==1 echo [%_BASENAME%] cURL operation failed ^(%_URL%^)
	    set _EXITCODE=1
	    goto end
    )
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
