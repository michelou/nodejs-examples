@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

where /q rimraf.cmd
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] rimraf command not found
    set _EXITCODE=1
    goto end
)

rem ##########################################################################
rem ## Main

set _N=0
for %%i in (auth-passport locales-1 locales-2 webaudio-sample) do (
    set _DIR=%_ROOT_DIR%%%i\node_modules
    if exist "!_DIR!" (
        if %_DEBUG%==1 echo [%_BASENAME%] rimraf.cmd "!_DIR!"
        call rimraf.cmd "!_DIR!"
        set /a _N=+1
    )
)
if %_N% gtr 0 ( echo Removed %_N% directories
) else ( echo No directory 'node_modules' found
)

goto end

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal
