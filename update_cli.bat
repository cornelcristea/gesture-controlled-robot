@echo off

setlocal enabledelayedexpansion

    :: default version
    set "ARDUINO_CLI_VERSION=1.0.1"

    :: get version from input
    if "%1" neq "" set "ARDUINO_CLI_VERSION=%1"

    :: update PATH variable
    set "TOOLS_DIR=%~dp0"
    set "PATH=%PATH%;%TOOLS_DIR%"

    rem check if version is installed
        set "CURRENT_VERSION="
        for /f "tokens=3 delims=: " %%v in ('arduino-cli version 2^>nul') do set "VERSION_STRING=%%v"
        for /f "tokens=1-3 delims=." %%a in ("!VERSION_STRING!") do set "CURRENT_VERSION=%%a.%%b.%%c"
        if "%ARDUINO_CLI_VERSION%" == "%CURRENT_VERSION%" (
            echo [ INFO ] arduino-cli %ARDUINO_CLI_VERSION% already installed.
            exit /b 0 
        )

    rem get desired version
        set "ARDUINO_CLI_URL=https://downloads.arduino.cc/arduino-cli/arduino-cli_%ARDUINO_CLI_VERSION%_Windows_64bit.zip"
        set "ARDUINO_CLI_ZIP=%TOOLS_DIR%\arduino-cli_%ARDUINO_CLI_VERSION%_Windows_64bit.zip"

        powershell -Command "Invoke-WebRequest -Uri \"%ARDUINO_CLI_URL%\" -OutFile \"%ARDUINO_CLI_ZIP%\""
        powershell -Command "Expand-Archive -Path %ARDUINO_CLI_ZIP% -DestinationPath %TOOLS_DIR% -Force"

        if exist %ARDUINO_CLI_ZIP% del /F /Q %ARDUINO_CLI_ZIP%

        echo [ INFO ] arduino-cli %ARDUINO_CLI_VERSION% has been installed.

endlocal