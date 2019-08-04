@echo off
setlocal enabledelayedexpansion

if defined DEBUG ( set _DEBUG=1 ) else ( set _DEBUG=0 )

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

call :args %*
if not %_EXITCODE%==0 goto end
if %_HELP%==1 call :help & exit /b %_EXITCODE%

rem ##########################################################################
rem ## Main

set _GIT_PATH=
set _MONGO_PATH=
set _CURL_PATH=

call :git
if not %_EXITCODE%==0 goto end

call :npm
if not %_EXITCODE%==0 goto end

call :pm2
if not %_EXITCODE%==0 goto end

call :mongod
if not %_EXITCODE%==0 goto end

call :curl
if not %_EXITCODE%==0 goto end

goto end

rem ##########################################################################
rem ## Subroutines

rem input parameter: %*
:args
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set __ARG=%~1
if not defined __ARG (
    goto args_done
) else if not "%__ARG:~0,1%"=="-" (
    set /a __N=!__N!+1
)
if /i "%__ARG%"=="help" ( set _HELP=1 & goto args_done
) else if /i "%__ARG%"=="-debug" ( set _DEBUG=1
) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
) else (
    echo Error: Unknown subcommand %__ARG% 1>&2
    set _EXITCODE=1
    goto :eof
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 echo [%_BASENAME%] _VERBOSE=%_VERBOSE%
goto :eof

:help
echo Usage: setenv { options ^| subcommands }
echo   Options:
echo     -debug      show commands executed by this script
echo     -verbose    display progress messages
echo   Subcommands:
echo     help        display this help message
goto :eof

rem postcondition: NODE_HOME is defined and valid
:npm
set _NODE_HOME=

set __NPM_CMD=
for /f %%f in ('where npm.cmd 2^>NUL') do set __NPM_CMD=%%f
if defined __NPM_CMD (
    for /f "delims=" %%i in ("%__NPM_CMD%") do set __NODE_BIN_DIR=%%~dpi
    for %%f in ("!__NODE_BIN_DIR!..") do set _NODE_HOME=%%~sf
    if %_DEBUG%==1 echo [%_BASENAME%] Using path of npm executable found in PATH
    goto :eof
) else if defined NODE_HOME (
    set "_NODE_HOME=%NODE_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable NODE_HOME
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\node-v10*" 2^>NUL') do set _NODE_HOME=!__PATH!\%%f
    if not defined _NODE_HOME (
        set __PATH=C:\progra~1
        for /f %%f in ('dir /ad /b "!__PATH!\node-v10*" 2^>NUL') do set _NODE_HOME=!__PATH!\%%f
    )
)
if not exist "%_NODE_HOME%\nodevars.bat" (
    echo Error: Node installation directory not found ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%_NODE_HOME%\npm.cmd" (
    echo Error: npm not found in Node installation directory ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%_NODE_HOME%") do set _NODE_HOME=%%~sf
if %_DEBUG%==1 echo [%_BASENAME%] Using default Node installation directory %_NODE_HOME%

set NODE_HOME=%_NODE_HOME%
call %NODE_HOME%\nodevars.bat
goto :eof_HOME%\nodevars.bat
goto :eof

:pm2
where /q pm2.cmd
if %ERRORLEVEL%==0 goto :eof

if not exist "%NODE_HOME%\pm2.cmd" (
    echo pm2 command not found in Node installation directory ^(%NODE_HOME% ^)
    set /p __PM2="Execute 'npm -g install pm2 --prefix %NODE_HOME%' (Y/N)? "
    if /i "!__PM2!"=="y" (
        %NODE_HOME%\npm.cmd -g install pm2 --prefix %NODE_HOME%
    ) else (
        set _EXITCODE=1
        goto end
    )
)
goto :eof

rem https://www.mongodb.org/dl/win32/x86_64-2008plus-ssl
:mongod
where /q mongod.exe
if %ERRORLEVEL%==0 goto :eof

if defined MONGO_HOME (
    set _MONGO_HOME=%MONGO_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable MONGO_HOME
) else (
    where /q mongod.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f mongod.exe') do set _MONGO_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of MongoDB executable found in PATH
    ) else (
        set __PATH=C:\opt
        for /f %%f in ('dir /ad /b "!__PATH!\MongoDB*" 2^>NUL') do set _MONGO_HOME=!__PATH!\%%f
        if not defined _MONGO_HOME (       
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\MongoDB*" 2^>NUL') do set _MONGO_HOME=!__PATH!\%%f
            if defined _MONGO_HOME (
                if %_DEBUG%==1 echo [%_BASENAME%] Using default MongoDB installation directory !_MONGO_HOME!
            )
        )
    )
)
if not exist "%_MONGO_HOME%\bin\mongod.exe" (
    echo Error: MongoDB executable not found ^(%_MONGO_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MONGO_PATH=;%_MONGO_HOME%\bin"
goto :eof

rem output parameter(s): _GIT_PATH
:git
set _GIT_PATH=

set __GIT_HOME=
set __GIT_EXE=
for /f %%f in ('where git.exe 2^>NUL') do set __GIT_EXE=%%f
if defined __GIT_EXE (
    for /f "delims=" %%i in ("%__GIT_EXE%") do set __GIT_BIN_DIR=%%~dpi
    for %%f in ("!__GIT_BIN_DIR!..") do set __GIT_HOME=%%~sf
    rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "__GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable GIT_HOME
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set __GIT_HOME=!__PATH!\Git
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "__GIT_HOME=!__PATH!\%%f"
        if not defined __GIT_HOME (
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "__GIT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%__GIT_HOME%\bin\git.exe" (
    echo Error: Git executable not found ^(%__GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%__GIT_HOME%") do set __GIT_HOME=%%~sf
if %_DEBUG%==1 echo [%_BASENAME%] Using default Git installation directory %__GIT_HOME%

set "_GIT_PATH=;%__GIT_HOME%\bin;%__GIT_HOME%\usr\bin;%__GIT_HOME%\mingw64\bin"
goto :eof

rem output parameter(s): _CURL_PATH
:curl
set _CURL_PATH=

set __CURL_HOME=
set __CURL_EXE=
for /f %%f in ('where curl.exe 2^>NUL') do set __CURL_EXE=%%f
if defined __CURL_EXE (
    for /f "delims=" %%i in ("%__CURL_EXE%") do set __CURL_HOME=%%~dpi
    rem keep _CURL_PATH undefined since executable already in path
    goto :eof
) else if defined CURL_HOME (
    set __CURL_HOME=%CURL_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable CURL_HOME
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\curl-*" 2^>NUL') do set "__CURL_HOME=!__PATH!\%%f"
    if not defined __CURL_HOME (
        set __PATH=C:\Progra~1
        for /f %%f in ('dir /ad /b "!__PATH!\curl-*" 2^>NUL') do set "__CURL_HOME=!__PATH!\%%f"
    )
)
if not exist "%__CURL_HOME%\bin\curl.exe" (
    echo Error: cURL executable not found ^(%_CURL_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%__CURL_HOME%") do set __CURL_HOME=%%~sf
if %_DEBUG%==1 echo [%_BASENAME%] Using default curl installation directory %__CURL_HOME%

set "_CURL_PATH=;%__CURL_HOME%\bin"
goto :eof

:print_env
set __VERBOSE=%1
set "__VERSIONS_LINE1=  "
set "__VERSIONS_LINE2=  "
set __WHERE_ARGS=
where /q node.exe
if %ERRORLEVEL%==0 (
    for /f %%i in ('node.exe --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% node %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% node.exe
)
where /q npm.cmd
if %ERRORLEVEL%==0 (
    for /f %%i in ('npm.cmd --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% npm %%i"
    set __WHERE_ARGS=%__WHERE_ARGS% npm.cmd
)
where /q git.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('git.exe --version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% git %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% git.exe
)
where /q diff.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('diff.exe --version ^| findstr diff') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% diff.exe
)
where /q curl.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('curl.exe --version ^| findstr -B curl') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% curl %%j"
    set __WHERE_ARGS=%__WHERE_ARGS% curl.exe
)
echo Tool versions:
echo %__VERSIONS_LINE1%
echo %__VERSIONS_LINE2%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    rem if %_DEBUG%==1 echo [%_BASENAME%] where %__WHERE_ARGS%
    echo Tool paths:
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
endlocal & (
    if not defined NODE_HOME set NODE_HOME=%_NODE_HOME%
    set "PATH=%PATH%%_GIT_PATH%%_MONGO_PATH%%_CURL_PATH%"
    call :print_env %_VERBOSE%
    if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
