@echo off
setlocal enabledelayedexpansion

if defined DEBUG ( set _DEBUG=1 ) else ( set _DEBUG=0 )

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

rem ##########################################################################
rem ## Main

set _GIT_PATH=
set _MONGO_PATH=
set _CURL_PATH=

call :git
if not %_EXITCODE%==0 goto end

call :npm
if not %_EXITCODE%==0 goto end

call :grunt
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
if %ERRORLEVEL%==0 goto :eof

if defined NODE_HOME (
    set _NODE_HOME=%NODE_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable NODE_HOME
) else (
    where /q node.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f node.exe') do set _NODE_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of Node executable found in PATH
    ) else (
        set __PATH=C:\opt
        for /f %%f in ('dir /b "!__PATH!\nodejs*" 2^>NUL') do set _NODE_HOME=!__PATH!\%%f
        if not defined _NODE_HOME (
            set __PATH=C:\progra~1
            for /f %%f in ('dir /b "!__PATH!\nodejs*" 2^>NUL') do set _NODE_HOME=!__PATH!\%%f
        )
        if defined _NODE_HOME (
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

:grunt
where /q grunt.cmd
if %ERRORLEVEL%==0 goto :eof

if not exist "%NODE_HOME%\grunt.cmd" (
    echo Grunt tool not found in Node installation ^(%NODE_HOME%^)
    set /p __GRUNT="Execute command 'npm -g install grunt --prefix=%NODE_HOME%' ? (y/n) "
    if /i "!__GRUNT!"=="y" (
        %NODE_HOME%\npm.cmd -g install grunt --prefix=%NODE_HOME%
    ) else (
        set _EXITCODE=1
        goto :eof
    )
)
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
    if %_DEBUG%==1 echo [%_BASENAME%] MongoDB executable not found ^(%_MONGO_HOME%^)
    set _EXITCODE=1
    goto :eof
)
set "_MONGO_PATH=;%_MONGO_HOME%\bin"
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
if not exist "%_CURL_HOME%\curl.exe" (
    if %_DEBUG%==1 echo [%_BASENAME%] cURL installation directory %_CURL_HOME% not found
    set _EXITCODE=1
    goto :eof
)
set "_CURL_PATH=;%_CURL_HOME%"
goto :eof

:print_env
for /f %%i in ('where npm.cmd') do echo NODE_HOME=%%~dpi
for /f %%i in ('npm --version') do echo NPM_VERSION=%%i
for /f "tokens=1,2,*" %%i in ('curl.exe --version ^| findstr -B curl') do echo CURL_VERSION=%%j
for /f "tokens=1,2,*" %%i in ('git --version') do echo GIT_VERSION=%%k
where npm.cmd grunt.cmd curl.exe git.exe
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
endlocal & (
    if not defined NODE_HOME set NODE_HOME=%_NODE_HOME%
    set "PATH=%PATH%%_GIT_PATH%%_MONGO_PATH%%_CURL_PATH%"
    call :print_env
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] _EXITCODE=%_EXITCODE%
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
