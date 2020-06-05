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

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

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
    if %_DEBUG%==1 echo %_DEBUG_LABEL% npm.cmd -g install rimraf 1>&2
    call "%_NODE_HOME%\npm.cmd" -g install rimraf
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to install rimraf 1>&2
        set _EXITCODE=1
        goto end
    )
)
set _RIMRAF_CMD=rimraf.cmd
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

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
