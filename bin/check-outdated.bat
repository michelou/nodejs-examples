@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
set _DEBUG=0

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
for /f "delims=" %%f in ('where /r "%_ROOT_DIR%" package.json ^| findstr /v node_modules 2^>NUL') do (
    call :outdated "%%~dpf"
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameter(s): _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL, _NPM_CMD
:env
set _BASENAME=%~n0
for %%f in ("%~dp0\.") do set "_ROOT_DIR=%%~dpf"
@rem remove trailing backslash for virtual drives
if "%_ROOT_DIR:~-1%"=="\" set "_ROOT_DIR=%_ROOT_DIR:~0,-1%"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

if not exist "%NODE_HOME%\npm.cmd" (
    echo %_ERROR_LABEL% Node installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_NPM_CMD=%NODE_HOME%\npm.cmd"
set _NPM_OPTS=
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

rem input parameter: %*
:args
set _HELP=0
set _INSTALL=0
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-install" ( set _INSTALL=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
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
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _INSTALL=%_INSTALL% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% 1>&2
    echo %_DEBUG_LABEL% Variables  : NODE_HOME="%NODE_HOME%" 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-install%__END%    install latest package (if outdated)
echo     %__BEG_O%-timer%__END%      display total elapsed time
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
goto :eof

:outdated
set "__PROJ_DIR=%~1"

if %_VERBOSE%==1 (
    set __BEG_C=%_STRONG_FG_RED%
    set __BEG_L=%_STRONG_FG_GREEN%
    set __END=%_RESET%
) else (
    set __BEG_C=
    set __BEG_L=
    set __END=
)
pushd "%__PROJ_DIR%"
@rem echo Current directory: !__PROJ_DIR:%_ROOT_DIR%=!

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_NPM_CMD%" outdated ^| findstr /v Wanted 1>&2
) else if %_VERBOSE%==1 ( echo Search for outdated packages in directory "!__PROJ_DIR:%_ROOT_DIR%=!" 1>&2
)
for /f "tokens=1,2,3,4,*" %%i in ('"%_NPM_CMD%" outdated ^| findstr /v Wanted') do (
    set __PKG_NAME=%%i
    set __CURRENT=%%j
    set __WANTED=%%k
    set __LATEST=%%l
    if "!__CURRENT!"=="MISSING" (
        call :current_missing "!__PKG_NAME!"
        if not !_EXITCODE!==0 goto outdated_done
        set __CURRENT=!_CURRENT_MISSING!
    )
    if "!__CURRENT!"=="*" (
        @rem Keep "Any version"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Package "!__PKG_NAME!" has version "*" ^(!__LATEST!^) 1>&2
        )
    ) else if not "!__CURRENT!"=="!__LATEST!" (
        echo    Outdated package !__PKG_NAME!: current=%__BEG_C%!__CURRENT!%__END%, latest=%__BEG_L%!__LATEST!%__END%
        if %_INSTALL%==1 (
            if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_NPM_CMD%" install -audit !__PKG_NAME!@!__LATEST! --save 1^>NUL 1>&2
            ) else if %_VERBOSE%==1 ( echo    Install package !__PKG_NAME!@!__LATEST! 1>&2
            )
            call "%_NPM_CMD%" install -audit !__PKG_NAME!@!__LATEST! --save 1>NUL
            if not !ERRORLEVEL!==0 (
                set _EXITCODE=1
            )
        )
    )
)
:outdated_done
popd
goto :eof

@rem input parameter: %1=package name
@rem output parameter: _CURRENT_MISSING
:current_missing
set __PKG_NAME=%~1
set _CURRENT_MISSING=

for /f "usebackq delims=:, tokens=1,2,*" %%f in (`findstr /c:"""%__PKG_NAME%""" package.json`) do (
    for /f "usebackq" %%x in (`powershell -C "'%%g'.Trim()"`) do set _CURRENT_MISSING=%%x
    if "!_CURRENT_MISSING:~0,1!"=="^" ( set _CURRENT_MISSING=!_CURRENT_MISSING:~1!
    ) else if "!_CURRENT_MISSING:%~0,1!"=="~" ( set _CURRENT_MISSING=!_CURRENT_MISSING:~1!
    )
)
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total elapsed time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
