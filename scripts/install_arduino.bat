@echo off

call setup_env.bat

echo =====================================
echo Download Arduino dependencies
echo ===================================== 
arduino-cli core install arduino:%platform_name%@%platform_version% --config-file %config_yml% 
echo.
echo =====================================
echo Install project libraries
echo =====================================
for %%f in ("%lib_dir%\*.zip") do (
    arduino-cli lib install --config-file %config_yml% --zip-path %%f 
)
goto :eof