# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**shiharainu** is a Flutter application for event payment management, particularly for drinking parties and corporate events. The app allows organizers to easily manage payments, calculate proportional splits, and confirm payments with gamification elements.

### Application Purpose
- Event payment management with automatic proportional billing calculation
- Real-time payment status tracking for organizers
- External payment app integration (PayPay, LINE Pay, Rakuten Pay)
- Gamification features with badges and rankings
- Secondary event attendance confirmation

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

### Target Architecture
- **Frontend**: Flutter (multi-platform: iOS, Android, Web)
- **Backend**: Firebase or AWS Amplify
- **Payment Integration**: PayPay, LINE Pay, Rakuten Pay APIs
- **Notifications**: Firebase Cloud Messaging (FCM)
- **Real-time Communication**: Firebase Realtime Database or Firestore
- **Authentication**: Two-factor authentication
- **Data Export**: CSV/Excel export functionality

### Current State
- **Single-file architecture** with entry point at `lib/main.dart`
- **Standard Flutter counter app** using Material Design (to be replaced)
- **Stateful widget pattern** for UI state management (will evolve to state management solution)
- **Multi-platform support** configured for web, iOS, and Android

### Planned Application Screens

#### Organizer (幹事) Screens
1. **Event Creation Screen** - Create new events with QR/URL sharing
2. **Management Dashboard** - Real-time payment status overview
3. **Proportional Pattern Settings** - Configure custom billing patterns
4. **Secondary Event Confirmation** - Manage attendance for follow-up events
5. **Export Screen** - CSV/Excel export functionality

#### Participant (参加者) Screens
1. **User Registration Screen** - Profile setup via URL/QR code access
2. **Payment Amount Confirmation** - View calculated proportional amount
3. **External Payment Integration** - Redirect to payment apps
4. **Payment Completion Confirmation** - Confirm payment status
5. **Secondary Event Participation** - Confirm attendance for follow-up events
6. **Rankings and Badges** - Gamification elements display

### Key Features to Implement
- **Proportional Billing Algorithm**: Automatic calculation based on role, age, gender, drinking status
- **Real-time Payment Tracking**: Live updates for organizers
- **External Payment Integration**: Seamless transitions to payment apps
- **Gamification System**: Speed awards, sponsor badges, rankings
- **Guest Mode**: Payment without registration
- **Automated Reminders**: Payment deadline notifications

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

### Required Dependencies for Target Application
```yaml
dependencies:
  # State Management
  provider: ^6.0.0  # or riverpod, bloc
  
  # Firebase Integration
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0
  cloud_firestore: ^4.0.0
  firebase_messaging: ^14.0.0
  
  # Payment Integration
  url_launcher: ^6.0.0
  
  # QR Code
  qr_flutter: ^4.0.0
  mobile_scanner: ^3.0.0
  
  # Export Functionality
  csv: ^5.0.0
  excel: ^2.0.0
  
  # UI Components
  flutter_svg: ^2.0.0
  cached_network_image: ^3.0.0
```

### Recommended Architecture Pattern
- **Feature-based folder structure**:
  ```
  lib/
    features/
      auth/
      event_creation/
      payment/
      dashboard/
      gamification/
    shared/
      widgets/
      services/
      models/
      utils/
  ```
- **Layered architecture**: Presentation → Business Logic → Data Layer
- **State management**: Provider or Riverpod for scalability
- **Service locator pattern**: GetIt for dependency injection
- **Repository pattern**: Abstract data layer for Firebase integration

### Security and Performance Considerations
- **Encryption**: Personal information (especially account numbers) must be encrypted
- **Real-time updates**: Support for up to 100 concurrent users
- **Payment security**: No card information stored in app, external API integration only
- **Two-factor authentication**: Required for security compliance

### Development Guidelines - Effective Dart

Follow Effective Dart guidelines (https://dart.dev/effective-dart):

#### Style
- Use `lowerCamelCase` for identifiers
- Use `UpperCamelCase` for types
- Use `lowercase_with_underscores` for library names
- Prefer `final` over `var` when possible

#### Documentation
- Use `///` for public APIs
- Write clear, concise documentation
- Include examples for complex functions

#### Usage
- Use `const` constructors when possible
- Prefer `??` over conditional expressions for null coalescing
- Use collection literals over constructors
- Avoid using `dynamic` unless necessary

#### Design
- Prefer composition over inheritance
- Make classes immutable when possible
- Use named constructors for clarity
- Follow the single responsibility principle

### Non-Functional Requirements
- **Target Users**: Business professionals aged 20-50
- **Concurrent Users**: Up to 100 simultaneous users
- **UI/UX**: Intuitive, simple design with minimal tap requirements
- **Performance**: Real-time payment status updates
- **Accessibility**: Support for various screen sizes and accessibility features

### Future Expansion Plans
- AI-powered optimal proportional pattern recommendations
- Support for various event types beyond drinking parties
- Advanced analytics and reporting features