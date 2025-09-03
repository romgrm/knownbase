import 'package:get_it/get_it.dart';
import '../../features/authentication/domain/i_authentication_service.dart';
import '../../features/authentication/infrastructure/supabase_authentication_service.dart';
import '../../features/project_selection/domain/i_project_service.dart';
import '../../features/project_selection/infrastructure/supabase_project_service.dart';
import 'token_storage_service.dart';
import 'session_management_service.dart';

/// Global service locator instance
final GetIt getIt = GetIt.instance;

/// Setup dependency injection
Future<void> setupDependencies() async {
  // Token storage service
  getIt.registerLazySingleton<ITokenStorageService>(
    () => SecureTokenStorageService(),
  );

  // Session management service
  getIt.registerLazySingleton<ISessionManagementService>(
    () => SupabaseSessionManagementService(),
  );

  // Authentication service (depends on token storage)
  getIt.registerLazySingleton<IAuthenticationService>(
    () => SupabaseAuthenticationService(
      tokenStorage: getIt<ITokenStorageService>(),
    ),
  );

  // Project service
  getIt.registerLazySingleton<IProjectService>(
    () => SupabaseProjectService(),
  );
}

/// Get dependency from service locator
T getdep<T extends Object>() {
  return getIt<T>();
}
