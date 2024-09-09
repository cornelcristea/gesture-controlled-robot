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
        set "root_dir=%cd%"
        set "robot_src_dir=%root_dir%\src\robot"
        set "controller_src_dir=%root_dir%\src\controller"
        set "lib_dir=%root_dir%\lib"
        set "arduino_cli_path=%root_dir%\tools\arduino-cli"
        set "build_dir=%root_dir%\build"
        set "config_yml=%root_dir%\config.yml"
        set "path_7zip=%root_dir%\tools\7-zip"

    rem update PATH variable
        set "PATH=%PATH%;%arduino_cli_path%;%path_7zip%"

    rem arduino config
        set "platform_name=avr"
        set "platform_version=1.8.6"
        set "board_name=nano"
 
    rem set option
        if "%1" equ "" (
            call :InfoMessage
        ) else (
            set "user_input=%1"            
        )
 
    rem install arduino packages
        set "arduino_dir=%root_dir%\arduino15\data\packages\arduino\hardware\%platform_name%\%platform_version%"
        if not exist %arduino_dir% call :InstallDependencies

    rem call specific function for user_input
        if "%user_input%"=="b"      call :Build %robot_src_dir% && call :Build %controller_src_dir%
        if "%user_input%"=="r"      call :Release
        if "%user_input%"=="br"     call :Build %robot_src_dir%
        if "%user_input%"=="bc"     call :Build %controller_src_dir%
        :: if "%user_input%" equ "" echo Input parameter invalid && exit /b 1
        
endlocal

goto :eof 

:: display console info
:InfoMessage
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
    echo This program is used to generate binary files.
    echo The arduino dependencies and libraries will be 
    echo downloaded and installed in project folder.
    echo.
    echo The available options are:
    echo.
    echo [b]    ^Build              ^Generate binary files
    echo [r]    ^Release            ^Create delivery archive
    echo [br]   ^Build robot        ^Compile only robot
    echo [bc]   ^Build controller   ^Compile only controller           
    echo.
    set /p "user_input=Enter your choice: "
    goto :eof


:: install arduino and libraries
:InstallDependencies
    echo =====================================
    echo Download Arduino dependencies
    echo ===================================== 
    arduino-cli core install arduino:%platform_name%@%platform_version% --config-file %config_yml% || call :ReturnError Arduino installation failed.
    echo.
    echo =====================================
    echo Install project libraries
    echo =====================================
    for %%f in ("%lib_dir%\*.zip") do (
        arduino-cli lib install --config-file %config_yml% --zip-path %%f || call :ReturnError Library "%%f" cannot be installed.
    )
    goto :eof

:: build project
:Build
    for %%f in ("%1") do set "src_file=%%~nxf"
    echo =====================================
    echo Build %src_file%
    echo =====================================
    arduino-cli compile -v -b arduino:%platform_name%:%board_name% %1 --build-property compiler.c.elf.flags="-Wl,-Map,%build_dir%\%src_file%.map" --config-file %config_yml% --output-dir %build_dir% || call :ReturnError Build failed.
    goto :eof

:: create release zip archive
:Release
    echo =====================================
    echo Create delivery package
    echo =====================================
    set "release_dir=%root_dir%\release"
    set "robot_release_dir=%release_dir%\robot"
    set "controller_release_dir=%release_dir%\controller"
    set "delivery_zip=%root_dir%\gesture_controlled_robot.zip"

    rem create folders and copy files
        if exist %release_dir% rmdir /s /q %release_dir%
        mkdir %robot_release_dir% %controller_release_dir%

        if not exist %build_dir% call start_console b
        
        if exist %delivery_zip% del /f /q %delivery_zip% 

        echo Copy output files in specific folders.
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
        7z a %delivery_zip% %release_dir% >nul || call :ReturnError Archive %delivery_zip% could not be created.  
        echo Package '%delivery_zip%' has been created.    
    
    rem delete release folder
        rmdir /s /q %release_dir%
        
    goto :eof
 
:: display error message
:ReturnError %*
    echo [ ERROR ] %*
    exit 1

