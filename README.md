# Gesture Controlled Robot

![Nightly](https://github.com/cornelcristea/gesture-controlled-robot/actions/workflows/nightly.yml/badge.svg)
![License](https://img.shields.io/github/license/cornelcristea/gesture-controlled-robot)
![Stars](https://img.shields.io/github/stars/cornelcristea/gesture-controlled-robot)


## <b>Table of Content</b>
1.  [Description](#1-description)
2.  [Project structure](#2-project-structure)
3.  [Build environment](#3-build-environment)
4.  [Software Test](#4-software-test)
5.  [Flashing board](#5-flashing-board)
6.  [Update Arduino CLI](#6-update-arduino-cli)
7.  [Continuous Integration](#7-continuous-integration)
8.  [Dev Container](#8-dev-container)
9.  [Release package](#9-release-package)
10. [Demo](#10-demo)

## <b>1. Description</b>
The operation of the robot, consists in taking over the data from the accelerometer by the Arduino board of the controller according to its orientation, and this data will be transmitted to the robot through the radio transmitter module. 

The data is taken over by the radio receiver and will be sent to the Arduino board of the robot, then through the connecting wires will be sent electrical signals to the H-bridge circuit to operate the two DC motors.


## <b>2. Project structure</b>
This small project is structured in several folders and files as following: <br>
```
.
├── .github/ 
│       ├── workflows/
│       │       ├── build.yml
│       │       ├── nightly.yml
│       │       ├── release.yml
│       │       └── update_arduino_cli.yml
│       └── CODEOWNERS
├── doc/
│       ├── circuit_controler_tx.jpg
│       ├── circuit_robot_rx.jpg
│       ├── demo.mp4
│       └── proiect.pdf
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
│       ├── 7-zip/
│       │       ├── 7z.exe  
│       │       └── License.txt
│       └── arduino-cli/
│               ├── arduino-cli.exe
│               └── License.txt 
├── .gitignore             
├── binary_files.zip        
├── config.yml              
├── README.md               
├── start_console.bat       
├── update_arduino_cli.bat  
└── LICENSE                
```

[MPU6050_tockn](https://github.com/tockn/MPU6050_tockn) and 
[VirtualWire](https://github.com/lsongdev/VirtualWire) open-source libraries are used in this project to send information from controller to robot and  to calculate gyroscope position.

[Arduino CLI](https://arduino.github.io/arduino-cli) tool is used for the build process and it represents the most important tool from this project.

The archive that contains binary files generated during release process is created using [7-Zip](https://7-zip.org/download.html) tool.


## <b>3. Build environment</b>
The main program used for mainly action on this project is `start_console.bat` script that can be found on root folder.
This program can be executed in silent mode (no user interaction) by openig a terminal in root folder of repository and run the following command:<br>

    start_console.bat <PARAMETER>

where the `<PARAMETER>` represents the argument for specific action.

The log files for each action can be found on <b>logs</b> folder which is automatically created.

### Download arduino platform

    start_console.bat a

After this step, the <b>arduino15</b> new foder is created on root folder that contains all necessary arduino dependencies used during build process.<br>
By default, the <b>arduino:avr@1.8.6</b> platform is installed.

### Install project libraries

    start_console.bat l

The libraries mentioned before are installed in specific folder from arduino15 folder to be visible and integrated during software compilation

### Compilation

    start_console.bat b

After compilation is done, a <b>build</b> folder is created and tis will contains binary files.<br>

### Binary files
This table provides an overview of the binary files generated during the build process.

| **File Type** | **Description**                                        |
|---------------|--------------------------------------------------------|
| `.hex`        | Compiled binary in Intel HEX format for uploading to the board. |
| `.elf`        | Executable and Linkable format file, includes debugging information.    |
| `.bin`        | Raw binary file for flashing.                         |
| `.eep`        | EEPROM file containing data for EEPROM memory.        |
| `.map`        | Memory map file showing detailed memory usage.        |

For more details on how to configure and use Arduino CLI, refer to the [Arduino CLI documentation](https://arduino.github.io/arduino-cli/latest/).

## <b>4. Software test</b>
To be done.

## <b>5. Flashing board</b>
Use Arduino CLI.<br>
To be done.

## <b>6. Update Arduino CLI</b>
As it's mentioned before, this tool is the heart of build process. If a new version of this tool is released in order to solve a discovered bug in the previous one, a script was developed to be easier for user to achive this goal.<br>

From root folder of this repository, open `update_arduino_cli.bat` script and enter the new version.

This process can be done in silent mode by opening a terminal in root folder and run the following command

    update_arduino_cli.bat <NEW_VERSION>
where the `<NEW_VERSION>` argument represents the new version of Arduino CLI.

## <b>5. Continuous Integration</b>
To simplify the working process, some workflows were developed as following:

- <b>Build</b><br>
    - It's automatically triggered when a Pull Request is created in order to test the new implementation.<br>

- <b>Nightly</b><br>
    - A build job automatically triggered on monday, wednesday and friday at midnight that compile all files to check consistency.<br>

- <b>Release</b><br>
    - This worflow is triggered manually by user and he will enter the desired version for this release (e.g. 1.0).
    - A new branch that will contains the new binary files archive is created on Git 
    - The generated archive will be uploaded as artifact on this workflow in order to be downloaded by user.

- <b>Update Arduino CLI</b><br>
    - In order to keep this tool updated, a workflow was developed to do this job automaticaly.
    - This worflow is triggered manually by user that will enter the new version for Arduino CLI tool.
    - A new branch will be created on Git after this tool is installed.

The mentioned workflows can be found on [Actions](https://github.com/cornelcristea/gesture-controlled-robot/actions) section from this project.

## <b>8. Dev Container</b>
To be done.

## <b>9. Release package</b>
At the moment it's a ZIP archive.<br>
To be created a package as Docker image and to be uploaded on GitJHub ppackages repository.

## <b>10. Demo</b>

[![Watch the video](https://img.youtube.com/vi/4kE5ffBWL2M/0.jpg)](https://www.youtube.com/watch?v=4kE5ffBWL2M)


