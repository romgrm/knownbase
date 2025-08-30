import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/authentication/application/authentication_cubit.dart';

/// Configuration for all app-level BLoC providers
/// 
/// This class centralizes the management of all cubits/blocs that need to be
/// available across multiple screens throughout the application.
/// 
/// Usage:
/// - Add new shared cubits to the providers list
/// - Import this file in main.dart
/// - Use AppBlocProviders.providers in MultiBlocProvider
class AppBlocProviders {
  /// List of all app-level BlocProviders
  /// 
  /// Add new shared cubits here when they need to be accessible
  /// across multiple screens in the application.
  static List<BlocProvider> get providers => [
    // Authentication - Used across auth, dashboard, and potentially other screens
    BlocProvider<AuthenticationCubit>(
      create: (context) => AuthenticationCubit()..initialize(),
    ),
    
    // Future shared cubits can be added here:
    // 
    // Theme management across the app:
    // BlocProvider<ThemeCubit>(
    //   create: (context) => ThemeCubit()..loadTheme(),
    // ),
    // 
    // User preferences shared across screens:
    // BlocProvider<UserPreferencesCubit>(
    //   create: (context) => UserPreferencesCubit()..loadPreferences(),
    // ),
    // 
    // App-wide notifications:
    // BlocProvider<NotificationsCubit>(
    //   create: (context) => NotificationsCubit()..initialize(),
    // ),
    // 
    // Global search functionality:
    // BlocProvider<SearchCubit>(
    //   create: (context) => SearchCubit(),
    // ),
  ];
}