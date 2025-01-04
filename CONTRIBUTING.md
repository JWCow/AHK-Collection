# Contributing to AHK-Collection

Thank you for your interest in contributing to AHK-Collection! This document provides guidelines and best practices for contributions.

## Code Style Guidelines

### AutoHotkey v2 Specific
- Use explicit variable declarations
- Include descriptive comments for functions and complex logic
- Use meaningful variable and function names
- Follow v2 syntax conventions (`:=` for assignments, etc.)
- Add error handling where appropriate

### Script Structure
1. Start with required directives:
   ```autohotkey
   #Requires AutoHotkey v2.0
   #SingleInstance Force
   SetWorkingDir(A_ScriptDir)
   ```

2. Follow with global variables:
   ```autohotkey
   global MyVariable := ""
   ```

3. Group related functions together

4. Add comments for hotkey sections:
   ```autohotkey
   ; === Hotkey Definitions ===
   #c:: MyFunction()
   ```

### Documentation
- Include a header comment in each script describing its purpose
- Document all hotkeys and their functions
- Explain any complex logic or workarounds
- Update README.md when adding new features

## Testing Guidelines

Before submitting a pull request:

1. Test all hotkeys and functions
2. Verify compatibility with Windows 10/11
3. Check for conflicts with existing hotkeys
4. Test memory usage and performance
5. Verify clean startup and shutdown

## Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Update documentation
6. Submit pull request

### Commit Messages
- Use clear, descriptive commit messages
- Start with a verb (Add, Fix, Update, etc.)
- Reference issues if applicable

Example:
```
Add volume control hotkeys
- Implement mouse wheel volume control
- Add mute toggle functionality
- Update documentation
```

## Feature Requests and Bug Reports

### Bug Reports
Include:
- AutoHotkey version
- Windows version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Any error messages

### Feature Requests
Include:
- Clear description of the feature
- Use case and benefits
- Potential implementation approach

## Script Categories

When adding new scripts, they should fall into one of these categories:
1. System Controls
2. Window Management
3. Text Manipulation
4. Application Launchers
5. Media Controls
6. Productivity Tools

## Development Environment Setup

1. Install AutoHotkey v2
2. Setup a code editor (VS Code recommended)
3. Install helpful extensions:
   - AutoHotkey v2 Language Support
   - AutoHotkey Debug

## Need Help?

- Check existing issues and documentation
- Join the AutoHotkey community
- Contact repository maintainers

Thank you for contributing! 