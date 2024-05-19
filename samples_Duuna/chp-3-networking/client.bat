@echo off

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

for /f "delims=" %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for /f "delims=" %%f in ("%~dp0..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _CURL_CMD=curl.exe
set _CURL_OPTS=-H "User-Agent: Mozilla/5.0"
if %_DEBUG%==1 set _CURL_OPTS=-v %_CURL_OPTS%

set _SIEGE_CMD=siege.exe
call :cygpath %SIEGE_HOME%
set _SIEGE_OPTS=--rc=%_CYGPATH%/siege.config -g
if %_DEBUG%==1 set _SIEGE_OPTS=--verbose %_SIEGE_OPTS%

set _URL=http://127.0.0.1:3000/

rem ##########################################################################
rem ## Main

goto siege

:curl
set _GET_URL=%_URL%
set _GET_HEADERS=

if %_DEBUG%==1 echo [%_BASENAME%] %_CURL_CMD% %_CURL_OPTS% %_GET_URL% %_GET_HEADERS%
%_CURL_CMD% %_CURL_OPTS% %_GET_URL% %_GET_HEADERS%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] curl get operation failed ^(%_GET_URL%^)
    set _EXITCODE=1
    goto end
)
goto end

:siege
if %_DEBUG%==1 echo [%_BASENAME%] %_SIEGE_CMD% %_SIEGE_OPTS% %_URL%
%_SIEGE_CMD% %_SIEGE_OPTS% %_URL%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] Siege get operation failed ^(%_URL%^)
    set _EXITCODE=1
    goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

:cygpath
set "__PATH=%~1"
set "__PATH=%__PATH:c:=c%"
set "_CYGPATH=/cygdrive/%__PATH:\=/%"
goto :end

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
