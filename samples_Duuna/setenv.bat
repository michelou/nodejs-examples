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
set _CURL_PATH=
set _SIEGE_PATH=

call :git
if not %_EXITCODE%==0 goto end

call :npm
if not %_EXITCODE%==0 goto end

call :pm2
if not %_EXITCODE%==0 goto end

call :curl
if not %_EXITCODE%==0 goto end

call :siege
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
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    rem option
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo Error: Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    rem subcommand
    set /a __N=!__N!+1
    if /i "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo Error: Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 echo [%_BASENAME%] _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
goto :eof

:help
echo Usage: %_BASENAME% { options ^| subcommands }
echo   Options:
echo     -debug      show commands executed by this script
echo     -verbose    display progress messages
echo   Subcommands:
echo     help        display this help message
goto :eof

rem output parameter(s): _GIT_PATH
:git
set _GIT_PATH=

set __GIT_HOME=
set __GIT_EXE=
for /f %%f in ('where git.exe 2^>NUL') do set __GIT_EXE=%%f
if defined __GIT_EXE (
    if %_DEBUG%==1 echo [%_BASENAME%] Using path of Git executable found in PATH 1>&2
    rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "__GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable GIT_HOME 1>&2
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
if %_DEBUG%==1 echo [%_BASENAME%] Using default Git installation directory %__GIT_HOME% 1>&2

set "_GIT_PATH=;%__GIT_HOME%\bin;%__GIT_HOME%\usr\bin;%__GIT_HOME%\mingw64\bin"
goto :eof

rem postcondition: NODE_HOME is defined and valid
:npm
set _NODE_HOME=

set __NPM_CMD=
for /f %%f in ('where npm.cmd 2^>NUL') do set __NPM_CMD=%%f
if defined __NPM_CMD (
    for /f "delims=" %%i in ("%__NPM_CMD%") do set __NODE_BIN_DIR=%%~dpi
    for %%f in ("!__NODE_BIN_DIR!..") do set _NODE_HOME=%%~sf
    goto :eof
) else if defined NODE_HOME (
    set "_NODE_HOME=%NODE_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable NODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\node-v10*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    if not defined _NODE_HOME (
        set __PATH=C:\progra~1
        for /f %%f in ('dir /ad /b "!__PATH!\node-v10*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
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
if %_DEBUG%==1 echo [%_BASENAME%] Using default Node installation directory %_NODE_HOME% 1>&2

set NODE_HOME=%_NODE_HOME%
call %NODE_HOME%\nodevars.bat
goto :eof

:pm2
where /q pm2.cmd
if %ERRORLEVEL%==0 goto :eof

if not exist "%NODE_HOME%\pm2.cmd" (
    echo pm2 command not found in Node installation directory ^(%NODE_HOME% ^)
    set /p __PM2_ANSWER="Execute 'npm -g install pm2 --prefix %NODE_HOME%' (Y/N)? "
    if /i "!__PM2_ANSWER!"=="y" (
        %NODE_HOME%\npm.cmd -g install pm2 --prefix %NODE_HOME%
    ) else (
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

rem output parameter(s): _CURL_PATH
:curl
set _CURL_PATH=

set __CURL_HOME=
set __CURL_EXE=
for /f %%f in ('where curl.exe 2^>NUL') do set __CURL_EXE=%%f
if defined __CURL_EXE (
    if %_DEBUG%==1 echo [%_BASENAME%] Using path of cURL executable found in PATH 1>&2
    rem keep _CURL_PATH undefined since executable already in path
    goto :eof
) else if defined CURL_HOME (
    set "__CURL_HOME=%CURL_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable CURL_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\curl\" ( set "__CURL_HOME=!__PATH!\curl"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\curl-*" 2^>NUL') do set "__CURL_HOME=!__PATH!\%%f"
        if not defined __CURL_HOME (
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\curl-*" 2^>NUL') do set "__CURLHOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_^_CURL_HOME%\bin\curl.exe" (
    echo Error: cURL executable not found ^(%__CURL_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CURL_PATH=;%__CURL_HOME%\bin"
goto :eof

rem output parameter(s): _SIEGE_PATH
:siege
set _SIEGE_PATH=

set __SIEGE_HOME=
set __SIEGE_EXE=
for /f %%f in ('where siege.exe 2^>NUL') do set __SIEGE_EXE=%%f
if defined __SIEGE_EXE (
    if %_DEBUG%==1 echo [%_BASENAME%] Using path of Siege executable found in PATH 1>&2
    rem keep _SIEGE_PATH undefined since executable already in path
    goto :eof
) else if defined SIEGE_HOME (
    set "__SIEGE_HOME=%SIEGE_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable SIEGE_HOME 1>&2
) else (
    set __PATH=C:
    if exist "!__PATH!\Siege\" ( set "__SIEGE_HOME=!__PATH!\Siege"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\siege-*" 2^>NUL') do set "__SIEGE_HOME=!__PATH!\%%f"
    )
)
if not exist "%__SIEGE_HOME%\siege.exe" (
    echo Error: Siege installation directory not found ^(%__SIEGE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%__SIEGE_HOME%") do set __SIEGE_HOME=%%~sf
if %_DEBUG%==1 echo [%_BASENAME%] Using default Siege installation directory %__SIEGE_HOME% 1>&2

set "_SIEGE_PATH=;%__SIEGE_HOME%"
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
where /q curl.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('curl.exe --version ^| findstr -B curl') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% curl %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% curl.exe
)
where /q siege.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('siege.exe --version 2^>^&1 ^| findstr /b SIEGE') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% siege %%j"
    set __WHERE_ARGS=%__WHERE_ARGS% siege.exe
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
    set "PATH=%PATH%%_GIT_PATH%%_CURL_PATH%%_SIEGE_PATH%"
    if %_EXITCODE%==0 call :print_env %_VERBOSE%
    if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
