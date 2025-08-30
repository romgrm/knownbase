# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Running the Application
```bash
flutter run
```

### Dependencies
```bash
flutter pub get
```

### Code Analysis and Linting
```bash
flutter analyze
```

### Testing
```bash
flutter test
```

## Architecture Overview

This is a Flutter application built with **Clean Architecture** principles and uses **BLoC/Cubit** for state management. The app integrates with **Supabase** for authentication and follows strict architectural patterns.

### Core Structure
```
lib/
├── core/                           # Shared utilities and configuration
│   ├── constants/                  # App-wide constants (KSizes, KFonts)
│   ├── services/                   # Core services (Supabase, DI)
│   ├── theme/                      # Theme system (light/dark themes)
│   └── utils/                      # Utility classes (DataState, Result)
├── features/                       # Feature-based modules
│   └── authentication/             # Example: Authentication feature
│       ├── application/            # State management (Cubit, State)
│       ├── domain/                 # Business logic and interfaces
│       ├── infrastructure/         # External services and data sources
│       └── presentation/           # UI components and screens
└── shared/                        # Reusable UI components
    ├── buttons/
    └── input_fields/
```

### Architecture Patterns

**Clean Architecture**: Each feature follows a layered approach:
- **Domain**: Contains business entities, interfaces, and error types. Uses Result<T, E> for error handling
- **Application**: Contains Cubit classes for state management with DataState wrapper for async operations
- **Infrastructure**: Concrete implementations of domain interfaces, DTOs with JSON serialization
- **Presentation**: UI screens and widgets using BlocProvider and proper state consumption

**State Management**: Uses BLoC pattern with Cubit. All async operations use DataState<T> wrapper for loading/error/success states.

**Error Handling**: Custom Result<T, E> type for functional error handling throughout the application.

**Dependency Injection**: Uses GetIt for service location with `getdep<T>()` helper function.

## Naming Conventions

### Files (snake_case)
- Models: `*_model.dart`
- Interfaces: `i_*_service.dart` 
- DTOs: `*_dto.dart`
- Cubits: `*_cubit.dart`
- States: `*_state.dart`
- Screens: `*_screen.dart`
- Widgets: `*_widget.dart`
- Constants: `k_*.dart`

### Classes (PascalCase)
- Models: `*Model`
- Interfaces: `I*Service`
- DTOs: `*Dto`
- Cubits: `*Cubit`
- States: `*State`
- Screens: `*Screen`
- Constants: `K*`

## Typography and Styling

**Font System**: Uses Google Urbanist font family exclusively:
- Available weights: 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)
- Always use `KFonts` constants for typography
- Font files located in `assets/fonts/`

**Layout System**: Use `KSizes` constants for all measurements:
- Margins/padding: `KSize.margin4x`, `KSize.margin8x`
- Font sizes: `KSize.fontSizeS/M/L`
- Border radius: `KSize.radiusDefault`
- Icon sizes: `KSize.iconS/M/L`
- Component dimensions: `KSize.buttonHeight`

**Theme System**: Supports light and dark themes via `theme_provider.dart`.

## Code Quality Rules

### Immutability
- Use Dart 3.4+ native features (data class, sealed class, records) instead of Freezed unless specific features are needed
- All models must be immutable with empty constructors and default values
- State classes use private constructors with factory methods

### State Management
- Cubit constructors accept services as parameters with GetIt fallbacks
- Use DataState<T> wrapper for async operations
- Provide helper getters in state classes (isLoading, hasError, etc.)
- Handle all UI states (loading, error, success) in presentation layer

### Error Handling
- Use Result<T, E> type for operations that can fail
- Map infrastructure errors to domain errors
- Provide user-friendly error messages with retry mechanisms

### Testing
- Test files mirror source structure
- Unit tests for business logic, widget tests for UI
- Mock all external dependencies
- Test all state transitions and error cases

## Key Dependencies

- `flutter_bloc`: State management
- `supabase_flutter`: Backend authentication
- `get_it`: Dependency injection
- `form_validator`: Form validation
- `flutter_lints`: Code analysis

## Supabase Configuration

Configure Supabase credentials in `lib/core/services/supabase_config.dart` with your project URL and anon key.