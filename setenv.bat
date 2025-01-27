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

set _GIT_PATH=
set _MONGOSH_PATH=
set _VSCODE_PATH=

call :mongodb
if not %_EXITCODE%==0 goto end

call :mongosh
@rem optional
@rem if not %_EXITCODE%==0 goto end

call :node 18
if not %_EXITCODE%==0 goto end

call :node 20
if not %_EXITCODE%==0 goto end

call :node 22
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

call :vscode
if not %_EXITCODE%==0 (
    @rem optional
    set _EXITCODE=0
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _BASENAME, _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd

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

@rem we define _RESET in last position to avoid crazy console output with type command
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m
set _RESET=[0m
goto :eof

@rem input parameter: %*
@rem output parameters: _BASH, _HELP, _VERBOSE
:args
set _BASH=0
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-bash" ( set _BASH=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
call :drive_name "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _BASH=%_BASH% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% 1>&2
    echo %_DEBUG_LABEL% Variables  : _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter: %1: path to be substituted
@rem output parameter: _DRIVE_NAME (2 characters: letter + ':')
:drive_name
set "__GIVEN_PATH=%~1"
@rem remove trailing path separator if present
if "%__GIVEN_PATH:~-1,1%"=="\" set "__GIVEN_PATH=%__GIVEN_PATH:~0,-1%"

@rem https://serverfault.com/questions/62578/how-to-get-a-list-of-drive-letters-on-a-system-through-a-windows-shell-bat-cmd
set __DRIVE_NAMES=F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:
for /f %%i in ('wmic logicaldisk get deviceid ^| findstr :') do (
    set "__DRIVE_NAMES=!__DRIVE_NAMES:%%i=!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(WMIC^) 1>&2
if not defined __DRIVE_NAMES (
    echo %_ERROR_LABEL% No more free drive name 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst') do (
    set "__SUBST_DRIVE=%%f"
    set "__SUBST_DRIVE=!__SUBST_DRIVE:~0,2!"
    set "__SUBST_PATH=%%h"
    @rem Windows local file systems are not case sensitive (by default)
    if /i "!__SUBST_DRiVE!"=="!__GIVEN_PATH:~0,2!" (
        set _DRIVE_NAME=!__SUBST_DRIVE:~0,2!
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    ) else if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set "_DRIVE_NAME=!__SUBST_DRIVE!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    )
)
for /f "tokens=1,2,*" %%i in ('subst') do (
    set __USED=%%i
    call :drive_names "!__USED:~0,2!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(SUBST^) 1>&2

set "_DRIVE_NAME=!__DRIVE_NAMES:~0,2!"
if /i "%_DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%_DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
)
subst "%_DRIVE_NAME%" "%__GIVEN_PATH%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=Used drive name
@rem output parameter: __DRIVE_NAMES
:drive_names
set "__USED_NAME=%~1"
set "__DRIVE_NAMES=!__DRIVE_NAMES:%__USED_NAME%=!"
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
echo     %__BEG_O%-bash%__END%       start Git bash shell instead of Windows command prompt
echo     %__BEG_O%-debug%__END%      print commands executed by this script
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        print this help message
goto :eof

@rem output parameter: _MONGODB_HOME
:mongodb
set _MONGODB_HOME=

set __MONGOD_CMD=
for /f "delims=" %%f in ('where mongod.exe 2^>NUL') do set "__MONGOD_CMD=%%f"
if defined __MONGOD_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of MongoDB daemon executable found in PATH 1>&2
    goto :eof
) else if defined MONGODB_HOME (
    set "_MONGODB_HOME=%MONGODB_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MONGODB_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\mongodb\" ( set "_MONGODB_HOME=!__PATH!\mongodb"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mongodb-win32*" 2^>NUL') do set "_MONGODB_HOME=!__PATH!\%%f"
        if not defined _MONGODB_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mongodb-win32**" 2^>NUL') do set "_MONGODB_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_MONGODB_HOME%\bin\mongod.exe" (
    echo %_ERROR_LABEL% MongoDB daemon executable not found ^("%_MONGODB_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _MONGOSH_HOME, _MONGOSH_PATH
:mongosh
set _MONGOSH_HOME=
set _MONGOSH_PATH=

set __MONGOSH_CMD=
for /f "delims=" %%f in ('where mongosh.exe 2^>NUL') do set "__MONGOSH_CMD=%%f"
if defined __MONGOSH_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of MongoDB Shell executable found in PATH 1>&2
    @rem keep _MONGOSH_PATH undefined since executable already in path
    goto :eof
) else if defined MONGOSH_HOME (
    set "_MONGOSH_HOME=%MONGOSH_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MONGOSH_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\mongosh\" ( set "_MONGOSH_HOME=!__PATH!\mongosh"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mongosh*" 2^>NUL') do set "_MONGOSH_HOME=!__PATH!\%%f"
        if not defined _MONGOSH_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mongosh-**" 2^>NUL') do set "_MONGOSH_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_MONGOSH_HOME%\bin\mongosh.exe" (
    echo %_ERROR_LABEL% MongoDB Shell executable not found ^("%_MONGOSH_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MONGOSH_PATH=;%_MONGOSH_HOME%\bin"
goto :eof

@rem input parameter: %1=major version
@rem output parameter: NODE18_HOME (resp. NODE20_HOME)
:node
set __NODE_MAJOR=%~1
set "_NODE!__NODE_MAJOR!_HOME="

set __NODE_CMD=
for /f "delims=" %%f in ('where node.exe 2^>NUL') do set "__NODE_CMD=%%f"
if defined __NODE_CMD (
    for /f "delims=. tokens=1,*" %%i in ('"%__NODE_CMD%" --version') do (
        if not "%%i"=="v%__NODE_MAJOR%" set __NODE_CMD=
    )
)
set "__NODE_HOME=%NODE_HOME%"
if defined __NODE_HOME (
    for /f "delims=. tokens=1,*" %%i in ('"%__NODE_HOME%\node.exe" --version') do (
        if not "%%i"=="v%__NODE_MAJOR%" set __NODE_HOME=
    )
)
if defined __NODE_CMD (
    for /f "delims=" %%i in ("%__NODE_CMD%") do set "_NODE!__NODE_MAJOR!_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of npm executable found in PATH 1>&2
    goto :eof
) else if defined __NODE_HOME (
    set "_NODE_HOME=%__NODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable NODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\node-v%__NODE_MAJOR%*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    if not defined _NODE_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\node-v%__NODE_MAJOR%*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    )
)
if not exist "%_NODE_HOME%\nodevars.bat" (
    echo %_ERROR_LABEL% Node installation directory not found ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%_NODE_HOME%\node.exe" (
    echo %_ERROR_LABEL% Node executable not found ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_NODE!__NODE_MAJOR!_HOME=%_NODE_HOME%"
@rem call "%NODE_HOME%\nodevars.bat"
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f "delims=" %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^(%_GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\usr\bin;%_GIT_HOME%\mingw64\bin"
goto :eof

@rem output parameters: _VSCODE_HOME, _VSCODE_PATH
:vscode
set _VSCODE_HOME=
set _VSCODE_PATH=

set __CODE_CMD=
for /f "delims=" %%f in ('where code.exe 2^>NUL') do set "__CODE_CMD=%%f"
if defined __CODE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of VSCode executable found in PATH 1>&2
    @rem keep _VSCODE_PATH undefined since executable already in path
    goto :eof
) else if defined VSCODE_HOME (
    set "_VSCODE_HOME=%VSCODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable VSCODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\VSCode\" ( set "_VSCODE_HOME=!__PATH!\VSCode"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\VSCode-1*" 2^>NUL') do set "_VSCODE_HOME=!__PATH!\%%f"
        if not defined _VSCODE_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\VSCode-1*" 2^>NUL') do set "_VSCODE_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_VSCODE_HOME%\code.exe" (
    echo %_WARNING_LABEL% VSCode executable not found ^("%_VSCODE_HOME%"^) 1>&2
    if exist "%_VSCODE_HOME%\Code - Insiders.exe" (
        echo %_WARNING_LABEL% It looks like you've installed an Insider version of VSCode 1>&2
    )
    set _EXITCODE=1
    goto :eof
)
set "_VSCODE_PATH=;%_VSCODE_HOME%"
goto :eof

:print_env
set __VERBOSE=%1
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
set __VERSIONS_LINE3=
set __WHERE_ARGS=
where /q "%NODE18_HOME%:node.exe"
if %ERRORLEVEL%==0 (
    for /f %%i in ('"%NODE18_HOME%\node.exe" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% node %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%NODE18_HOME%:node.exe"
)
where /q "%NODE18_HOME%:npm.cmd"
if %ERRORLEVEL%==0 (
    for /f %%i in ('"%NODE18_HOME%\npm.cmd" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% npm %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%NODE18_HOME%:npm.cmd"
)
where /q "%NODE20_HOME%:node.exe"
if %ERRORLEVEL%==0 (
    for /f %%i in ('"%NODE20_HOME%\node.exe" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% node %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%NODE20_HOME%:node.exe"
)
where /q "%NODE20_HOME%:npm.cmd"
if %ERRORLEVEL%==0 (
    for /f %%i in ('"%NODE20_HOME%\npm.cmd" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% npm %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%NODE20_HOME%:npm.cmd"
)
where /q "%MONGODB_HOME%\bin:mongod.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%MONGODB_HOME%\bin\mongod.exe" --version ^| findstr /b db') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% mongod %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MONGODB_HOME%\bin:mongod.exe"
)
where /q "%MONGOSH_HOME%\bin:mongosh.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('"%MONGOSH_HOME%\bin\mongosh.exe" --version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% mongosh %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MONGOSH_HOME%\bin:mongosh.exe"
)
where /q "%VSCODE_HOME%\bin:code.cmd"
if %ERRORLEVEL%==0 (
    set __CODE_VERSION=
    for /f "tokens=*" %%i in ('"%VSCODE_HOME%\bin\code.cmd" --version 2^>^&1') do (
         if not defined __CODE_VERSION set "__CODE_VERSION=%%i"
    )
    set "__VERSIONS_LINE2=%__VERSIONS_LINE2% code !__CODE_VERSION!,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%VSCODE_HOME%\bin:code.cmd"
)
where /q "%GIT_HOME%\bin:git.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do (
        for /f "delims=. tokens=1,2,3,*" %%a in ("%%k") do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% git %%a.%%b.%%c,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:git.exe"
)
where /q "%GIT_HOME%\usr\bin:diff.exe"
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('"%GIT_HOME%\usr\bin\diff.exe" --version ^| findstr diff') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\usr\bin:diff.exe"
)
where /q "%GIT_HOME%\bin:bash.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('"%GIT_HOME%\bin\bash.exe" --version ^| findstr bash') do (
        set "__VERSION=%%l"
        setlocal enabledelayedexpansion
        set "__VERSIONS_LINE3=%__VERSIONS_LINE3% bash !__VERSION:-release=!"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:bash.exe"
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
echo   %__VERSIONS_LINE3%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do (
        set "__LINE=%%p"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
    echo Environment variables: 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined MONGODB_HOME echo    "MONGODB_HOME=%MONGODB_HOME%" 1>&2
    if defined MONGOSH_HOME echo    "MONGOSH_HOME=%MONGOSH_HOME%" 1>&2
    if defined NODE_HOME echo    "NODE_HOME=%NODE_HOME%" 1>&2
    if defined NODE18_HOME echo    "NODE18_HOME=%NODE18_HOME%" 1>&2
    if defined NODE20_HOME echo    "NODE20_HOME=%NODE20_HOME%" 1>&2
    if defined NODE22_HOME echo    "NODE22_HOME=%NODE22_HOME%" 1>&2
    if defined VSCODE_HOME echo    "VSCODE_HOME=%VSCODE_HOME%" 1>&2
    echo Path associations: 1>&2
    for /f "delims=" %%i in ('subst') do (
        set "__LINE=%%i"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined MONGODB_HOME set "MONGODB_HOME=%_MONGODB_HOME%"
        if not defined MONGOSH_HOME set "MONGOSH_HOME=%_MONGOSH_HOME%"
        if not defined NODE_HOME set "NODE_HOME=%_NODE20_HOME%"
        if not defined NODE18_HOME set "NODE18_HOME=%_NODE18_HOME%"
        if not defined NODE20_HOME set "NODE20_HOME=%_NODE20_HOME%"
        if not defined NODE22_HOME set "NODE22_HOME=%_NODE22_HOME%"
        if not defined VSCODE_HOME set "VSCODE_HOME=%_VSCODE_HOME%"
        @rem We prepend %_GIT_HOME%\bin to hide C:\Windows\System32\bash.exe
        set "PATH=%_GIT_HOME%\bin;%PATH%;%_NODE20_HOME%%_MONGOSH_PATH%%_GIT_PATH%%_VSCODE_PATH%;%~dp0bin"
        call :print_env %_VERBOSE%
        if not "%CD:~0,2%"=="%_DRIVE_NAME%" (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME% 1>&2
            cd /d %_DRIVE_NAME%
        )
        if %_BASH%==1 (
            @rem see https://conemu.github.io/en/GitForWindows.html
            if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_HOME%\usr\bin\bash.exe --login 1>&2
            cmd.exe /c "%_GIT_HOME%\usr\bin\bash.exe --login"
        )
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
