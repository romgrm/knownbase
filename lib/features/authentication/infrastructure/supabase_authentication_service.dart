import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/result.dart';
import '../domain/i_authentication_service.dart';
import '../domain/authentication_model.dart';
import '../domain/authentication_error.dart';

/// Supabase implementation of the authentication service
class SupabaseAuthenticationService implements IAuthenticationService {
  final SupabaseClient _supabase;

  SupabaseAuthenticationService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<Result<Map<String, dynamic>, AuthenticationError>> signIn(
    AuthenticationModel credentials,
  ) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: credentials.email,
        password: credentials.password,
      );

      if (response.user != null) {
        return Result.success({
          'id': response.user!.id,
          'email': response.user!.email,
          'created_at': response.user!.createdAt.toString(),
        });
      } else {
        return const Result.failure(AuthenticationError.invalidCredentials());
      }
    } on AuthException catch (e) {
      return Result.failure(_mapAuthExceptionToError(e));
    } catch (e) {
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  @override
  Future<Result<Map<String, dynamic>, AuthenticationError>> signUp(
    AuthenticationModel credentials,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: credentials.email,
        password: credentials.password,
      );

      if (response.user != null) {
        return Result.success({
          'id': response.user!.id,
          'email': response.user!.email,
          'created_at': response.user!.createdAt.toString(),
        });
      } else {
        return const Result.failure(AuthenticationError.unknown('Sign up failed'));
      }
    } on AuthException catch (e) {
      return Result.failure(_mapAuthExceptionToError(e));
    } catch (e) {
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  @override
  Future<Result<void, AuthenticationError>> signOut() async {
    try {
      await _supabase.auth.signOut();
      return const Result.success(null);
    } on AuthException catch (e) {
      return Result.failure(_mapAuthExceptionToError(e));
    } catch (e) {
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  @override
  Future<Result<Map<String, dynamic>, AuthenticationError>> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        return Result.success({
          'id': user.id,
          'email': user.email,
          'created_at': user.createdAt.toString(),
        });
      } else {
        return const Result.failure(AuthenticationError.userNotFound());
      }
    } catch (e) {
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  @override
  Future<Result<bool, AuthenticationError>> isAuthenticated() async {
    try {
      final user = _supabase.auth.currentUser;
      return Result.success(user != null);
    } catch (e) {
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  /// Maps Supabase AuthException to our domain AuthenticationError
  AuthenticationError _mapAuthExceptionToError(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return const AuthenticationError.invalidCredentials();
      case 'User already registered':
        return const AuthenticationError.userAlreadyExists();
      case 'User not found':
        return const AuthenticationError.userNotFound();
      case 'Email not confirmed':
        return const AuthenticationError.unknown('Please confirm your email address');
      case 'Password should be at least 6 characters':
        return const AuthenticationError.invalidPassword();
      default:
        if (e.message.contains('email')) {
          return const AuthenticationError.invalidEmail();
        }
        return AuthenticationError.unknown(e.message);
    }
  }
}
