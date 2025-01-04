# AHK-Collection

A collection of useful AutoHotkey v2 scripts for Windows automation and productivity enhancement.

## Requirements

- Windows 10/11
- [AutoHotkey v2.0](https://www.autohotkey.com/) or later
- For GIPHY Picker: A modern web browser (Chrome, Firefox, or Edge)

## Scripts Overview

### Quick Launch Menu (`individual_scripts/quick_launch_menu.ahk`)
A customizable quick launch menu that provides easy access to system information and commonly used applications.

- **Hotkey**: Double-tap Left or Right Shift
- **Features**:
  - System information display (CPU, RAM, Battery)
  - Quick access to common applications
  - Draggable window with position memory
  - Customizable application shortcuts
  - Clean, modern UI with hover effects

### Volume Controls (`individual_scripts/volume_controls.ahk`)
Enhanced volume control using mouse wheel combinations.

- **Hotkeys**:
  - `Win + Shift + Mouse Wheel Up`: Volume Up
  - `Win + Shift + Mouse Wheel Down`: Volume Down
  - `Win + Shift + Middle Mouse Button`: Toggle Mute

### Mouse Hold (`individual_scripts/mouse_hold.ahk`)
Utility for holding down the left mouse button without physical input.

- **Hotkeys**:
  - `Ctrl + Alt + Shift + \``: Start holding left mouse button
  - `Left Mouse Button`: Release hold
  - `Escape`: Emergency stop

### GIPHY Picker (`individual_scripts/giphy_picker.ahk`)
A convenient GIPHY browser and picker interface.

- **Hotkey**: `Win + C`
- **Features**:
  - Quick access to GIPHY
  - Window position memory
  - Keyboard navigation
  - Copy GIF with `Ctrl + Enter`
  - Minimize with `Escape`

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/JWCow/AHK-Collection.git
   ```

2. Choose your preferred method:
   - Run individual scripts from the `individual_scripts` folder
   - Run the combined script from the `main` folder

3. To run scripts at startup:
   - Press `Win + R`
   - Type `shell:startup`
   - Create shortcuts to your desired scripts in this folder

## Configuration

- Each script can be modified to change hotkeys or add functionality
- The Quick Launch Menu can be customized by editing the application shortcuts
- The GIPHY Picker's window size can be adjusted in the script variables

## Documentation

Detailed documentation for each script can be found in the `docs` folder:
- [Quick Launch Menu Documentation](docs/quick_launch_menu.md)
- [GIPHY Picker Documentation](docs/giphy_picker.md)
- [Volume Controls Documentation](docs/volume_controls.md)
- [Mouse Hold Documentation](docs/mouse_hold.md)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- AutoHotkey v2 documentation and community
- Contributors and users who provide feedback and suggestions 