@echo off

setlocal enabledelayedexpansion
    rem arduino information
        set "PLATFORM_NAME=avr"
        set "PLATFORM_VERSION=1.8.6"
        set "BOARD_NAME=nano"

    rem variables
        set "ROOT_DIR=%cd%"
        set "SRC_DIR_RX=%ROOT_DIR%\src\robot_rx"
        set "SRC_DIR_TX=%ROOT_DIR%\src\controler_tx"
        set "LIBS_DIR=%ROOT_DIR%\libs"
        set "TOOLS_DIR=%ROOT_DIR%\tools"
        set "BUILD_DIR=%ROOT_DIR%\build"
        set "CONFIG_YML=%ROOT_DIR%\config.yml"

    rem update PATH variable
        set "PATH=%PATH%;%TOOLS_DIR%"

    rem download and install packages
        echo =====================================
        echo Download Arduino dependencies
        echo ===================================== 
        arduino-cli core install arduino:%PLATFORM_NAME%@%PLATFORM_VERSION% --config-file %CONFIG_YML% 
        echo.
        echo =====================================
        echo Install project libraries
        echo =====================================
        arduino-cli lib install --config-file %CONFIG_YML% --zip-path %LIBS_DIR%\VirtualWire.zip   
        arduino-cli lib install --config-file %CONFIG_YML% --zip-path %LIBS_DIR%\MPU6050_tockn.zip 
        :: Wire library already present by default on arduino avr
        :: arduino-cli lib install --config-file %CONFIG_YML% --zip-path %LIBS_DIR%\Wire.zip          
        echo.
        
    rem build project
        echo =====================================
        echo Build controller_tx
        echo =====================================
        arduino-cli compile -v -b arduino:%PLATFORM_NAME%:%BOARD_NAME% %SRC_DIR_TX% --config-file %CONFIG_YML% --output-dir ./build --log-file ./logs 
        echo.
        echo =====================================
        echo Build robot_rx
        echo =====================================
        arduino-cli compile -v -b arduino:%PLATFORM_NAME%:%BOARD_NAME% %SRC_DIR_RX% --config-file %CONFIG_YML% --output-dir ./build --log-file ./logs 


endlocal