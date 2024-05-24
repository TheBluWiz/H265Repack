# H265Repack [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Description
**H265Repack** is an easy-to-use video converter tool designed to repack videos into the H.265 format, ensuring high efficiency and quality. On macOS, it leverages hardware-level H.265 encoding supported by macOS devices for optimal performance. On Linux, the script doesn't assume hardware configuration. Feel free to alter the script to support your device specifically.

## Table of Contents
- [Description](#description)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [Tests](#tests)
- [Questions](#questions)
- [License](#license)

## Features
- **Efficient Video Repacking**: Converts videos to the H.265 format, ensuring high compression and quality.
- **Hardware Acceleration**: Utilizes macOS hardware-level H.265 encoding for faster conversion.
- **Flexible Output Options**: Supports various container formats and compression presets.
- **Automatic Color Range Detection**: Automatically detects and applies the correct color range, defaulting to full range if undetectable.

## Prerequisites
- macOS with hardware-level H.265 encoding support

## Installation
To install **H265Repack**:
```sh
1. "Download this script to a folder in your path".
2. "Run `chmod +x H265Repack.sh`."
```
## Usage
This is a command-line tool. It will accept either a standard video file or a directory containing video files for `<source>`. It will then output the file(s) at the target destination including any recursive file structure. The basic syntax is as follows:
```sh
H265Repack <source> <target> <containerFormat> [preset-Compression] [crf]
```
### Arguments
- `<source>`: Path to source video file(s).
- `<target>`: Path to save the converted video file(s).
- `<containerFormat>`: Desired output container format (e.g., mp4, mkv).
- `[-preset]`: Optional. Preset for compression (e.g., fast, medium, slow).
- `[crf]`: Optional. Constant Rate Factor for controlling the output quality (e.g., 18, 23)
### Examples
#### Basic Conversion
```sh
H265Repack input.mp4 output.mkv mkv
```
#### Custom Compression
```sh
H265Repack input.mp4 output.mkv mkv medium 23
```
## Contributing
Contributions are welcome! If you have suggestions for improvements or have found bugs, please email me at <a href="mailto:thebluwiz@icloud.com?subject=H265Repack">thebluwiz@icloud.com</a>. For major changes, please open an issue first to discuss what you would like to change.
## Going Forward
- May add in additional scripts for `AV1` Titles.
- Supress ffmpeg info
- Potentially add progress bar or other animation during transcode
## Achnowledgements
- Speacial callout to the developers at ffmpeg and all the libraries and tools that made this project possible.
- Changelog
## Changelog
### V0.1.0
Initial release with transcode functionality to h.265 format for files or video directories.
## Author
This project is created and maintained by [TheBluWiz](https://github.com/TheBluWiz). If you have any questions or would like to see more of my projects, feel free to visit my [GitHub](https://github.com/TheBluWiz) or contact me at [thebluwiz@icloud.com](mailto:thebluwiz@icloud.com).
## License
This project is licensed under the GNU General Public License (GPL) v3.0. For more details, see the <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">LICENSE</a> file in the repository.
##