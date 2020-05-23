@echo off
setlocal enabledelayedexpansion

if defined DEBUG ( set _DEBUG=1 ) else ( set _DEBUG=0 )

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0
set "_ROOT_DIR=%~dp0"

call :env
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

set _N=0

set _DIR=%_ROOT_DIR%node_modules\
if exist "!_DIR!" (
    if %_DEBUG%==1 echo [%_BASENAME%] call rimraf.cmd "!_DIR!" 1>&2
    call rimraf.cmd "!_DIR!"
    set /a _N+=1
)

for /f %%i in ('dir /ad /b 2^>NUL') do (
    set _DIR=%_ROOT_DIR%%%i\node_modules
    if exist "!_DIR!" (
        if %_DEBUG%==1 echo [%_BASENAME%] call rimraf.cmd "!_DIR!" 1>&2
        call rimraf.cmd "!_DIR!"
        set /a _N+=1
    )
)
if %_N% gtr 1 ( echo Removed %_N% directories
) else if %_N% gtr 0 ( echo Removed %_N% directory 
) else ( echo No directory 'node_modules' found
)

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

if defined NODE_HOME (
    set "_NODE_HOME=%NODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable NODE_HOME 1>&2
) else (
    where /q node.exe
    if !ERRORLEVEL!==0 (
        for /f %%i in ('where /f node.exe') do set _NODE_HOME=%%~dpsi
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Node executable found in PATH 1>&2
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\nodejs*" 2^>NUL') do set _NODE_HOME=!_PATH!\%%f
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
    %_NODE_HOME%\npm.cmd -g install rimraf
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to install rimraf 1>&2
        set _EXITCODE=1
        goto end
    )
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
