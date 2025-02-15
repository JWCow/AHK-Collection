# AutoHotkey Scripts Collection 🚀

<div align="center">
  <img src="IMAGES/banner.png" alt="AHK Collection Banner" width="800"/>
  
  ![AutoHotkey Version](https://img.shields.io/badge/AutoHotkey-v2.0-green.svg)
  ![Windows](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue.svg)
  ![License](https://img.shields.io/badge/License-MIT-yellow.svg)
  ![Status](https://img.shields.io/badge/Status-Active-success.svg)
  
  A powerful collection of AutoHotkey v2 scripts for Windows automation and productivity enhancement. Features GIPHY integration, system monitoring, and customizable hotkeys.
</div>

---

A collection of useful AutoHotkey v2 scripts for Windows productivity enhancement.

## Table of Contents 📑
- [Features](#features-)
  - [Windows AHK Startup Keys V2](#windows-ahk-startup-keys-v2-)
  - [Individual Scripts](#individual-scripts-)
- [Requirements](#requirements-)
- [Installation](#installation-)
  - [Quick Install (Recommended)](#quick-install-recommended-)
  - [Manual Installation](#manual-installation-)
- [Usage](#usage-)
  - [Windows AHK Startup Keys V2 Usage](#windows-ahk-startup-keys-v2-usage)
  - [Individual Scripts Usage](#individual-scripts-usage)
- [Contributing](#contributing-)
- [License](#license-)
- [Acknowledgments](#acknowledgments-)

## Features 🌟

### Windows AHK Startup Keys V2 (`Windows_AHK_Startup_Keys_v2.ahk`) 🎮
An all-in-one script with multiple productivity features:
- **GIPHY Picker** (Win + C): Quick GIF search and copy
  - *Requires `giphy_picker.html` in the same directory*
  - Customizable window size and position
  - Keyboard navigation support
- **Quick Launch Menu** (Double-tap Left/Right Shift)
  - System status monitoring (CPU, RAM, Battery)
  - Quick access to common applications
  - AHK script management
  - System controls (Lock, Sleep)
- **Mouse Hold** (Ctrl + Alt + Shift + `): Hold mouse button for drag operations
- **Volume Controls**:
  - Win + Shift + Mouse Wheel Up/Down: Volume adjustment
  - Win + Shift + Middle Mouse: Mute toggle

### Individual Scripts 📜
- **Mouse Hold** (`mouse_hold.ahk`): Hold mouse button without physical holding
- **Volume Controls** (`volume_controls.ahk`): Quick volume adjustment shortcuts

## Requirements 💻
- Windows 10/11
- AutoHotkey v2.0
- For GIPHY Picker: Modern web browser (Chrome/Edge/Firefox)
- `giphy_picker.html` file in the same directory as the main script

## Installation 🔧

### Quick Install (Recommended) 📦
1. Download the latest release ZIP file from the [releases page](../../releases)
2. Extract the ZIP file to your desired location
3. Run `autorun.bat` to:
   - Install AutoHotkey v2 if not already installed
   - Add the script to Windows startup
   - Start the script immediately
4. That's it! The script will now run automatically when you start Windows

### Manual Installation 🛠️
1. Install AutoHotkey v2.0 from [official website](https://www.autohotkey.com/)
2. Clone or download this repository
3. For GIPHY Picker functionality:
   - Ensure `giphy_picker.html` is in the same directory as `Windows_AHK_Startup_Keys_v2.ahk`
4. To add to Windows Startup (optional):
   - Double-click `install_startup.bat` to automatically add to startup
   - Or run it as administrator if the regular method fails
5. Run the desired script:
   - Use `Windows_AHK_Startup_Keys_v2.ahk` for all features
   - Or run individual scripts from the `individual_scripts` folder

## Usage 📝
### Windows AHK Startup Keys V2
- **GIPHY Picker**:
  - Press Win + C to open/close
  - Use Up/Down arrows to scroll
  - Ctrl + Enter to copy GIF
  - Escape to close
- **Quick Launch Menu**:
  - Double-tap Left or Right Shift
  - Click items to launch
  - Drag title bar to move
  - Escape to close
- **Mouse Hold**:
  - Press Ctrl + Alt + Shift + ` to start holding
  - Click to release
  - Escape for emergency stop
- **Volume Controls**:
  - Win + Shift + Mouse Wheel for volume
  - Win + Shift + Middle Mouse Button to mute

### Individual Scripts
Refer to each script's documentation in the `individual_scripts` folder.

## Contributing 🤝
Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

## License 📄
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments 🙏
- AutoHotkey community
- Contributors and users 