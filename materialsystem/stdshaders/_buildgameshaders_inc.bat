@echo off
setlocal enabledelayedexpansion
echo.

rem Use dynamic shaders to build .inc files only
set dynamic_shaders=1

@REM find vs2017 directory, if vswhere doesn't exist, skip
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
	for /f "usebackq tokens=1* delims=: " %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.VisualStudio.Workload.NativeDesktop`) do (
		if /i "%%i"=="installationPath" (
			set VSDIR=%%j
			call "!VSDIR!\Common7\Tools\VsDevCmd.bat" >nul
			echo Using VS2017 tools
			goto :start
		)
	)	
) else if exist "%VS140COMNTOOLS%vsvars32.bat" (
	call "%VS140COMNTOOLS%vsvars32.bat"
	echo Using VS2015 tools
	
) else if exist "%VS120COMNTOOLS%vsvars32.bat" (
	call "%VS120COMNTOOLS%vsvars32.bat"
	echo Using VS2013 tools
	
) else if exist "%VS100COMNTOOLS%vsvars32.bat" (
	call "%VS100COMNTOOLS%vsvars32.bat"
	echo Using VS2010 tools
	
) else echo Install Either Visual Studio Version 2010, 2013, 2015, or 2017

:start
rem ================================
rem ==== MOD PATH CONFIGURATIONS ===

rem == Set the absolute path to your mod's game directory here ==
rem == Note that this path needs does not support long file/directory names ==
rem == So instead of a path such as "C:\Program Files\Steam\steamapps\mymod" ==
rem == you need to find the 8.3 abbreviation for the directory name using 'dir /x' ==
rem == and set the directory to something like C:\PROGRA~2\Steam\steamapps\sourcemods\mymod ==
set GAMEDIR=%cd%\..\..\..\..\output\demez_asw
echo GAMEDIR: %GAMEDIR%

rem == Set the relative path to steamapps\common\Alien Swarm\bin ==
rem == As above, this path does not support long directory names or spaces ==
rem == e.g. ..\..\..\..\..\PROGRA~2\Steam\steamapps\common\ALIENS~1\bin ==
set "SDKBINDIR=C:\Program Files (x86)\Steam\steamapps\common\Alien Swarm\bin"

rem ==  Set the Path to your mods root source code ==
rem this should already be correct, accepts relative paths only!
set SOURCEDIR=..\..

rem ==== MOD PATH CONFIGURATIONS END ===
rem ====================================





set TTEXE=..\..\devtools\bin\timeprecise.exe
if not exist %TTEXE% goto no_ttexe
goto no_ttexe_end

:no_ttexe
set TTEXE=time /t
:no_ttexe_end


rem echo.
rem echo ~~~~~~ buildsdkshaders %* ~~~~~~
%TTEXE% -cur-Q
set tt_all_start=%ERRORLEVEL%
set tt_all_chkpt=%tt_start%

set BUILD_SHADER=call buildshaders.bat
set ARG_EXTRA=

%BUILD_SHADER% stdshader_dx9_20b		-game %GAMEDIR% -source %SOURCEDIR% %dynamic_shaders%
%BUILD_SHADER% stdshader_dx9_20b_new		-game %GAMEDIR% -source %SOURCEDIR% %dynamic_shaders% -dx9_30
%BUILD_SHADER% stdshader_dx9_30			 -game %GAMEDIR% -source %SOURCEDIR% %dynamic_shaders% -dx9_30	-force30


rem echo.
if not "%dynamic_shaders%" == "1" (
  rem echo Finished full buildallshaders %*
) else (
  rem echo Finished dynamic buildallshaders %*
)

rem %TTEXE% -diff %tt_all_start% -cur
rem echo.

pause
pause
pause