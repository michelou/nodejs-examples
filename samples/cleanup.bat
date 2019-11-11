@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

call :env
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

set _N=0
for %%i in (auth-passport locales-1 locales-2 webaudio-sample) do (
    set __DIR=%_ROOT_DIR%%%i\node_modules
    if exist "!__DIR!\" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% rimraf.cmd "!__DIR!" 1>&2
        call rimraf.cmd "!__DIR!"
        set /a _N+=1
    )
)
if %_N% gtr 0 ( echo Removed %_N% directories
) else ( echo No directory 'node_modules' found
)

goto end

rem ##########################################################################
rem ## Subroutines

rem output parameter(s): _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

where /q rimraf.cmd
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% rimraf command not found 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
