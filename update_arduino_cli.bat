@echo off
:::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                 ::
::             Gesture Controlled Robot            ::
::                                                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::
:: author  : Cornel Cristea                        ::
:: date    : 22/06/2024                            ::
:: version : 1.0.0                                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal enabledelayedexpansion

    rem update PATH variable
        set "workdir=%cd%"
        set "arduino_cli_path=%workdir%\tools\arduino-cli"
        set "PATH=%arduino_cli_path%;%PATH%"

    rem get current version
        set "current_version="
        for /f "tokens=3 delims=: " %%v in ('arduino-cli version 2^>nul') do set "version_string=%%v"
        for /f "tokens=1-3 delims=." %%a in ("!version_string!") do set "current_version=%%a.%%b.%%c"

    rem get version from input
        if "%1" equ "" ( 
            call :InfoMessage %current_version%
            set /p "ARDUINO_CLI_VERSION=Enter the new version: "            
        ) else (
            set "ARDUINO_CLI_VERSION=%1" 
        )

    rem check if new version is already installed
        if "%ARDUINO_CLI_VERSION%" == "%current_version%" (
            call :PrintInfo arduino-cli %ARDUINO_CLI_VERSION% already installed.
            exit /b 0
        )

    rem download new version
        set "arduino_cli_url=https://downloads.arduino.cc/arduino-cli/arduino-cli_%ARDUINO_CLI_VERSION%_Windows_64bit.zip"
        set "arduino_cli_zip=%arduino_cli_path%\arduino-cli_%ARDUINO_CLI_VERSION%_Windows_64bit.zip"

        powershell -Command "Invoke-WebRequest -Uri \"%arduino_cli_url%\" -OutFile \"%arduino_cli_zip%\"" || call :ReturnError %ARDUINO_CLI_VERSION% not found
        powershell -Command "Expand-Archive -Path %arduino_cli_zip% -DestinationPath %arduino_cli_path% -Force"
        
        :: delete downloaded archive after it was extracted
        if exist %arduino_cli_zip% del /F /Q %arduino_cli_zip%

        call :PrintInfo arduino-cli %ARDUINO_CLI_VERSION% has been installed.
        exit /b 0

endlocal

exit /b

:InfoMessage 
    echo.
    echo :::::::::::::::::::::::::::::::::::::::::::::::::::::
    echo ::                                                 ::
    echo ::             GESTURE CONTROLLED ROBOT            ::
    echo ::                Build Environment                ::
    echo ::                                                 ::
    echo :::::::::::::::::::::::::::::::::::::::::::::::::::::
    echo :: author  : Cornel Cristea                        ::
    echo :: date    : 22/06/2024                            ::
    echo :: version : 1.0.0                                 ::
    echo :::::::::::::::::::::::::::::::::::::::::::::::::::::
    echo.
    echo This program is used to update Arduino CLI tool        
    echo.
    echo Current version : %1
    echo.
    echo Enter the new version (e.g: 1.0.1) 
    exit /b 0

:ReturnError 
    echo [ ERROR ] %*
    exit 1

:PrintInfo
    echo [ INFO ] %*
    exit /b