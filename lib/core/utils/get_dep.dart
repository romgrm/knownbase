import 'package:get_it/get_it.dart';

/// Get dependency from GetIt service locator
/// This is a fallback for dependencies that might not be available
T getdep<T extends Object>() {
  return GetIt.instance<T>();
}
