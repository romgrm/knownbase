import '../../../core/utils/result.dart';
import 'authentication_model.dart';
import 'authentication_error.dart';

/// Interface for authentication operations
abstract class IAuthenticationService {
  /// Signs in a user with email and password
  /// 
  /// Returns [Result.success] with user data on successful authentication.
  /// Returns [Result.failure] with [AuthenticationError] if authentication fails.
  Future<Result<Map<String, dynamic>, AuthenticationError>> signIn(
    AuthenticationModel credentials,
  );

  /// Signs up a new user with email and password
  /// 
  /// Returns [Result.success] with user data on successful registration.
  /// Returns [Result.failure] with [AuthenticationError] if registration fails.
  Future<Result<Map<String, dynamic>, AuthenticationError>> signUp(
    AuthenticationModel credentials,
  );

  /// Signs out the current user
  /// 
  /// Returns [Result.success] on successful sign out.
  /// Returns [Result.failure] with [AuthenticationError] if sign out fails.
  Future<Result<void, AuthenticationError>> signOut();

  /// Gets the current authenticated user
  /// 
  /// Returns [Result.success] with user data if authenticated.
  /// Returns [Result.failure] with [AuthenticationError.userNotFound] if not authenticated.
  Future<Result<Map<String, dynamic>, AuthenticationError>> getCurrentUser();

  /// Checks if a user is currently authenticated
  /// 
  /// Returns [Result.success] with true if authenticated, false otherwise.
  /// Returns [Result.failure] with [AuthenticationError] if check fails.
  Future<Result<bool, AuthenticationError>> isAuthenticated();
}
