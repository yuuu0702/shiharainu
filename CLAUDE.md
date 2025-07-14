# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**shiharainu** is a Flutter application supporting web, iOS, and Android platforms. This is a standard Flutter project initialized with the default counter app template.

## Common Development Commands

### Running the Application
```bash
# Run on Chrome (web)
flutter run -d chrome

# Run on all connected devices
flutter run -d all

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices
```

### Building
```bash
# Build for web
flutter build web

# Build for Android
flutter build apk
flutter build appbundle

# Build for iOS
flutter build ios
```

### Testing and Quality
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Check for linting issues
flutter analyze

# Get dependency updates
flutter pub get
flutter pub outdated
```

## Architecture and Structure

### Current State
- **Single-file architecture** with entry point at `lib/main.dart`
- **Standard Flutter counter app** using Material Design
- **Stateful widget pattern** for UI state management (using setState)
- **Multi-platform support** configured for web, iOS, and Android

### Key Directories
- `lib/` - Main application code (currently single file)
- `test/` - Widget and unit tests
- `android/` - Android-specific configuration and build files
- `ios/` - iOS-specific configuration and Xcode project
- `web/` - Web-specific assets and configuration

### Platform Configuration
- **Android**: Uses Gradle with Kotlin DSL, package name `com.example.shiharainu`
- **iOS**: Xcode project with Swift, bundle identifier configurable
- **Web**: PWA-ready with manifest.json, blue theme (#0175C2)

## Development Workflow

### Dependencies
- **Flutter SDK**: ^3.8.1
- **Core dependency**: cupertino_icons ^1.0.8
- **Dev dependencies**: flutter_test, flutter_lints ^5.0.0

### Code Quality
- Uses `flutter_lints` package for recommended linting rules
- Analysis options configured in `analysis_options.yaml`
- Standard Flutter testing setup with widget tests

### Project Status
- **Version**: 1.0.0+1
- **Publish**: Private (publish_to: 'none')
- **Clean state**: Standard Flutter template with minimal customization

## Architecture Expansion Notes

The current single-file structure is appropriate for the starter project but can be expanded using common Flutter patterns:
- Feature-based folder structure
- Layered architecture (presentation, business, data)
- State management solutions (Provider, Riverpod, Bloc, etc.)
- Service locator or dependency injection patterns