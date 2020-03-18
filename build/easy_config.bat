@echo off

set ThirdPartyDir=%~f1
if "%ThirdPartyDir%"=="" (
	echo Default 3rd Party directory .\3rdParty being used
	set ThirdPartyDir=%cd%\3rdParty
) else (
	echo Using %ThirdPartyDir% as 3rd Party directory
)

:: Create directory if it doesn't already exist
if not exist "%ThirdPartyDir%" (
	mkdir "%ThirdPartyDir%"
)

:: Auto-setup 3rdParty
echo Setting up 3rd Party Libraries ^& Utilities
echo.
echo Fetching dependencies...
echo.
echo "%~dp0..\scripts\fetch_dependencies.cmd" "%ThirdPartyDir%"
echo.
call "%~dp0..\scripts\fetch_dependencies.cmd" "%ThirdPartyDir%"

:: Remove CMake-generated files that should be regenerated
set CMakeGeneratedFiles=("CMakeCache.txt" ^
                         "build.bat" ^
                         "make_install.bat" ^
                         "reconfig.bat" ^
                         "run_tests.bat")
for %%G in %CMakeGeneratedFiles% do (
    call :remove_if_exists %~dp0\%%G 
)

:: Configure solution using default values
echo Configuring project files...
echo.
echo cmake -G ^"Visual Studio 16 2019^" -A x64 -DCMAKE_PREFIX_PATH="%ThirdPartyDir%" -DCMAKE_INSTALL_PREFIX="%cd%\install" "%~dp0..\src"
echo.
cmake -G "Visual Studio 16 2019" -A x64 -DCMAKE_PREFIX_PATH="%ThirdPartyDir%" -DCMAKE_INSTALL_PREFIX="%cd%\install" "%~dp0..\src"
echo.

@pause
exit /b 0

:remove_if_exists
if exist "%~1" (
    echo Removing %~1f
    del "%~1"
)
exit /b 0