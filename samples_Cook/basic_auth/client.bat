@echo off

set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

set _ARG=%~1
if not "%_ARG%"=="" if %_ARG% gtr 0 (
    if %_DEBUG%==1 echo [%_BASENAME%] timeout /nobreak /t %_ARG% 1^>NUL
    timeout /nobreak /t %_ARG% 1>NUL
)

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for %%f in ("%~dp0..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _CURL_CMD=curl.exe
set _CURL_OPTS=-H "User-Agent: Mozilla/5.0"
if %_DEBUG%==1 set _CURL_OPTS=-v %_CURL_OPTS%

set _URL=http://127.0.0.1:8080/

rem ##########################################################################
rem ## Main

set _GET_URL=%_URL%
set _GET_HEADERS=

if %_DEBUG%==1 echo [%_BASENAME%] %_CURL_CMD% %_CURL_OPTS% %_GET_URL% %_GET_HEADERS%
%_CURL_CMD% %_CURL_OPTS% %_GET_URL% %_GET_HEADERS%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] curl get operation failed ^(%_GET_URL%^)
    set _EXITCODE=1
    goto end
)

set _POST_URL=%_URL%login
set _POST_HEADERS=-H "Content-Type: application/json" -H "{'username': 'foo', 'password': 'bar'}"

if %_DEBUG%==1 echo [%_BASENAME%] %_CURL_CMD% %_CURL_OPTS% -X POST %_POST_URL% %_POST_HEADERS%
%_CURL_CMD% %_CURL_OPTS% -X POST %_POST_URL% %_POST_HEADERS%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] curl post operation failed ^(%_POST_URL%^)
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
