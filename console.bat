@echo off

setlocal enabledelayedexpansion

    :BEGIN
        rem variables
            set "ROOT_DIR=%cd%"
            set "ARDUINO_DIR=%ROOT_DIR%\arduino15"
            set "SRC_DIR_RX=%ROOT_DIR%\src\robot"
            set "SRC_DIR_TX=%ROOT_DIR%\src\controller"
            set "LIBS_DIR=%ROOT_DIR%\libs"
            set "TOOLS_DIR=%ROOT_DIR%\tools"
            set "BUILD_DIR=%ROOT_DIR%\build"
            set "CONFIG_YML=%ROOT_DIR%\config.yml"
            :: update PATH variable
            set "PATH=%PATH%;%TOOLS_DIR%"
            :: arduino config
            set "PLATFORM_NAME=avr"
            set "PLATFORM_VERSION=1.8.6"
            set "BOARD_NAME=nano"

        rem console info
            echo.
            echo :::::::::::::::::::::::::::::::::::::::::::::::::::::
            echo ::                                                 ::
            echo ::             Gesture Controlled Robot            ::
            echo ::                                                 ::
            echo :::::::::::::::::::::::::::::::::::::::::::::::::::::
            echo :: author  : Cornel Cristea                        ::
            echo :: date    : 22/06/2024                            ::
            echo :: version : 1.0.0                                 ::
            echo :::::::::::::::::::::::::::::::::::::::::::::::::::::
            echo.
            echo This program is used to perform project actions.
            echo The arduino dependencies will be downloaded and 
            echo project libraries will be installed.
            echo.
            echo The available option are:
            echo.
            echo 1. ^Build                  ^Generate output files
            echo 2. ^Release                ^Create release package
            echo 3. ^Build robot            ^Compile robot code
            echo 4. ^Build controller       ^Compile controller code             
            echo 5. ^Update CLI             ^Update arduino-cli tool
            echo.
        
        echo Enter your choice.
        set /p INPUT=

        :: install arduino package
        if not exist %ARDUINO_DIR% call :InstallDependencies

        :: call specific function for input
        if %INPUT% equ 1    call :Build %SRC_DIR_RX% && call :Build %SRC_DIR_TX%
        if %INPUT% equ 2    call :Release
        if %INPUT% equ 3    call :Build %SRC_DIR_RX%
        if %INPUT% equ 4    call :Build %SRC_DIR_TX%
        if %INPUT% equ 5    call :UpdateCLI

        goto :BEGIN

    :: install arduino and libraries
    :InstallDependencies
        echo =====================================
        echo Download Arduino dependencies
        echo ===================================== 
        arduino-cli core install arduino:%PLATFORM_NAME%@%PLATFORM_VERSION% --config-file %CONFIG_YML% || call :ErrorMsg Arduino installation failed.
        echo.
        echo =====================================
        echo Install project libraries
        echo =====================================
        for %%f in (%LIBS_DIR%\*.zip) do (
            arduino-cli lib install --config-file %CONFIG_YML% --zip-path %%f || call :ErrorMsg Library "%%f" cannot be installed.
        )
        exit /b 0

    :: build project
    :Build
        echo =====================================
        echo Build %1
        echo =====================================
        arduino-cli compile -v -b arduino:%PLATFORM_NAME%:%BOARD_NAME% %1 --config-file %CONFIG_YML% --output-dir %BUILD_DIR% || call :ErrorMsg Build failed.
        exit /b 0

    :: create release zip archive
    :Release
        echo Under construction
        exit /b 0

    :: update arduino-cli tool
    :UpdateCLI
        echo Under construction
        exit /b 0

    :: display error message
    :ErrorMsg %*
        echo [ ERROR ] %*
        exit /b 1

endlocal