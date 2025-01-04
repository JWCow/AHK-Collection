# Quick Launch Menu Documentation

## Overview
The Quick Launch Menu provides a customizable, modern interface for accessing system information and launching applications. It features a draggable window, system monitoring, and customizable shortcuts.

## Features

### System Information Display
- CPU Usage
- RAM Usage
- Battery Status
- Updates in real-time

### Quick Actions
- Sound Mixer
- Settings
- Notepad
- Browser
- File Explorer
- Terminal

### System Controls
- Lock PC
- Sleep Mode

## Hotkeys

- **Double-tap Left/Right Shift**: Open/Close menu
- **Escape**: Close menu
- **Click and Drag**: Move menu window
- **Click Outside**: Close menu

## Customization

### Adding New Applications
To add a new application shortcut:

1. Locate the `AddMenuButton` section in the script
2. Add a new button using the format:
```autohotkey
AddMenuButton("🔊 App Name", "executable.exe", y)
y += 35
```

### Modifying Appearance
The menu's appearance can be customized by modifying these variables:
```autohotkey
CustomMenuGui.BackColor := "202020"  ; Background color
CustomMenuGui.SetFont("s10", "Segoe UI")  ; Font settings
```

### Window Position
- The menu remembers its last position
- Position is saved in `menu_settings.ini`
- Default position is center screen

## Technical Details

### System Information Collection
- CPU: Uses WMI queries
- RAM: Uses GlobalMemoryStatusEx
- Battery: Uses WMI for battery status

### Window Management
- Uses `-Caption` for borderless window
- Custom title bar implementation
- Click-through protection
- Position memory using INI file

## Troubleshooting

### Common Issues
1. Menu not appearing
   - Check if another instance is running
   - Verify hotkey conflicts

2. System info not updating
   - Check WMI service
   - Verify admin privileges

3. Position not saving
   - Check write permissions
   - Verify INI file path

### Error Messages
- "This value of type 'String' has no property named 'Hwnd'"
  - Solution: Ensure GUI is created before accessing properties

## Performance Considerations
- Lightweight implementation
- Minimal resource usage
- Efficient window handling
- Smart update intervals

## Dependencies
- AutoHotkey v2.0+
- Windows 10/11
- Administrative privileges for some features 