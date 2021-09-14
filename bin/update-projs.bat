@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0\.") do set "_ROOT_DIR=%%~dpf"
@rem remove trailing backslash for virtual drives
if "%_ROOT_DIR:~-2%"==":\" set "_ROOT_DIR=%_ROOT_DIR:~0,-1%"

@rem file package.json (NB. PS regex)

@rem https://www.npmjs.com/package/async
set _ASYNC_VERSION_OLD="async": "^(.+^)3.2.0"
set _ASYNC_VERSION_NEW="async": "${1}3.2.1"

@rem https://www.npmjs.com/package/eslint
set _ESLINT_VERSION_OLD="eslint": "^(.+^)7.11.0"
set _ESLINT_VERSION_NEW="eslint": "^7.32.0"

@rem https://www.npmjs.com/package/eslint-plugin-import
set _ESLINT_PLUGIN_IMPORT_OLD="eslint-plugin-import": "^(.+^)2.22.1"
set _ESLINT_PLUGIN_IMPORT_NEW="eslint-plugin-import": "2.24.2"

@rem https://www.npmjs.com/package/express-session
set _EXPRESS_SESSION_VERSION_OLD="express-session": "^(.+^)1.17.1"
set _EXPRESS_SESSION_VERSION_NEW="express-session": "${1}1.17.2"

@rem https://www.npmjs.com/package/got
set _GOT_VERSION_OLD="got": "^(.+^)11.7.0"
set _GOT_VERSION_NEW="got": "${1}11.8.2"

@rem https://www.npmjs.com/package/i18n
set _I18N_VERSION_OLD="i18n": "^(.+^)0.13.2"
set _I18N_VERSION_NEW="i18n": "${1}0.13.3"

@rem https://www.npmjs.com/package/leveldown
set _LEVELDOWN_VERSION_OLD="leveldown": "^(.+^)6.0.1"
set _LEVELDOWN_VERSION_NEW="leveldown": "${1}6.0.2"

@rem https://www.npmjs.com/package/levelup
set _LEVELUP_VERSION_OLD="levelup": "^(.+^)4.4.0"
set _LEVELUP_VERSION_NEW="levelup": "${1}5.0.1"

@rem https://www.npmjs.com/package/moment
set _MOMENT_VERSION_OLD="moment": "^(.+^)2.26.0"
set _MOMENT_VERSION_NEW="moment": "${1}2.29.1"

@rem https://www.npmjs.com/package/mongoose
set _MONGOOSE_VERSION_OLD="mongoose": "^(.+^)5.10.9"
set _MONGOOSE_VERSION_NEW="mongoose": "${1}6.0.2"

@rem https://www.npmjs.com/package/morgan
set _MORGAN_VERSION_OLD="morgan": "^(.+^)1.9.1"
set _MORGAN_VERSION_NEW="morgan": "${1}1.10.0"

@rem deprecated
set _REQUEST_VERSION_OLD="request": "^(.+^)2.88.0"
set _REQUEST_VERSION_NEW="request": "${1}2.88.2"

@rem https://www.npmjs.com/package/webpack
set _WEBPACK_VERSION_OLD="webpack": "^(.+^)4.44.2"
set _WEBPACK_VERSION_NEW="wekpack": "${1}5.51.1"

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

for %%i in (samples samples_Bojinov samples_Cook samples_Duuna samples_Lambert) do (
@rem for %%i in (samples_Cook) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :update_project "%_ROOT_DIR%\%%i" 1>&2
    call :update_project "%_ROOT_DIR%\%%i"
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
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
@rem output parameters: _CLONE, _COMPILE, _DOCUMENTATION, _SBT, _TIMER, _VERBOSE
:args
set _HELP=0
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
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
goto args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _HELP=%_HELP% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-debug%__END%      display commands executed by this script
echo     %__BEG_O%-timer%__END%      display total execution time
echo     %__BEG_O%-verbose%__END%    display environment settings
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
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

@rem input parameter: %1=parent directory path
:update_project
set "__PARENT_DIR=%~1"
set __N1=0
echo Parent directory: %__PARENT_DIR%
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr /v node_modules') do (
    set "__PACKAGE_JSON=%__PARENT_DIR%\%%i\package.json"
    if exist "!__PACKAGE_JSON!" (
        if %_VERBOSE%==1 echo    Process file %%i\package.json

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_ASYNC_VERSION_OLD%" "%_ASYNC_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_ASYNC_VERSION_OLD%" "%_ASYNC_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_ESLINT_VERSION_OLD%" "%_ESLINT_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_ESLINT_VERSION_OLD%" "%_ESLINT_VERSION_NEW%"

        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PACKAGE_JSON!" "%_ESLINT_PLUGIN_IMPORT_VERSION_OLD%" "%_ESLINT_PLUGIN_IMPORT_VERSION_NEW%" 1>&2
        call :replace "!__PACKAGE_JSON!" "%_ESLINT_PLUGIN_IMPORT_VERSION_OLD%" "%_ESLINT_PLUGIN_IMPORT_VERSION_NEW%"

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
