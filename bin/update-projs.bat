@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf
@rem remove trailing backslash for virtual drives
if "%_ROOT_DIR:~-2%"==":\" set "_ROOT_DIR=%_ROOT_DIR:~0,-1%"

rem file package.json (NB. PS regex)
set _ASYNC_VERSION_OLD="async": "^(.+^)3.1.0"
set _ASYNC_VERSION_NEW="async": "${1}3.2.0"

set _EXPRESS_SESSION_VERSION_OLD="express-session": "^(.+^)1.17.0"
set _EXPRESS_SESSION_VERSION_NEW="express-session": "${1}1.17.1"

set _GOT_VERSION_OLD="got": "^(.+^)11.0.2"
set _GOT_VERSION_NEW="got": "${1}11.1.1"

set _I18N_VERSION_OLD="i18n": "^(.+^)0.9.0"
set _I18N_VERSION_NEW="i18n": "${1}0.9.1"

set _LEVELDOWN_VERSION_OLD="leveldown": "^(.+^)5.5.1"
set _LEVELDOWN_VERSION_NEW="leveldown": "${1}5.6.0"

set _LEVELUP_VERSION_OLD="levelup": "^(.+^)4.3.2"
set _LEVELUP_VERSION_NEW="levelup": "${1}4.4.0"

set _MOMENT_VERSION_OLD="moment": "^(.+^)2.24.0"
set _MOMENT_VERSION_NEW="moment": "${1}2.25.3"

set _MONGOOSE_VERSION_OLD="mongoose": "^(.+^)5.9.10"
set _MONGOOSE_VERSION_NEW="mongoose": "${1}5.9.12"

set _MORGAN_VERSION_OLD="morgan": "^(.+^)1.9.1"
set _MORGAN_VERSION_NEW="morgan": "${1}1.10.0"

set _REQUEST_VERSION_OLD="request": "^(.+^)2.88.0"
set _REQUEST_VERSION_NEW="request": "${1}2.88.2"

set _WEBPACK_VERSION_OLD="webpack": "^(.+^)4.41.6"
set _WEBPACK_VERSION_NEW="wekpack": "${1}4.43.0"

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

for %%i in (samples samples_Bojinov samples_Cook samples_Lambert) do (
@rem for %%i in (samples_Cook) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :update_project "%_ROOT_DIR%\%%i" 1>&2
    call :update_project "%_ROOT_DIR%\%%i"
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:
goto :eof


rem input parameter: %*
rem output parameters: _CLONE, _COMPILE, _DOCUMENTATION, _SBT, _TIMER, _VERBOSE
:args
set _HELP=
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
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
goto args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _HELP=%_HELP% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug      display commands executed by this script
echo     -timer      display total execution time
echo     -verbose    display environment settings
echo.
echo   Subcommands:
echo     help        display this help message
goto :eof

:replace
set __FILE=%~1
set __PATTERN_FROM=%~2
set __PATTERN_TO=%~3

set __PS1_SCRIPT= ^
(Get-Content '%__FILE%') ^| ^
ForEach-Object { $_ -replace '%__PATTERN_FROM:"=\"%','%__PATTERN_TO:"=\"%' } ^| ^
Set-Content '%__FILE%'

if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "%__PS1_SCRIPT%" 1>&2
powershell -C "%__PS1_SCRIPT%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Execution of ps1 cmdlet failed 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:update_project
set __PARENT_DIR=%~1
set __N1=0
echo Parent directory: %__PARENT_DIR%
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr /v node_modules') do (
    set "__PACKAGE_JSON=%__PARENT_DIR%\%%i\package.json"
    if exist "!__PACKAGE_JSON!" (
        if %_VERBOSE%==1 echo Process file %%i\package.json

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_ASYNC_VERSION_OLD%" "%_ASYNC_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_ASYNC_VERSION_OLD%" "%_ASYNC_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_EXPRESS_SESSION_VERSION_OLD%" "%_EXPRESS_SESSION_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_EXPRESS_SESSION_VERSION_OLD%" "%_EXPRESS_SESSION_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_GOT_VERSION_OLD%" "%_GOT_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_GOT_VERSION_OLD%" "%_GOT_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_I18N_VERSION_OLD%" "%_I18N_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_I18N_VERSION_OLD%" "%_I18N_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_LEVELDOWN_VERSION_OLD%" "%_LEVELDOWN_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_LEVELDOWN_VERSION_OLD%" "%_LEVELDOWN_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_LEVELUP_VERSION_OLD%" "%_LEVELUP_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_LEVELUP_VERSION_OLD%" "%_LEVELUP_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_MOMENT_VERSION_OLD%" "%_MOMENT_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_MOMENT_VERSION_OLD%" "%_MOMENT_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_MONGOOSE_VERSION_OLD%" "%_MONGOOSE_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_MONGOOSE_VERSION_OLD%" "%_MONGOOSE_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_MORGAN_VERSION_OLD%" "%_MORGAN_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_MORGAN_VERSION_OLD%" "%_MORGAN_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_REQUEST_VERSION_OLD%" "%_REQUEST_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_REQUEST_VERSION_OLD%" "%_REQUEST_VERSION_NEW%"

        set /a __N1+=1
    ) else (
       echo    %_WARNING_LABEL% Could not find file %%i\package.json 1>&2
    )
)
echo    Updated %__N1% package.json files
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
