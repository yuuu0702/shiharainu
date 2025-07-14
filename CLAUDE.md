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

### Current Technology Stack

#### Core Framework
- **Flutter SDK**: ^3.8.1 (Multi-platform: iOS, Android, Web)
- **Dart**: Latest stable version

#### State Management & Architecture
- **flutter_riverpod**: ^2.4.9 - Reactive state management
- **hooks_riverpod**: ^2.4.9 - Riverpod integration with Flutter Hooks
- **flutter_hooks**: ^0.20.3 - React-like hooks for Flutter
- **riverpod_annotation**: ^2.3.3 - Code generation annotations
- **riverpod_generator**: ^2.3.9 - Automatic provider code generation

#### Data Models & Serialization
- **freezed**: ^2.4.6 - Immutable data classes with code generation
- **freezed_annotation**: ^2.4.1 - Freezed annotations
- **json_annotation**: ^4.8.1 - JSON serialization annotations
- **json_serializable**: ^6.7.1 - JSON serialization code generation

#### Routing & Navigation
- **go_router**: ^12.1.3 - Declarative routing solution

#### Firebase Integration
- **firebase_core**: ^2.24.2 - Firebase core functionality
- **firebase_auth**: ^4.15.3 - Authentication
- **cloud_firestore**: ^4.13.6 - NoSQL database
- **firebase_messaging**: ^14.7.10 - Push notifications

#### Payment & External Integration
- **url_launcher**: ^6.2.2 - Launch external payment apps

#### QR Code & Scanning
- **qr_flutter**: ^4.1.0 - QR code generation
- **mobile_scanner**: ^3.5.7 - QR code scanning

#### Export & File Generation
- **csv**: ^5.0.2 - CSV file generation
- **excel**: ^4.0.2 - Excel file generation

#### UI & Assets
- **flutter_svg**: ^2.0.9 - SVG rendering
- **cached_network_image**: ^3.3.0 - Image caching

#### Utilities
- **uuid**: ^4.2.1 - UUID generation
- **intl**: ^0.18.1 - Internationalization

#### Development Tools
- **build_runner**: ^2.4.7 - Code generation runner
- **custom_lint**: ^0.5.7 - Custom linting rules
- **riverpod_lint**: ^2.3.7 - Riverpod-specific linting
- **flutter_lints**: ^5.0.0 - Flutter recommended lints

### Implemented Architecture Pattern

#### Current Folder Structure
```
lib/
  app.dart                      # Main app widget with routing
  main.dart                     # Entry point with ProviderScope
  features/
    auth/
      data/                     # Data sources, repositories
      domain/                   # Entities, use cases
      presentation/             # Pages, widgets, providers
    event_creation/
      data/
      domain/
      presentation/
    payment/
      data/
      domain/
      presentation/
    dashboard/
      data/
      domain/
      presentation/
    gamification/
      data/
      domain/
      presentation/
    secondary_event/
      data/
      domain/
      presentation/
  shared/
    constants/
      app_theme.dart           # App theme configuration
    models/
      user_model.dart          # User data model with Freezed
      event_model.dart         # Event data model with Freezed
      payment_model.dart       # Payment data model with Freezed
    routing/
      app_router.dart          # Go Router configuration
    services/                  # Shared services
    utils/                     # Utility functions
    widgets/                   # Reusable widgets
```

#### Architecture Principles
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **Feature-based organization**: Each feature is self-contained
- **State management**: Riverpod with code generation for type safety
- **Immutable data**: Freezed for all data models
- **Dependency injection**: Riverpod providers for service injection
- **Repository pattern**: Abstract data layer for Firebase integration

#### Code Generation Setup
- **build.yaml**: Configured for Freezed, JSON serialization, and Riverpod
- **Build runner commands**:
  ```bash
  # Generate code once
  flutter packages pub run build_runner build
  
  # Watch for changes and rebuild
  flutter packages pub run build_runner watch
  
  # Clean generated files
  flutter packages pub run build_runner clean
  ```

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

## Development Workflow and Git Strategy

### Branch Strategy (Git Flow)

#### Main Branches
- **main**: Production-ready code, always deployable
- **develop**: Integration branch for features, latest development changes

#### Supporting Branches
- **feature/**: Feature development branches
  - Naming: `feature/auth-implementation`, `feature/payment-integration`
  - Branch from: `develop`
  - Merge to: `develop`

- **hotfix/**: Critical bug fixes for production
  - Naming: `hotfix/payment-crash-fix`
  - Branch from: `main`
  - Merge to: `main` and `develop`

- **release/**: Release preparation branches
  - Naming: `release/v1.0.0`
  - Branch from: `develop`
  - Merge to: `main` and `develop`

#### Workflow
1. Create feature branch from `develop`
2. Develop feature with regular commits
3. Create pull request to `develop`
4. Code review and merge
5. Deploy to staging from `develop`
6. Create release branch when ready
7. Merge release to `main` for production

### Commit Message Conventions

Follow conventional commits specification for consistent commit messages:

#### Format
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

#### Types
- **feat**: New feature for the user
- **fix**: Bug fix for the user
- **docs**: Documentation changes
- **style**: Code style changes (formatting, semicolons, etc.)
- **refactor**: Code refactoring without changing functionality
- **test**: Adding or updating tests
- **chore**: Maintenance tasks, dependency updates
- **perf**: Performance improvements
- **build**: Build system or external dependencies
- **ci**: Continuous integration configuration

#### Scopes (Optional)
- **auth**: Authentication related changes
- **payment**: Payment functionality
- **dashboard**: Dashboard features
- **gamification**: Gamification features
- **ui**: User interface changes
- **api**: API related changes
- **config**: Configuration changes

#### Examples
```bash
# Feature commits
feat(auth): add user login functionality
feat(payment): integrate PayPay payment method
feat(dashboard): add real-time payment status updates

# Bug fixes
fix(auth): resolve login form validation issue
fix(payment): handle payment timeout errors
fix(ui): fix responsive layout on mobile devices

# Documentation
docs(readme): update installation instructions
docs(api): add payment API documentation

# Refactoring
refactor(auth): extract user validation logic
refactor(payment): simplify payment flow state management

# Tests
test(auth): add unit tests for login service
test(payment): add integration tests for payment flow

# Chores
chore(deps): update firebase dependencies
chore(build): configure build optimization
```

#### Breaking Changes
For breaking changes, add `!` after the type and include `BREAKING CHANGE:` in the footer:
```
feat(api)!: change user authentication flow

BREAKING CHANGE: User authentication now requires email verification
```

### Development Commands with Git Integration

#### Code Generation + Commit
```bash
# Generate code and commit
flutter packages pub run build_runner build
git add .
git commit -m "build: generate code for new models"
```

#### Feature Development Workflow
```bash
# Start new feature
git checkout develop
git pull origin develop
git checkout -b feature/payment-integration

# Regular development
git add .
git commit -m "feat(payment): add PayPay integration"
git push origin feature/payment-integration

# When feature is complete
git checkout develop
git pull origin develop
git checkout feature/payment-integration
git rebase develop
git push origin feature/payment-integration --force-with-lease
```

### Pre-commit Hooks (Optional)
Consider adding pre-commit hooks for:
- Code formatting (`dart format`)
- Linting (`flutter analyze`)
- Tests (`flutter test`)
- Code generation check