@echo off
setlocal ENABLEDELAYEDEXPANSION

if "%1"=="" goto :missing_argument
if "%2"=="" goto :argument_ok

:missing_argument
:: Print usage message if the user didn't specify a third-party directory
echo usage: fetch_dependencies [path\to\third_party_dir]
echo   third_party_dir: the directory that will contain the third-party dependencies
exit /b 1

:argument_ok

:: Create third-party dependencies directory if it doesn't already exist,
:: and run git clone commands from that directory
if not exist "%~f1" mkdir %~f1
pushd %~f1

:: Download dependencies
set ssh_remote=git@url.to.the.repo.server

:: read depends.csv, skip first 2 lines, separate into %%a, %%b, and %%c using space and ',' as delimiters
for /f "skip=2 tokens=1,2,3 delims=, " %%a IN (%~dp0\dependencies.csv) do (

	::set variables
	SET name=%%a
	SET branch=%%b
	SET url=%%c

	echo.
	echo !name!-!branch!
	echo -----
	
	if exist !name! (
		echo Making sure that !name! is !name!-!branch!...
		pushd !name!
		::check if inside git repo
		if exist .git (
			::if yes, update
			git fetch --all --tags --quiet
			echo Checking out !name!-!branch!
			git checkout --force tags/!branch! --quiet
		) else (
			::if not, delete that folder and re-clone
			popd
			echo removing broken !name! folder
			rmdir /s /q !name!
			goto :clone
		)
		popd
	) else (
:clone
		echo Cloning !name!-!branch!...
		git clone !ssh_remote!:!url! -b !branch! !name!
	)
	echo.
)
echo.

echo Done fetching dependencies.
popd

exit /b 0