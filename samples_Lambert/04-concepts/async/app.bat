@echo off
setlocal enabledelayedexpansion

set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

for %%f in ("%~dp0..\..") do call %%~sf\setenv.bat
if not %_EXITCODE%==0 goto end

set _NODE_CMD=node.exe
set _NODE_OPTS=

set _NODE_FILE=%_ROOT_DIR%app\async.js
if not exist "%_NODE_FILE%" (
    if %_DEBUG%==1 echo [%_BASENAME%] Node source file not found ^(%_NODE_FILE%^)
	set _EXITCODE=1
	goto end
)

rem ##########################################################################
rem ## Main

if %_DEBUG%==1 echo [%_BASENAME%] %_NODE_CMD% %_NODE_OPTS% %_NODE_FILE%
%_NODE_CMD% %_NODE_OPTS% %_NODE_FILE%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] Node execution failed ^(%_NODE_FILE%^)
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
