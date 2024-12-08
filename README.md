# Gesture Controlled Robot

## Table of Content

## Description
The operation of the robot, consists in taking over the data from the accelerometer by the Arduino board of the controller according to its orientation, and this data will be transmitted to the robot through the radio transmitter module. 

The data is taken over by the radio receiver and will be sent to the Arduino board of the robot, then through the connecting wires will be sent electrical signals to the H-bridge circuit to operate the two DC motors.

## Structure
This small project is structured in several folders with specific role as following: <br>
```
.
├── .github/ 
│       ├── workflows/
│       │       ├── build.yml
│       │       ├── release.yml
│       │       └── update_arduino_cli.yml
│       └── CODEOWNERS
├── doc/ 
├── lib/ 
│       ├── MPU6050_tockn.zip
│       └── VirtualWire.zip
├── src/
│       ├── controller/
│       │       └── controller.ino
│       └── robot/
│               └── robot.ino
├── test/
├── tools/
├── .gitignore 
├── config.yml
├── README.md 
├── start_console.bat
├── update_arduino_cli.bat
└── LICENSE
````


## Build Environment
To compile and generate binary files, open `start_console.bat` file and choose specific option.


The build process can be done in silent mode (no user interaction) by openig a terminal in root folder of repository and run the following command:<br>

    start_console.bat <PARAMETER>

where the `<PARAMETER>` represents the argument for specific action:

## Binary files
This table provides an overview of the files generated during the build process using Arduino CLI.

| **File Type** | **Description**                                        |
|---------------|--------------------------------------------------------|
| `.hex`        | Compiled binary in Intel HEX format for uploading to the board. |
| `.elf`        | Executable and Linkable format file, includes debugging information.    |
| `.bin`        | Raw binary file for flashing.                         |
| `.eep`        | EEPROM file containing data for EEPROM memory.        |
| `.map`        | Memory map file showing detailed memory usage.        |

For more details on how to configure and use Arduino CLI, refer to the [Arduino CLI documentation](https://arduino.github.io/arduino-cli/latest/).

## Update Arduino CLI
As it's mentioned before, this tool is the heart of build process. If a new version of this tool is released in order to solve a discovered bug in the previous one, a script was developed to be easier for user to achive this goal.<br>

From root folder of this repository, open `update_arduino.cli.bat` script and enter the new version.

This process can be done in silent mode by opening a terminal in root folder and run the following command

    update_arduino.cli.bat <NEW_VERSION>
where the `<NEW_VERSION>` argument represents the new version of Arduino CLI.

## Continuous Integration
To simplify the working process, some workflows were developed as following:

- <b>Build</b><br>
    - It's automatically triggered when a Pull Request is created in order to test the new implementation.<br>

- <b>Release</b><br>
    - This worflow is triggered manually by user and he will enter the desired version for this release (e.g. 1.0).
    - A new branch that will contains the new binary files archive is created on Git 
    - The generated archive will be uploaded as artifact on this workflow in order to be downloaded by user.

- <b>Update Arduino CLI</b><br>
    - In order to keep this tool updated, a workflow was developed to do this job automaticaly.
    - This worflow is triggered manually by user that will enter the new version for Arduino CLI tool.
    - A new branch will be created on Git after this tool is installed.

These workflows can be found on Actions section on this project or by clicking on following link: https://github.com/cornelcristea/gesture-controlled-robot/actions

## Flashing software on board
Use Arduino CLI.<br>
To be done.

## Dev Container
To be done.

## Release package
At the moment it's a ZIP archive.<br>
To be created a package as Docker image and to be uploaded on GitJHub ppackages repository.

## Demo
https://youtu.be/4kE5ffBWL2M

