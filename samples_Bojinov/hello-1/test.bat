@echo off
setlocal enabledelayedexpansion

set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for %%f in ("%~dp0..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _NPM_CMD=npm.cmd
set _NPM_OPTS=

set _MOCHA_CMD=%_ROOT_DIR%node_modules\.bin\mocha.cmd
if not exist "%_MOCHA_CMD%" (
    if %_DEBUG%==1 echo [%_BASENAME%] %_NPM_CMD% install mocha
    %_NPM_CMD% install mocha
    if not exist "%_MOCHA_CMD%" (
        if %_DEBUG%==1 echo [%_BASENAME%] npm installation failed ^(mocha module^)
        set _EXITCODE=1
        goto end
    )
)
rem set _MOCHA_OPTS=--recursive --grep tags
set _MOCHA_OPTS=--recursive
if %_DEBUG%==1 set _MOCHA_OPTS=--debug %_MOCHA_OPTS%

rem ##########################################################################
rem ## Main

if %_DEBUG%==1 echo [%_BASENAME%] %_MOCHA_CMD% %_MOCHA_OPTS%
%_MOCHA_CMD% %_MOCHA_OPTS%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] Mocha execution failed
	set _EXITCODE=1
    goto end
)

goto end

rem ##########################################################################
rem ## Subroutines

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal
