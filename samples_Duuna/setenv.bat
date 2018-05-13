@echo off
setlocal enabledelayedexpansion

if defined DEBUG ( set _DEBUG=1 ) else ( set _DEBUG=0 )

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

call :args %*
if not %_EXITCODE%==0 goto end

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
) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
) else (
    echo %_BASENAME%: Unknown subcommand %__ARG%
    set _EXITCODE=1
    goto :eof
)
shift
goto :args_loop
:args_done
goto :eof

:help
echo Usage: setenv { options ^| subcommands }
echo   Options:
echo     -verbose         display environment settings
echo   Subcommands:
echo     help             display this help message
goto :eof

:git
where /q git.exe
if %ERRORLEVEL%==0 goto :eof

if defined GIT_HOME (
    set _GIT_HOME=%GIT_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable GIT_HOME
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set _GIT_HOME=!__PATH!\%%f
    if not defined _GIT_HOME (
        set __PATH=C:\Progra~1
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set _GIT_HOME=!__PATH!\%%f        
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Git installation directory !_GIT_HOME!
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo Git executable not found ^(%_GIT_HOME%^)
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin"
goto :eof

:npm
where /q npm.cmd
if %ERRORLEVEL%==0 (
    if not defined NODE_HOME (
        for /f %%i in ('where /f npm.cmd') do set NODE_HOME=%%~dpsi
    )
    goto :eof
)

if defined NODE_HOME (
    set _NODE_HOME=%NODE_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable NODE_HOME
) else (
    where /q node.exe
    if !ERRORLEVEL!==0 (
        for /f "delims=" %%i in ('where /f node.exe') do set _NODE_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of Node executable found in PATH
    ) else (
        set __PATH=C:\opt
        for /f %%f in ('dir /ad /b "!__PATH!\node-v8*" 2^>NUL') do set _NODE_HOME=!__PATH!\%%f
        if not defined _NODE_HOME (
            set __PATH=C:\progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\node-v8*" 2^>NUL') do set _NODE_HOME=!__PATH!\%%f
        )
        if defined _NODE_HOME (
            rem path name of installation directory may contain spaces
            for /f "delims=" %%f in ("!_NODE_HOME!") do set _NODE_HOME=%%~sf
            if %_DEBUG%==1 echo [%_BASENAME%] Using default Node installation directory !_NODE_HOME!
        )
    )
)
if not exist "%_NODE_HOME%\nodevars.bat" (
    echo Node installation directory not found ^(%_NODE_HOME%^)
    set _EXITCODE=1
    goto :eof
)
if not exist "%_NODE_HOME%\npm.cmd" (
    echo npm not found in Node installation directory ^(%_NODE_HOME%^)
    set _EXITCODE=1
    goto :eof
)
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

:curl
where /q curl.exe
if %ERRORLEVEL%==0 goto :eof

if defined CURL_HOME (
    set _CURL_HOME=%CURL_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable CURL_HOME
) else (
    where /q curl.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f curl.exe') do set _CURL_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of cURL executable found in PATH
    ) else (
        set __PATH=C:\opt
        for /f %%f in ('dir /ad /b "!__PATH!\curl-*" 2^>NUL') do set _CURL_HOME=!__PATH!\%%f
        if defined _CURL_HOME (
            if %_DEBUG%==1 echo [%_BASENAME%] Using default cURL installation directory !_CURL_HOME!
        )
    )
)
if not exist "%_CURL_HOME%\bin\curl.exe" (
    echo cURL executable not found ^(%_CURL_HOME%^)
    set _EXITCODE=1
    goto :eof
)
set "_CURL_PATH=;%_CURL_HOME%\bin"
goto :eof

:siege
where /q siege.exe
if %ERRORLEVEL%==0 goto :eof

if defined SIEGE_HOME (
    set _SIEGE_HOME=%SIEGE_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable SIEGE_HOME
) else (
    where /q siege.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f siege.exe') do set _SIEGE_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of Siege executable found in PATH
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\siege-*" 2^>NUL') do set _SIEGE_HOME=!_PATH!\%%f
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Siege installation directory !_SIEGE_HOME!
    )
)
if not exist "%_SIEGE_HOME%\siege.exe" (
    if %_DEBUG%==1 echo [%_BASENAME%] Siege installation directory %_SIEGE_HOME% not found
    set _EXITCODE=1
    goto :eof
)
set "_SIEGE_PATH=;%_SIEGE_HOME%"
goto :eof

:print_env
set __WHERE_ARGS=
where /q npm.cmd
if %ERRORLEVEL%==0 (
    for /f %%i in ('node.exe --version') do echo NODE_VERSION=%%i
    for /f %%i in ('npm.cmd --version') do echo NPM_VERSION=%%i
    set __WHERE_ARGS=%__WHERE_ARGS% node.exe npm.cmd
)
where /q git.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('git.exe --version') do echo GIT_VERSION=%%k
    set __WHERE_ARGS=%__WHERE_ARGS% git.exe
)
where /q curl.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('curl.exe --version ^| findstr -B curl') do echo CURL_VERSION=%%j
    set __WHERE_ARGS=%__WHERE_ARGS% curl.exe
)
where %__WHERE_ARGS%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
endlocal & (
    if not defined NODE_HOME set NODE_HOME=%_NODE_HOME%
    set "PATH=%PATH%%_GIT_PATH%%_CURL_PATH%%_SIEGE_PATH%"
    if %_VERBOSE%==1 call :print_env
    if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
