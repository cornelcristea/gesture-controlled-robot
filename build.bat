@echo off
setlocal

set "ROOT_DIR=%cd%"
set "SRC_DIR=%ROOT_DIR%\src"
set "TOOLS_DIR=%ROOT_DIR%\tools"
set "LIBS_DIR=%ROOT_DIR%\libs"
set "BUILD_DIR=%ROOT_DIR%\build"
set "CONFIG_YML=%ROOT_DIR%\config.yml"

echo =====================================
echo Prepare build environment
echo =====================================
if exist %BUILD_DIR% rmdir /s /q %BUILD_DIR%
mkdir %BUILD_DIR%
echo F | xcopy /e /s %SRC_DIR%\controler_tx.ino %BUILD_DIR%\controler_tx\
echo F | xcopy /e /s %SRC_DIR%\robot_rx.ino     %BUILD_DIR%\robot_rx\

set PATH=%PATH%;%TOOLS_DIR%
pushd %BUILD_DIR%
    echo =====================================
    echo Download Arduino
    echo =====================================
    arduino-cli core install arduino:avr --config-file %CONFIG_YML%
    echo.
    echo =====================================
    echo Install libraries
    echo =====================================
    arduino-cli lib install --config-file %CONFIG_YML% --zip-path %LIBS_DIR%\VirtualWire.zip
    arduino-cli lib install --config-file %CONFIG_YML% --zip-path %LIBS_DIR%\MPU6050_tockn.zip
    arduino-cli lib install --config-file %CONFIG_YML% --zip-path %LIBS_DIR%\Wire.zip
    echo.
    echo =====================================
    echo Build controller_tx
    echo =====================================
    arduino-cli compile -v -b arduino:avr:nano --config-file %CONFIG_YML% controler_tx.ino
    echo.
    echo =====================================
    echo Build robot_rx
    echo =====================================
    arduino-cli compile -v -b arduino:avr:nano --config-file %CONFIG_YML% robot_rx.ino
popd

endlocal