@echo off

setlocal
    call setup_env.bat

    set "src_input=%1"

    if "%src_input%"=="b"      call :Build %robot_src_dir% && call :Build %controller_src_dir%
    if "%src_input%"=="r"      call :Release
    if "%src_input%"=="br"     call :Build %robot_src_dir%
    if "%src_input%"=="bc"     call :Build %controller_src_dir%

endlocal
goto :eof

:Build
    for %%f in ("%1") do set "src_file=%%~nxf"
    echo =====================================
    echo Build %src_file%
    echo =====================================
    arduino-cli compile -v -b arduino:%platform_name%:%board_name% %1 --config-file %config_yml% --output-dir %build_dir%
    goto :eof