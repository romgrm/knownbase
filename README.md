# KnownBase

A Flutter application with Supabase authentication following clean architecture principles.

## Features

- **Authentication System**: Sign in, sign up, and sign out functionality
- **Clean Architecture**: Follows domain-driven design with proper separation of concerns
- **State Management**: Uses BLoC pattern with Cubit for state management
- **Supabase Integration**: Backend authentication powered by Supabase
- **Responsive UI**: Modern Material Design 3 interface with consistent sizing
- **Custom Typography**: Uses Google Urbanist font family for modern, clean aesthetics
- **Theme System**: Light and dark themes with consistent color palette

## Architecture

```
lib/
├── core/
│   ├── constants/
│   │   ├── k_sizes.dart          # Consistent sizing constants
│   │   └── k_fonts.dart          # Typography constants (Urbanist font)
│   ├── services/
│   ├── theme/
│   │   ├── app_theme.dart        # Light and dark theme definitions
│   │   └── theme_provider.dart   # Theme switching functionality
│   └── utils/                    # Utility classes (DataState, Result, etc.)
├── features/
│   └── authentication/
│       ├── domain/               # Business logic and entities
│       ├── application/          # Use cases and state management
│       ├── presentation/         # UI components and screens
│       └── infrastructure/       # External services and data sources
└── shared/
    └── buttons/
        ├── action_button.dart    # Generic neumorphic button component
        └── README.md             # Button component documentation
```

## Typography

The app uses the **Google Urbanist** font family for a modern, clean aesthetic:

- **Font Family**: Urbanist
- **Weights Available**: 
  - Regular (400)
  - Medium (500) 
  - SemiBold (600)
  - Bold (700)

### Usage

```dart
import 'package:knownbase/core/constants/k_fonts.dart';

// Use predefined text styles
Text('Hello World', style: KFonts.headlineLarge);
Text('Body text', style: KFonts.bodyMedium);

// Or use font constants directly
Text('Custom text', style: TextStyle(
  fontFamily: KFonts.fontFamily,
  fontSize: KFonts.lg,
  fontWeight: KFonts.semiBold,
));
```

## Dependencies

- **flutter_bloc**: State management
- **supabase_flutter**: Supabase client for Flutter
- **get_it**: Dependency injection
- **form_validator**: Form validation utilities

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd knownbase
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Update `lib/core/services/supabase_config.dart` with your Supabase credentials
   - Set `_supabaseUrl` and `_supabaseAnonKey`

4. **Run the application**
   ```bash
   flutter run
   ```

## Development Guidelines

- **Domain Layer**: Immutable models, clear interfaces, custom Result type for error handling
- **State Management**: Use BLoC/Cubit for complex state, keep state immutable
- **UI Components**: Follow Material Design 3 guidelines, use KSize and KFonts constants
- **Typography**: Always use KFonts constants for consistent font usage
- **Error Handling**: Use the custom Result type for functional error handling
- **Testing**: Write unit tests for business logic and widget tests for UI components

## Font Integration

The Urbanist font is automatically included in the app bundle and configured in the theme system. The font files are located in `assets/fonts/` and registered in `pubspec.yaml`.

### Font Files
- `Urbanist-Regular.ttf` - Weight 400
- `Urbanist-Medium.ttf` - Weight 500  
- `Urbanist-SemiBold.ttf` - Weight 600
- `Urbanist-Bold.ttf` - Weight 700

## Contributing

1. Follow the established architecture patterns
2. Use the provided constants (KSize, KFonts) for consistency
3. Ensure all text uses the Urbanist font family
4. Test on both light and dark themes
5. Follow Flutter best practices and linting rules
