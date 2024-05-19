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
set _MONGODB_PATH=

call :npm
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

call :mongodb
if not %_EXITCODE%==0 goto end

@rem global npm packages: pm2, rimrad
call :pm2
if not %_EXITCODE%==0 goto end

call :rimraf
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameter(s): _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m

@rem we define _RESET in last position to avoid crazy console output with type command
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m
set _RESET=[0m
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
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if /i "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%      print commands executed by this script
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        print this help message
goto :eof

@rem postcondition: NODE_HOME is defined and valid
:npm
set _NODE_HOME=

set __NPM_CMD=
for /f "delims=" %%f in ('where npm.cmd 2^>NUL') do set "__NPM_CMD=%%f"
if defined __NPM_CMD (
    for /f "delims=" %%i in ("%__NPM_CMD%") do set "__NODE_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__NODE_BIN_DIR!..") do set "_NODE_HOME=%%~sf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of npm executable found in PATH 1>&2
    goto :eof
) else if defined NODE_HOME (
    set "_NODE_HOME=%NODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable NODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\node-v12*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    if not defined _NODE_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\node-v12*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    )
)
if not exist "%_NODE_HOME%\nodevars.bat" (
    echo %_ERROR_LABEL% Node installation directory not found ^("%_NODE_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%_NODE_HOME%\npm.cmd" (
    echo %_ERROR_LABEL% npm not found in Node installation directory ^("%_NODE_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%_NODE_HOME%") do set "_NODE_HOME=%%~sf"
if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Node installation directory "%_NODE_HOME%" 1>&2

set "NODE_HOME=%_NODE_HOME%"
call %NODE_HOME%\nodevars.bat
goto :eof

:pm2
where /q pm2.cmd
if %ERRORLEVEL%==0 goto :eof

if not exist "%NODE_HOME%\pm2.cmd" (
    echo pm2 command not found in Node installation directory ^(%NODE_HOME% ^)
    set /p __PM2_ANSWER="Execute 'npm -g install pm2 --prefix %NODE_HOME%' (Y/N)? "
    if /i "!__PM2_ANSWER!"=="y" (
        %NODE_HOME%\npm.cmd -g install pm2 --prefix "%NODE_HOME%"
    ) else (
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

:rimraf
where /q rimraf.cmd
if %ERRORLEVEL%==0 goto :eof

if not exist "%NODE_HOME%\rimraf.cmd" (
    echo rimraf command not found in Node installation directory ^(%NODE_HOME% ^)
    set /p __RIMRAF_ANSWER="Execute 'npm -g install rimraf --prefix %NODE_HOME%' (Y/N)? "
    if /i "!__RIMRAF_ANSWER!"=="y" (
        %NODE_HOME%\npm.cmd -g install rimraf --prefix "%NODE_HOME%"
    ) else (
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

@rem output parameters: _MONGODB_PATH
@rem https://www.mongodb.org/dl/win32/x86_64-2008plus-ssl
:mongodb
set _MONGODB_HOME=
set _MONGODB_PATH=

set __MONGOD_CMD=
for /f "delims=" %%f in ('where mongod.exe 2^>NUL') do set "__MONGOD_CMD=%%f"
if defined __MONGOD_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of MongoDB executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined MONGODB_HOME (
    set "_MONGODB_HOME=%MONGODB_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MONGODB_HOME 1>&2
) else (
    set __PATH=c:\opt
    if exist "!__PATH!\mongodb\" ( set "_MONGODB_HOME=!__PATH!\mongodb"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mongodb*" 2^>NUL') do set "_MONGODB_HOME=!__PATH!\%%f"
        if not defined _MONGODB_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mongodb*" 2^>NUL') do set "_MONGODB_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_MONGODB_HOME%\bin\mongod.exe" (
    echo %_ERROR_LABEL% MongoDB executable not found ^("%_MONGODB_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MONGODB_PATH=;%_MONGODB_HOME%\bin"
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
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
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
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
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\usr\bin;%_GIT_HOME%\mingw64\bin"
goto :eof

:print_env
set __VERBOSE=%1
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
set __WHERE_ARGS=
where /q "%NODE_HOME%:node.exe"
if %ERRORLEVEL%==0 (
    for /f %%i in ('"%NODE_HOME%\node.exe" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% node %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%NODE_HOME%:node.exe"
)
where /q "%NODE_HOME%:npm.cmd"
if %ERRORLEVEL%==0 (
    for /f %%i in ('"%NODE_HOME%\npm.cmd" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% npm %%i"
    set __WHERE_ARGS=%__WHERE_ARGS% "%NODE_HOME%:npm.cmd"
)
where /q git.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do (
        for /f "delims=. tokens=1,2,3,*" %%a in ("%%k") do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% git %%a.%%b.%%c,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% git.exe
)
where /q diff.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('diff.exe --version ^| findstr diff') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% diff.exe
)
where /q "%MONGODB_HOME%\bin:mongod.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%MONGODB_HOME%\bin\mongod.exe" --version ^| findstr /b db') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% mongod %%k"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MONGODB_HOME%\bin:mongod.exe"
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% where %__WHERE_ARGS%
    echo Tool paths:
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do (
        set "__LINE=%%p"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
    echo Environment variables: 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined MONGODB_HOME echo    "MONGODB_HOME=%MONGODB_HOME%" 1>&2
    if defined NODE_HOME echo    "NODE_HOME=%NODE_HOME%" 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined MONGODB_HOME set "MONGODB_HOME=%_MONGODB_HOME%"
        if not defined NODE_HOME set "NODE_HOME=%_NODE_HOME%"
        if not defined NODE_PATH set "NODE_PATH=%~dp0\node_modules"
        set "PATH=%PATH%%_GIT_PATH%%_MONGODB_PATH%"
        call :print_env %_VERBOSE%
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
