# GIPHY Picker Documentation

## Overview
The GIPHY Picker provides a convenient interface for browsing and selecting GIFs directly from your desktop. It uses a browser-based approach for optimal performance and compatibility.

## Features

### Window Management
- Toggleable window
- Position memory
- Multi-monitor support
- Minimizable interface

### Browser Integration
- Uses default system browser
- Fallback browser detection
- Lightweight browser instance
- Optimized for performance

### Navigation
- Keyboard shortcuts
- Mouse controls
- Quick copy functionality
- Instant minimize

## Hotkeys

- **Win + C**: Toggle GIPHY window
- **Up/Down**: Scroll through GIFs
- **Tab**: Navigate elements
- **Ctrl + Enter**: Copy selected GIF
- **Escape**: Minimize window

## Configuration

### Window Size
Modify these variables to change window dimensions:
```autohotkey
global width := 400
global height := 600
```

### Browser Settings
The script automatically detects and uses your default browser, with fallbacks to:
1. Google Chrome
2. Mozilla Firefox
3. Microsoft Edge

### Window Position
- Automatically centers on active monitor
- Saves position between sessions
- Restores last used position

## Technical Details

### Browser Detection
```autohotkey
try {
    browserPath := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice", "ProgId")
    browserCmd := RegRead("HKEY_CLASSES_ROOT\" . browserPath . "\shell\open\command")
}
```

### Browser Launch Parameters
- Runs in app mode
- Disabled extensions
- Disabled sync
- Custom user data directory
- Optimized for GIF browsing

### Window Position Management
- Uses INI file for persistence
- Handles multi-monitor setups
- Calculates optimal positioning

## Troubleshooting

### Common Issues
1. Window not appearing
   - Check browser installation
   - Verify file permissions
   - Check HTML file existence

2. Browser not launching
   - Verify browser paths
   - Check registry access
   - Confirm browser installation

3. Position not saving
   - Check INI file permissions
   - Verify write access
   - Check file path validity

### Required Files
- `giphy_picker.html`
- `giphy_settings.ini` (created automatically)
- Default browser installation

## Performance Considerations
- Preloads browser instance
- Minimal memory footprint
- Efficient window handling
- Smart resource management

## Dependencies
- AutoHotkey v2.0+
- Modern web browser
- Internet connection
- Windows 10/11

## Customization
To modify the GIPHY interface:
1. Edit the HTML file
2. Adjust window parameters
3. Customize browser flags
4. Modify keyboard shortcuts 