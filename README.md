# H265Repack [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![Author](https://img.shields.io/github/package-json/author/TheBluWiz/H265Repack?)](https://github.com/TheBluWiz) ![Version](https://img.shields.io/github/package-json/v/TheBluWiz/H265Repack?color=sucess)

## Description
**H265Repack** is an easy-to-use CLI video converter tool designed to repack single videos or video directories into the H.265 format, ensuring high efficiency and quality. On macOS, it leverages hardware-level H.265 encoding supported by macOS devices for optimal performance. On Linux, the script doesn't assume hardware configuration. Feel free to alter the script to support your device specifically.

## Table of Contents
- [Description](#description)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [Questions](#questions)
- [Author](#author)
- [License](#license)

## Features
- **Directory Handling**: Accepts directories as input and will recursively rebuild directory structure during transcoding process.
- **Efficient Video Repacking**: Converts videos to the H.265 format, ensuring high compression and quality.
- **Hardware Acceleration**: Utilizes macOS hardware-level H.265 encoding for faster conversion.
- **Flexible Output Options**: Supports various container formats and compression presets.
- **Automatic Color Range Detection**: Automatically detects and applies the correct color range, defaulting to full range if undetectable.
- **Easy & Lightweight**: Requires zero configuration. Ready to use at install. 

## Prerequisites
- Hardware acceleration requires a supported mac
- Installable to either macOS or Unix/Linux systems
- Sudo privilege required for installation script

## Installation
### Using Installer Script
If made executable the `install_H265Repack` script will handle installing `H265Repack` on any mac. 
- **Note**, *when downloaded from the internet, the file will no longer be executable within macOS. To make the file executable:*
```
chmod +x /path/to/install_H265Repack.sh
```
This will also install a man page with additional information for the optional arguments.
### To Linux System
I did not include an installer file for Linux due to the large array of customization options the system is known for. Simply copy the H265RepackLinux.sh script to a folder in your `$PATH` and be sure to grant it executable permission. Additionally, the man page should be installed for clarity. The file is included at `man/H265Repack.1`
### Using Homebrew
I'd love to see this script added to [Homebrew](brew.sh) someday. It will need wider adoption first, but I've already created the required .rb installer script for it once that threshold is met. Be sure to follow this posting if you find it useful, so we can add this to a proper package manager.
## Usage
This is a command-line tool. It will accept either a standard video file or a directory containing video files for `<source>`. It will then output the file(s) at the target destination including any recursive file structure. The basic syntax is as follows:
```sh
H265Repack <source> <target> <containerFormat> [crf] [preset-Compression] 
```
### Arguments
- `<source>`: Path to source video file(s).
- `<target>`: Path to save the converted video file(s).
- `<containerFormat>`: Desired output container format (e.g., mp4, mkv).
- `[crf]`: Optional. Constant Rate Factor for controlling the output quality (e.g., 18, 23)
- `[-preset]`: Optional. Preset for compression (e.g., fast, medium, slow).
### Examples
#### Basic Conversion
```sh
H265Repack input.mp4 output mkv
```
#### Custom Compression
```sh
H265Repack /videos/source /videos/target mp4 fair 5
```
It is worth noting that hardware acceleration on macOS is only available when not using optional arguments. The hardware acceleration circutry is opinionated and doesn't allow for those optional customizations. 
## Contributing
Contributions are welcome! If you have suggestions for improvements or have found bugs, please email me at <a href="mailto:thebluwiz@icloud.com?subject=H265Repack">thebluwiz@icloud.com</a>. For major changes, please open an issue first to discuss what you would like to change.
## Going Forward
- Suppress ffmpeg ouput
- Potentially add a progress bar or other animation during transcode
- May add in additional scripts for `AV1` Titles.
- include `update` instructions
- Add Support for Windows
## Acknowledgements
- Special callout to the developers at ffmpeg and all the libraries and tools that made this project possible.
## Author
This project is created and maintained by [TheBluWiz](https://github.com/TheBluWiz). If you have any questions or would like to see more of my projects, feel free to visit my [GitHub](https://github.com/TheBluWiz) or contact me at [thebluwiz@icloud.com](mailto:thebluwiz@icloud.com).
## License
This project is licensed under the GNU General Public License (GPL) v3.0. For more details, see the <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">LICENSE</a> file in the repository.
