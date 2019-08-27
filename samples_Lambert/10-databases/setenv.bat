@echo off
setlocal enabledelayedexpansion

if defined DEBUG ( set _DEBUG=1 ) else ( set _DEBUG=0 )

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

call :args %*
if not %_EXITCODE%==0 goto end

set _DATA_DIR=c:\temp\MongoDB\data
if not exist "%_DATA_DIR%" (
    mkdir "%_DATA_DIR%" 1>NUL
    if not !ERRORLEVEL!==0 (
        echo Failed to create data directory %_DATA_DIR% 1>&2
        set _EXITCODE=1
        goto end
    )
)
rem set _LOG_FILE=C:\temp\mongod_log.txt

rem ##########################################################################
rem ## Main

set _MONGO_PATH=

call :mongod
if not %_EXITCODE%==0 goto end

if /i "%_ACTION%"=="start" (
    rem mongod --dbpath "%_DATA_DIR% --fork --logpath %_LOG_FILE% --logappend
    if %_VERBOSE%==1 echo mongod.exe --dbpath "%_DATA_DIR%"
    mongod.exe --dbpath "%_DATA_DIR%" 2>&1
    if not !ERRORLEVEL!==0 (
        if %_DEBUG%==1 echo [%_BASENAME%] Failed to start MongoDB daemon
        set EXITCODE=1
        goto end
    )
) else if /i "%_ACTION%"=="stop" (
    if %_VERBOSE%==1 echo mongo.exe admin --eval "db.shutdownServer()"
    mongo.exe admin --eval "db.shutdownServer()" 2>&1
    if not !ERRORLEVEL!==0 (
        goto end
    )
) else (
    if %_VERBOSE%==1 echo mongod.exe --dbpath "%_DATA_DIR%" --sysinfo
    mongod.exe --dbpath "%_DATA_DIR%" --sysinfo
    if not !ERRORLEVEL!==0 (
        if %_DEBUG%==1 echo [%_BASENAME%] Failed to get status of MongoDB daemon
        set EXITCODE=1
        goto end
    )
)

goto end

rem ##########################################################################
rem ## Subroutines

rem input parameter: %*
:args
set _ACTION=info
set _VERBOSE=0
set __N=0
:args_loop
set __ARG=%~1
if not defined __ARG (
    goto args_done
) else if not "%__ARG:~0,1%"=="-" (
    set /a __N=!__N!+1
)
if /i "%__ARG%"=="help" ( call :help & goto :eof
) else if /i "%__ARG%"=="start" ( set _ACTION=start
) else if /i "%__ARG%"=="stop" ( set _ACTION=stop
) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
) else (
    echo %_BASENAME%: Unknown subcommand %__ARG% 1>&2
    set _EXITCODE=1
    goto :eof
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 echo [%_BASENAME%] _ACTION=%_ACTION% _VERBOSE=%_VERBOSE%
goto :eof

:help
echo Usage: setenv { options ^| subcommands }
echo   Options:
echo     -verbose         display environment settings
echo   Subcommands:
echo     help             display this help message
echo     start            start the MongoDB daemon
echo     stop             stop the MongoDB daemon
goto :eof

:mongod
where /q mongod.exe
if %ERRORLEVEL%==0 (
    if not defined _MONGO_PATH (
        for /f "delims=" %%i in ('where /f mongod.exe 2^>NUL') do set "_MONGO_PATH=;%%~dpsi"
    )
    goto :eof
)
if defined MONGO_HOME (
    set _MONGO_HOME=%MONGO_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable MONGO_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\mongodb-win32-x86_64-*" 2^>NUL') do set _MONGO_HOME=!_PATH!\%%f
    if not defined _MONGO_HOME (
        set _PATH=C:\Progra~1
        for /f %%f in ('dir /ad /b "!_PATH!\MongoDB*" 2^>NUL') do set _MONGO_HOME=!_PATH!\%%f
    )
    if defined _MONGO_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default MongoDB installation directory !_MONGO_HOME! 1>&2
    )
)
if not defined _MONGO_BIN_DIR (
    for /f "delims=" %%i in ('where /f /r "%_MONGO_HOME%" mongod.exe 2^>NUL') do set _MONGO_BIN_DIR=%%~dpsi
)
if not exist "%_MONGO_BIN_DIR%\mongod.exe" (
    echo Error: MongoDB executable not found ^(%_MONGO_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MONGO_PATH=;%_MONGO_BIN_DIR%"
goto :eof

:print_env
set __WHERE_ARGS=
where /q npm.cmd
if %ERRORLEVEL%==0 (
    for /f %%i in ('node.exe --version') do echo NODE_VERSION=%%i
    for /f %%i in ('npm.cmd --version') do echo NPM_VERSION=%%i
    set __WHERE_ARGS=%__WHERE_ARGS% node.exe npm.cmd
)
where /q mongod.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('mongod.exe --version ^| findstr "^db"') do echo MONGOD_VERSION=%%k
    set __WHERE_ARGS=%__WHERE_ARGS% mongod.exe
)
where %__WHERE_ARGS%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
endlocal & (
    if not defined NODE_HOME set NODE_HOME=%_NODE_HOME%
    set "PATH=%PATH%%_MONGO_PATH%"
    if %_VERBOSE%==1 call :print_env
    if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)