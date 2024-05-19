@echo off
setlocal enabledelayedexpansion

if defined DEBUG ( set _DEBUG=1 ) else ( set _DEBUG=0 )

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
set _GIT_PATH=
set _MONGO_PATH=

call :npm
if not %_EXITCODE%==0 goto end

call :grunt
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

call :pm2
if not %_EXITCODE%==0 goto end

call :mongod
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:
goto :eof

@rem input parameter: %*
:args
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if /i "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug      show commands executed by this script
echo     -verbose    display progress messages
echo.
echo   Subcommands:
echo     help        display this help message
goto :eof

@rem postcondition: NODE_HOME is defined and valid
:npm
set _NODE_HOME=

set __NPM_CMD=
for /f "delims=" %%f in ('where npm.cmd 2^>NUL') do set __NPM_CMD=%%f
if defined __NPM_CMD (
    for /f "delims=" %%i in ("%__NPM_CMD%") do set __NODE_BIN_DIR=%%~dpi
    for %%f in ("!__NODE_BIN_DIR!..") do set _NODE_HOME=%%~sf
    goto :eof
) else if defined NODE_HOME (
    set "_NODE_HOME=%NODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable NODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\node-v10*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    if not defined _NODE_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\node-v10*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    )
)
if not exist "%_NODE_HOME%\nodevars.bat" (
    echo %_ERROR_LABEL% Node installation directory not found ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%_NODE_HOME%\npm.cmd" (
    echo %_ERROR_LABEL% npm not found in Node installation directory ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%_NODE_HOME%") do set _NODE_HOME=%%~sf
if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Node installation directory %_NODE_HOME% 1>&2

set "NODE_HOME=%_NODE_HOME%"
call %NODE_HOME%\nodevars.bat
goto :eof

:grunt
where /q grunt.cmd
if %ERRORLEVEL%==0 goto :eof

if not exist "%NODE_HOME%\grunt.cmd" (
    echo Grunt tool not found in Node installation ^(%NODE_HOME%^)
    set /p __GRUNT="Execute command 'npm -g install grunt --prefix=%NODE_HOME%' ? (y/n) "
    if /i "!__GRUNT!"=="y" (
        call "%NODE_HOME%\npm.cmd" -g install grunt --prefix=%NODE_HOME%
    ) else (
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

@rem output parameter(s): _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f "delims=" %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo [%_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^(%_GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%_GIT_HOME%") do set _GIT_HOME=%%~sf
if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory %_GIT_HOME%

set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\usr\bin;%_GIT_HOME%\mingw64\bin"
goto :eof

:pm2
where /q pm2.cmd
if %ERRORLEVEL%==0 goto :eof

if not exist "%NODE_HOME%\pm2.cmd" (
    echo pm2 command not found in Node installation directory ^(%NODE_HOME% ^)
    set /p __PM2_ANSWER="Execute 'npm -g install pm2 --prefix %NODE_HOME%' (Y/N)? "
    if /i "!__PM2_ANSWER!"=="y" (
        call "%NODE_HOME%\npm.cmd" -g install pm2 --prefix %NODE_HOME%
    ) else (
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

:mongod
where /q mongod.exe
if %ERRORLEVEL%==0 goto :eof

if defined MONGO_HOME (
    set "_MONGO_HOME=%MONGO_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MONGO_HOME 1>&2
) else (
    where /q mongod.exe
    if !ERRORLEVEL!==0 (
        for /f "delims=" %%i in ('where /f mongod.exe') do set _MONGO_HOME=%%~dpsi
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of MongoDB executable found in PATH 1>&2
    ) else (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\MongoDB*" 2^>NUL') do set _MONGO_HOME=!__PATH!\%%f
        if defined _MONGO_HOME (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default MongoDB installation directory !_MONGO_HOME! 1>&2
        )
    )
)
if not defined _MONGO_BIN_DIR (
    for /f "delims=" %%i in ('where /f /r "%_MONGO_HOME%" mongod.exe 2^>NUL') do set _MONGO_BIN_DIR=%%~dpsi
)
if not exist "%_MONGO_BIN_DIR%\mongod.exe" (
    echo %_ERROR_LABEL% MongoDB executable not found ^(%_MONGO_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MONGO_PATH=;%_MONGO_BIN_DIR%"
goto :eof

:print_env
set __VERBOSE=%1
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
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
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do (
        for /f "delims=. tokens=1,2,3,*" %%a in ("%%k") do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% git %%a.%%b.%%c,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% git.exe
)
where /q mongod.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('mongod.exe --version ^| findstr "^db"') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% mongod %%k"
    set __WHERE_ARGS=%__WHERE_ARGS% mongod.exe
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% where %__WHERE_ARGS%
    echo Tool paths: 1>&2
    for /f "delims=" %%i in ('subst') do (
        set "__LINE=%%i"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if not defined NODE_HOME set "NODE_HOME=%_NODE_HOME%"
    if not defined NODE_PATH set "NODE_PATH=%~dp0\node_modules"
    set "PATH=%PATH%%_GIT_PATH%%_MONGO_PATH%"
    call :print_env %_VERBOSE%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
