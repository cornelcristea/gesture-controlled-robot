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

    rem variables
        set "workdir=%cd%"
        set "robot_src_dir=%workdir%\src\robot"
        set "controller_src_dir=%workdir%\src\controller"
        set "lib_dir=%workdir%\lib"
        set "arduino_cli_path=%workdir%\tools\arduino-cli"
        set "build_dir=%workdir%\build"
        set "log_dir=%workdir%\logs"
        set "config_yml=%workdir%\config.yml"
        set "path_7zip=%workdir%\tools\7-zip"
        set "arduino_dir=%workdir%\arduino15\data\packages\arduino\hardware\%platform_name%\%platform_version%"
        set "release_dir=%workdir%\release"
        set "robot_release_dir=%release_dir%\robot"
        set "controller_release_dir=%release_dir%\controller"
        set "delivery_zip=%workdir%\binary_files.zip"

    rem update PATH variable
        set "PATH=%PATH%;%arduino_cli_path%;%path_7zip%"

    rem arduino config
        set "platform_name=avr"
        set "platform_version=1.8.6"
        set "board_name=nano"
 
    rem set option
        call :InfoMessage
        if "%1" equ "" (
            set /p "user_input=Enter your choice: " && echo.
        ) else (
            set "user_input=%1"
            echo Selected option: %user_input% && echo.       
        )
        
    rem create logs folder
        if not exist %log_dir% mkdir %log_dir%
         
    rem call specific function for user_input
        if "%user_input%"=="b"      call :Build %robot_src_dir% && call :Build %controller_src_dir%
        if "%user_input%"=="r"      call :Release
        if "%user_input%"=="br"     call :Build %robot_src_dir%
        if "%user_input%"=="bc"     call :Build %controller_src_dir%
        if "%user_input%"=="a"      call :InstallArduino
        if "%user_input%"=="l"      call :InstallLibraries
        :: if "%user_input%" equ "" echo Input parameter invalid && exit /b 1
        
endlocal

goto :eof

:: display console info
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
    echo To generate binary files, arduino platform and 
    echo project libraries have to be installed first.
    echo.
    echo The available options are:
    echo.
    echo [b]    ^Build              ^Generate binary files
    echo [r]    ^Release            ^Create delivery archive
    echo [l]    ^Libraries          ^Install project libraries
    echo [a]    ^Arduino            ^Install arduino platform
    echo [br]   ^Build robot        ^Compile only robot
    echo [bc]   ^Build controller   ^Compile only controller
    echo.
    exit /b


:: install arduino package
:InstallArduino
    call :PrintStep Download Arduino platform
    arduino-cli core install arduino:%platform_name%@%platform_version% ^
        --config-file %config_yml% ^
        --log-file %log_dir%\install_arduino.log || call :ReturnError Platform arduino:%platform_name%@%platform_version% installation failed.
    exit /b
    
:: install project libraries
:InstallLibraries
    call :PrintStep Install libraries
    for %%f in ("%lib_dir%\*.zip") do (
        set "lib_name=%%~nf"
        arduino-cli lib install ^
            --config-file %config_yml% ^
            --zip-path %%f ^
            --log-file %log_dir%\install_!lib_name!.log || call :ReturnError Library '%%f' installed failed.
    )
    exit /b

:: build project
:Build
    for %%f in ("%1") do set "src_file=%%~nxf"
    call :PrintStep Build %src_file%

    if not exist %arduino_dir% call :ReturnError Arduino dependencies not installed.
    
    if exist %build_dir% rmdir /s /q %build_dir%
    mkdir %build_dir%

    arduino-cli compile -v -b arduino:%platform_name%:%board_name% %1 ^
        --build-property compiler.c.elf.flags="-Wl,-Map,%build_dir%\%src_file%.map" ^
        --config-file %config_yml% ^
        --output-dir %build_dir% ^
        --log-file %log_dir%\build_%src_file%.log || call :ReturnError Build failed.
    exit /b

:: create release zip archive
:Release
    call :PrintStep Create delivery package

    rem create folders and copy files
        if exist %release_dir% rmdir /s /q %release_dir%
        mkdir %robot_release_dir% %controller_release_dir%
        
        if not exist %build_dir% call :ReturnError Binary files not found. Build project first.

        if exist %delivery_zip% del /f /q %delivery_zip% 

        echo Copy binary files in specific folders.
        for %%f in ("%build_dir%\*") do (
            set "filename=%%~nxf"
            echo "!filename!" | findstr /C:"controller" >nul
            if !errorlevel! equ 0 (
                copy /y "%%f" "%controller_release_dir%" || call :ReturnError %%f not found.
            ) else (
                copy /y "%%f" "%robot_release_dir%" || call :ReturnError %%f not found.
            )
        )
        dir "%release_dir%\controller" "%release_dir%\robot" > "%release_dir%\Readme.txt"
        
    rem create delivery archive
        echo Create '%delivery_zip%' archive.
        7z a %delivery_zip% %release_dir% || call :ReturnError Archive %delivery_zip% could not be created.      
    
    rem delete release folder
        rmdir /s /q %release_dir%

    exit /b
 
:: dispaly step message
:PrintStep 
    echo =====================================
    echo %*
    echo =====================================
    exit /b

:: display error message
:ReturnError %*
    echo [ ERROR ] %*
    pause
    exit 1

