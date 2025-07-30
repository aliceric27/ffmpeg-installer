# FFmpeg Automatic Installer

English | [中文](README.zh-TW.md)

![Language](https://img.shields.io/badge/Language-Batch-blue)
![License](https://img.shields.io/badge/License-GPL-brightgreen)

A Windows batch script that automatically downloads, installs, and configures FFmpeg on your system.

## Features

- 🚀 **Automatic Download**: Downloads the latest FFmpeg version from the official GitHub repository
- 📦 **Automatic Extraction**: No manual file extraction required
- 🔧 **Safe Environment Variable Management**: Uses PowerShell/.NET API to safely modify PATH without breaking existing environment variables
- 🛡️ **Idempotent Design**: Safe to run multiple times without duplicate path additions or issues
- 🧹 **Automatic Cleanup**: Automatically cleans up temporary files after installation
- ✅ **Installation Verification**: Automatically verifies successful installation
- 🔐 **Permission Detection**: Automatically detects administrator privileges and chooses appropriate installation method
- 📋 **Detailed Logging**: Provides clear installation progress and status messages

## System Requirements

- Windows 10/11 or Windows Server 2016+
- PowerShell 5.0+ (built-in with Windows 10/11)
- Internet connection (for downloading FFmpeg)

## Usage

### Method 1: Direct Execution (Recommended)

1. Download the `install_ffmpeg.bat` file
2. Right-click on the file
3. Select "Run as administrator" (for best installation experience)
4. Follow the on-screen instructions and wait for installation to complete
5. Reopen Command Prompt or PowerShell window

### Method 2: Command Line Execution

```cmd
# Regular user permissions (installs to user environment variables)
install_ffmpeg.bat

# Administrator permissions (installs to system environment variables, recommended)
# Run from administrator Command Prompt
install_ffmpeg.bat
```

## Installation Locations

### User Permission Installation
- **Installation Path**: `%USERPROFILE%\ffmpeg`
- **Environment Variable**: User PATH

### Administrator Permission Installation
- **Installation Path**: `C:\ffmpeg`
- **Environment Variable**: System PATH

## Verify Installation

After installation completes, open a new Command Prompt or PowerShell window and run:

```cmd
ffmpeg -version
```

If you see FFmpeg version information, the installation was successful.

## Troubleshooting

### Download Failed
- **Cause**: Network connection issues or firewall blocking
- **Solutions**:
  - Check network connection
  - Temporarily disable firewall or antivirus software
  - Use VPN or proxy server

### Insufficient Permissions
- **Symptoms**: Cannot create directories or set environment variables
- **Solution**: Run the script as administrator

### Environment Variables Not Taking Effect
- **Symptoms**: Installation complete but `ffmpeg` command not recognized
- **Solutions**:
  - Reopen Command Prompt window
  - Log out and log back into Windows account
  - Restart computer

### Extraction Failed
- **Cause**: Insufficient disk space or corrupted files
- **Solutions**:
  - Ensure sufficient disk space (recommend at least 500MB)
  - Re-run the installation script

## Manual Removal

To remove FFmpeg, follow these steps:

1. Delete installation directory:
   ```cmd
   # User installation
   rmdir /s "%USERPROFILE%\ffmpeg"
   
   # System installation
   rmdir /s "C:\ffmpeg"
   ```

2. Remove path from environment variables:
   - Open "System Properties" → "Advanced" → "Environment Variables"
   - Remove FFmpeg-related paths from the PATH variable

## Technical Details

### Download Source
- **Official Repository**: [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds)
- **Version**: master-latest-win64-gpl-shared
- **License**: GPL

### Script Features
- Uses PowerShell for HTTP downloads
- Automatically detects extracted directory structure
- **Safe Environment Variable Management**:
  - Uses `System.Environment.GetEnvironmentVariable()` to correctly read existing PATH
  - Uses `System.Environment.SetEnvironmentVariable()` to safely modify PATH
  - Avoids overwriting existing environment variables
  - Supports both User and Machine scopes
- Complete error handling mechanisms
- Idempotent design: safe to run repeatedly

### Security Guarantees
- ❌ **Does not use dangerous `setx` command**: Avoids PATH overwrite issues
- ✅ **Uses official .NET API**: Calls Windows official environment variable API through PowerShell
- ✅ **Smart duplicate detection**: Automatically detects if path already exists to avoid duplicate additions
- ✅ **Scope isolation**: Clearly distinguishes between user-level and system-level environment variables

## License

This installation script is open source software. FFmpeg itself follows GPL license terms.

## Support & Feedback

For issues or suggestions, please submit an Issue or contact the developer.

---

**Note**: Please reopen command line windows after first installation for new environment variables to take effect.