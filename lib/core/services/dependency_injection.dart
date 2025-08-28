import 'package:get_it/get_it.dart';
import '../../features/authentication/domain/i_authentication_service.dart';
import '../../features/authentication/infrastructure/supabase_authentication_service.dart';

/// Global service locator instance
final GetIt getIt = GetIt.instance;

/// Setup dependency injection
Future<void> setupDependencies() async {
  // Authentication services
  getIt.registerLazySingleton<IAuthenticationService>(
    () => SupabaseAuthenticationService(),
  );
}

/// Get dependency from service locator
T getdep<T extends Object>() {
  return getIt<T>();
}
