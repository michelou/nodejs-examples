@echo off
setlocal enabledelayedexpansion

set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

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

for %%i in (MONGO_HOST MONGO_PORT MONGO_USER) do (
    if not defined _%%i (
        if %_DEBUG%==1 echo [%_BASENAME%] Missing value for parameter _%%i in file %_INI_FILE%
        set _EXITCODE=1
    )
)
if not %_EXITCODE%==0 goto end

rem C:\Program Files\MongoDB\Server\3.2\bin
if defined MONGO_HOME (
    set _MONGO_HOME=%MONGO_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable MONGO_HOME
) else (
    where /q mongoexport.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f mongoexport.exe') do set _MONGO_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of MongoDB executable found in PATH
    ) else (
        set _PATH=C:\Progra~1\MongoDB
        for /f "delims=" %%i in ('where /r "!_PATH!" mongoexport.exe 2^>NUL') do set _MONGO_BIN_DIR=%%~dpsi
        for %%f in ("!_MONGO_BIN_DIR!..") do set _MONGO_HOME=%%~sf
        if %_DEBUG%==1 echo [%_BASENAME%] Using default MongoDB installation directory !_MONGO_HOME!
    )
)
if not exist "%_MONGO_HOME%\bin\mongoexport.exe" (
    if %_DEBUG%==1 echo [%_BASENAME%] MongoDB installation directory not found ^(%_MONGO_HOME%^)
    set _EXITCODE=1
    goto end
)

set _MONGOEXPORT_CMD=%_MONGO_HOME%\bin\mongoexport.exe
set _MONGOEXPORT_OPTS=

rem ##########################################################################
rem ## Main

for %%i in (contacts users) do (
    set _COLLECTION=%%i
    set _OUTFILE=%_ROOT_DIR%%%i.json
    if %_DEBUG%==1 echo [%_BASENAME%] %_MONGOEXPORT_CMD% -h %_MONGO_HOST%:%_MONGO_PORT% -d sandbox -c !_COLLECTION! -u %_MONGO_USER% -p XXXXXX -o !_OUTFILE!
    %_MONGOEXPORT_CMD% -h %_MONGO_HOST%:%_MONGO_PORT% -d sandbox -c !_COLLECTION! -u %_MONGO_USER% -p %_MONGO_PSWD% -o !_OUTFILE!
    if not !ERRORLEVEL!==0 (
        if %_DEBUG%==1 echo [%_BASENAME%] Failed to export collection !_COLLECTION!
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
