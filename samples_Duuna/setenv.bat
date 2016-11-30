@echo off

if not defined _DEBUG set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _SETENV_BASENAME=%~n0

if defined _ROOT_DIR (
    setlocal enabledelayedexpansion
    set _CONFIG_FILE=%_ROOT_DIR%package.json
    if not exist "!_CONFIG_FILE!" (
        echo Configuration file not found ^(!_CONFIG_FILE!^)
        set _EXITCODE=1
        goto :eof
    )
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] _CONFIG_FILE=!_CONFIG_FILE!
    endlocal
)

rem ##########################################################################
rem ## Main

where /q git.exe
if not %ERRORLEVEL%==0 call :git

where /q jq.exe
if not %ERRORLEVEL%==0 call :jq

where /q npm.cmd
if not %ERRORLEVEL%==0 call :npm

where /q grunt.cmd
if not %ERRORLEVEL%==0 call :grunt

where /q pm2.cmd
if not %ERRORLEVEL%==0 call :pm2

where /q curl.exe
if not %ERRORLEVEL%==0 call :curl

where /q siege.exe
if not %ERRORLEVEL%==0 call :siege

goto end

rem ##########################################################################
rem ## Subroutines

:git
setlocal enabledelayedexpansion
set _EXITCODE=0

if defined GIT_HOME (
    set _GIT_HOME=%GIT_HOME%
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using environment variable GIT_HOME
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\Git*" 2^>NUL') do set _GIT_HOME=!_PATH!\%%f
    if not defined _GIT_HOME (
        set _PATH=C:\Progra~1
        for /f %%f in ('dir /ad /b "!_PATH!\Git*" 2^>NUL') do set _GIT_HOME=!_PATH!\%%f        
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using default Git installation directory !_GIT_HOME!
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo Git installation directory not found ^(%_GIT_HOME%^)
    set _EXITCODE=1
    goto :eof
)
endlocal && (
    set "PATH=%PATH%;%_GIT_HOME%\bin"
)
goto :eof

:jq
setlocal enabledelayedexpansion
set _EXITCODE=0

if defined JQ_HOME (
    set _JQ_HOME=%JQ_HOME%
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using environment variable JQ_HOME
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\jq-*" 2^>NUL') do set _JQ_HOME=!_PATH!\%%f
    if not defined _JQ_HOME (
        set _PATH=C:\Progra~1
        for /f %%f in ('dir /ad /b "!_PATH!\jq-*" 2^>NUL') do set _JQ_HOME=!_PATH!\%%f        
    )
    if defined _JQ_HOME (
        if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using default jq installation directory !_JQ_HOME!
    )
)
for /f "delims=" %%i in ('where "%_JQ_HOME%:jq*.exe" 2^>NUL') do set _JQ_CMD=%%~dpsi
if not exist "%_JQ_CMD%" (
    echo jq installation directory not found ^(%_JQ_HOME%^)
    set _EXITCODE=1
    goto :eof
)
for /f %%i in ("%_JQ_CMD%") do set _JQ_PATH=%%~dpi
endlocal && (
    set "PATH=%PATH%;%_JQ_PATH%"
)
goto :eof

:npm
setlocal enabledelayedexpansion
set _EXITCODE=0

if defined NODE_HOME (
    set _NODE_HOME=%NODE_HOME%
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using environment variable NODE_HOME
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\nodejs*" 2^>NUL') do set _NODE_HOME=!_PATH!\%%f
    if not defined _NODE_HOME (
        set _PATH=C:\Progra~1
        for /f %%f in ('dir /ad /b "!_PATH!\nodejs*" 2^>NUL') do set _NODE_HOME=!_PATH!\%%f        
    )
    if defined _NODE_HOME (
        if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using default Node installation directory !_NODE_HOME!
    )
)
if not exist "%_NODE_HOME%\nodevars.bat" (
    echo Node installation directory not found ^(%_NODE_HOME%^)
    set _EXITCODE=1
    goto :eof
)

if not exist "%_NODE_HOME%\npm.cmd" (
    echo NPM not found in Node installation directory ^(%_NODE_HOME%^)
    set _EXITCODE=1
    goto :eof
)

endlocal && (
    set NODE_HOME=%_NODE_HOME%
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] _EXITCODE=%_EXITCODE%
)
call %NODE_HOME%\nodevars.bat
goto :eof

:grunt
setlocal enabledelayedexpansion
set _EXITCODE=0

if not exist "%_NODE_HOME%\grunt.cmd" (
    echo Grunt CLI command not found in Node installation directory ^(%_NODE_HOME%^)
    set /p _GRUNT="Execute 'npm -g install grunt-cli --prefix %_NODE_HOME%' (Y/N)? "
    if /i "!_GRUNT!"=="y" (
        %_NODE_HOME%\npm.cmd -g install grunt-cli --prefix %_NODE_HOME%
    ) else (
        set _EXITCODE=1
        goto end
    )
)
endlocal
goto :eof

:pm2
setlocal enabledelayedexpansion
set _EXITCODE=0

if not exist "%_NODE_HOME%\pm2.cmd" (
    echo pm2 command not found in Node installation directory ^(%_NODE_HOME% ^)
    set /p _BOWER="Execute 'npm -g install pm2 --prefix %_NODE_HOME%' (Y/N)? "
    if /i "!_BOWER!"=="y" (
        %_NODE_HOME%\pm2.cmd -g install pm2 --prefix %_NODE_HOME%
    ) else (
        set _EXITCODE=1
        goto end
    )
)
endlocal
goto :eof

:curl
setlocal enabledelayedexpansion
set _EXITCODE=0

if defined CURL_HOME (
    set _CURL_HOME=%CURL_HOME%
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using environment variable CURL_HOME
) else (
    where /q curl.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f curl.exe') do set _CURL_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using path of cURL executable found in PATH
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\curl-*" 2^>NUL') do set _CURL_HOME=!_PATH!\%%f
        if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using default cURL installation directory !_CURL_HOME!
    )
)
if not exist "%_CURL_HOME%\curl.exe" (
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] cURL installation directory %_CURL_HOME% not found
    set _EXITCODE=1
    goto end
)
endlocal && (
    set "PATH=%PATH%;%_CURL_HOME%"
)
goto :eof

:siege
setlocal enabledelayedexpansion
set _EXITCODE=0

if defined SIEGE_HOME (
    set _SIEGE_HOME=%SIEGE_HOME%
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using environment variable SIEGE_HOME
) else (
    where /q siege.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f siege.exe') do set _SIEGE_HOME=%%~dpsi
        if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using path of Siege executable found in PATH
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\siege-*" 2^>NUL') do set _SIEGE_HOME=!_PATH!\%%f
        if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Using default Siege installation directory !_SIEGE_HOME!
    )
)
if not exist "%_SIEGE_HOME%\siege.exe" (
    if %_DEBUG%==1 echo [%_SETENV_BASENAME%] Siege installation directory %_SIEGE_HOME% not found
    set _EXITCODE=1
    goto end
)
endlocal && (
    set SIEGE_HOME=%_SIEGE_HOME%
    set "PATH=%PATH%;%_SIEGE_HOME%"
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
exit /b %ERRORLEVEL%
