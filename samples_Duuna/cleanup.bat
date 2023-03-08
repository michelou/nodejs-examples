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

set _N=0
set "_DIR=%_ROOT_DIR%node_modules"
if exist "!_DIR!" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% %_RIMRAF_CMD% "!_DIR!" 1>&2
    call "%_RIMRAF_CMD%" "!_DIR!"
    set /a _N+=1
)

for /f %%i in ('dir /ad /b 2^>NUL') do (
    set "_DIR=%_ROOT_DIR%%%i\node_modules"
    if exist "!_DIR!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% %_RIMRAF_CMD% "!_DIR!" 1>&2
        call "%_RIMRAF_CMD%" "!_DIR!"
        set /a _N+=1
    )
)
if %_N% gtr 1 ( echo Removed %_N% directories
) else if %_N% gtr 0 ( echo Removed %_N% directory 
) else if %_VERBOSE%==1 ( echo No directory 'node_modules' found 1>&2
)

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

if defined NODE_HOME (
    set "_NODE_HOME=%NODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable NODE_HOME 1>&2
) else (
    where /q node.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f node.exe') do set "_NODE_HOME=%%~dpsi"
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Node executable found in PATH 1>&2
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\nodejs*" 2^>NUL') do set "_NODE_HOME=!_PATH!\%%f"
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Node installation directory !_NODE_HOME! 1>&2
    )
)
if not exist "%_NODE_HOME%\npm.cmd" (
    echo %_ERROR_LABEL% npm command not found ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto end
)
where /q rimraf.cmd
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_NODE_HOME%\npm.cmd" -g install rimraf 1>&2
    call "%_NODE_HOME%\npm.cmd" -g install rimraf
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to install rimraf 1>&2
        set _EXITCODE=1
        goto end
    )
)
set _RIMRAF_CMD=rimraf.cmd
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

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
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
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
echo     %__BEG_O%-debug%__END%      show commands executed by this script
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
