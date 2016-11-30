@echo off
setlocal enabledelayedexpansion

set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for %%f in ("%~dp0..") do call %%~sf\setenv.bat %_LOCAL_DATABASE%
if not %_EXITCODE%==0 goto end

set _MONGO_CMD=mongo.exe
set _MONGO_OPTS=

set _INI_FILE=%_ROOT_DIR%%_BASENAME%.ini
if not exist "%_INI_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Missing ini file %_INI_FILE%
    set _EXITCODE=1
    goto end
)

for /f "tokens=1,2* delims==" %%i in (%_INI_FILE%) do (
    set _NAME=%%~i
    set _VALUE=%%~j
    if not "!_NAME!"=="" (
        rem trim value
        for /f "tokens=*" %%v in ("!_VALUE!") do set _VALUE=%%v
        set _!_NAME: =!=!_VALUE!
    )
)

for %%i in (MONGO_DB_URI MONGO_DB_USER MONGO_DB_PSWD) do (
    if not defined _%%i (
        if %_DEBUG%==1 echo [%_BASENAME%] Property %%i not defined
        set _EXITCODE=1
    )
)
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if %_DEBUG%==1 echo [%_BASENAME%] %_MONGO_CMD% %_MONGO_OPTS% %_MONGO_DB_URI%/sandbox -u %_MONGO_DB_USER% -p XXXXX
%_MONGO_CMD% %_MONGO_OPTS% %_MONGO_DB_URI%/sandbox -u %_MONGO_DB_USER% -p %_MONGO_DB_PSWD%
if not %ERRORLEVEL%==0 (
    echo Mongo shell execution failed
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
