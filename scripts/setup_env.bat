@echo off

setlocal
    rem set variables
        set "scripts_dir=%~dp0"
        set "root_dir=%scripts_dir%\.."
        set "robot_src_dir=%root_dir%\src\robot"
        set "controller_src_dir=%root_dir%\src\controller"
        set "lib_dir=%root_dir%\lib"
        set "arduino_cli_path=%root_dir%\tools\arduino-cli"
        set "build_dir=%root_dir%\build"
        set "config_yml=%root_dir%\config.yml"
        set "path_7zip=%root_dir%\tools\7-zip"
        set "release_dir=%root_dir%\release"
        set "robot_release_dir=%release_dir%\robot"
        set "controller_release_dir=%release_dir%\controller"
        set "delivery_zip=%root_dir%\gesture_controlled_robot.zip"

    rem update PATH
        set "PATH=%PATH%;%arduino_cli_path%;%path_7zip%"

    rem arduino variables
        set "platform_name=avr"
        set "platform_version=1.8.6"
        set "board_name=nano"
endlocal
goto :eof