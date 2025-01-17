# Changelog

## [Unreleased]

### Changed
- Improved Quick Launch Menu layout and styling:
  - Standardized section headers (size 10, normal weight, white)
  - Implemented three-column layout for AHK Scripts with compact buttons (90x25)
  - Adjusted Quick Actions to two columns with larger buttons (135x30)
  - Fixed padding and spacing for visual consistency
- Removed mouse holding functionality from main script:
  - Moved to dedicated `mouse_hold.ahk` in individual scripts
  - Cleaned up main script by removing global Holding variable
  - Simplified Escape handler
- Removed global Escape key handler:
  - Eliminated conflicts with other applications' Escape key usage
  - Quick Launch Menu now toggles exclusively with backtick key
  - GIPHY Picker continues to toggle with Win+C

## [1.1.1] - 2024-01-09

### Changed
- Enhanced AutoHotkey installation checks with registry and directory verification
- Improved installation feedback and error messages

## [1.1.0] - 2024-01-09

### Changed
- Replaced double Shift hotkey with double backtick (`) for showing Quick Launch Menu
- Fixed potential error with CustomMenuGui.Hwnd property access
- Improved menu activation reliability

## [1.0.0] - Initial Release

### Added
- Quick Launch Menu with system information display
- Custom hotkeys for volume control and mouse actions
- GIPHY picker integration
- System monitoring (CPU, RAM, Battery)
- Quick access to common applications and AHK scripts 