@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0
for %%f in ("%~dp0..") do set "_ROOT_DIR=%%~f"

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

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

where /q npm.cmd
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Executable npm.cmd not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set _NPM_CMD=npm.cmd
set _NPM_OPTS=
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
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-install" ( set _INSTALL=1
    ) else if /i "%__ARG%"=="-timer" ( set _TIMER=1
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
if %_DEBUG%==1 echo %_DEBUG_LABEL% _HELP=%_HELP% _INSTALL=%_INSTALL% _VERBOSE=%_VERBOSE% 1>&2
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug      show commands executed by this script
echo     -install    install latest package (if outdated)
echo     -timer      display total elapsed time
echo     -verbose    display progress messages
echo.
echo   Subcommands:
echo     help        display this help message
goto :eof

:outdated
set __PROJ_DIR=%~1

pushd "%__PROJ_DIR%"
@rem echo Current directory: !__PROJ_DIR:%_ROOT_DIR%=!

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_NPM_CMD% outdated ^| findstr /v Wanted 1>&2
) else if %_VERBOSE%==1 ( echo Search for outdated packages in directory !__PROJ_DIR:%_ROOT_DIR%=! 1>&2
)
for /f "tokens=1,2,3,4,*" %%i in ('%_NPM_CMD% outdated ^| findstr /v Wanted') do (
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
        echo    Outdated package !__PKG_NAME!: current=!__CURRENT!, latest=!__LATEST!
        if %_INSTALL%==1 (
            if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_NPM_CMD% install -audit !__PKG_NAME!@!__LATEST! --save 1^>NUL 1>&2
            ) else if %_VERBOSE%==1 ( echo    Install package !__PKG_NAME!@!__LATEST! 1>&2
            )
            call %_NPM_CMD% install -audit !__PKG_NAME!@!__LATEST! --save 1>NUL
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
