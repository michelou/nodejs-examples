@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
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
for %%i in (samples samples_Bojinov samples_Cook samples_Duuna samples_Lambert samples_Pillora) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :clean_dir "%_ROOT_DIR%%%i" 1>&2
    call :clean_dir "%_ROOT_DIR%%%i"
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
for /f "delims=" %%f in ("%~dp0.") do set "_ROOT_DIR=%%~dpf"
@rem when using virtual drives substitute ":\\" by ":\".
set "_ROOT_DIR=%_ROOT_DIR::\\=:\%"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_RIMRAF_CMD=%NODE_HOME%\rimraf.cmd"
if not exist "%_RIMRAF_CMD%" (
    echo %_ERROR_LABEL% Command rimraf.cmd not found 1>&2
    set _EXITCODE=1
    goto :eof
)
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
    set __BEG_P=%_STRONG_FG_CYAN%%_UNDERSCORE%
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
echo     %__BEG_O%-help%__END%       display this help message
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
goto :eof

@rem input parameter: %1=parent directory
:clean_dir
set "__PARENT_DIR=%~1"
if not exist "%__PARENT_DIR%" (
    echo %_WARNING_LABEL% Directory not found ^(%__PARENT_DIR%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set __N=0
for /f %%i in ('dir /ad /b "%__PARENT_DIR%"') do (
    set "__MODULES_DIR=%__PARENT_DIR%\%%i\node_modules"
    if exist "!__MODULES_DIR!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_RIMRAF_CMD%" "!__MODULES_DIR!" 1>&2
        ) else if %_VERBOSE%==1 ( echo Delete directory "!__MODULES_DIR:%_ROOT_DIR%=!" 1>&2
        )
        call "%_RIMRAF_CMD%" "!__MODULES_DIR!"
        set /a __N+=1
    )
)
if %__N%==0 (
    echo %_WARNING_LABEL% No directory 'node_modules' found in directory "!__PARENT_DIR:%_ROOT_DIR%=!" 1>&2
    goto :eof
) else if %__N%==1 ( set __N_DIRS=%__N% 'node_modules' directory 
) else ( set __N_DIRS=%__N% 'node_modules' directories
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Removed %__N_DIRS% in directory "!__PARENT_DIR:%_ROOT_DIR%=!" 1>&2
) else if %_VERBOSE%==1 ( echo Removed %__N_DIRS% in directory "!__PARENT_DIR:%_ROOT_DIR%=!" 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
