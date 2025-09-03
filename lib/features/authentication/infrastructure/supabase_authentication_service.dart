import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/result.dart';
import '../../../core/services/token_storage_service.dart';
import '../../../core/services/app_logger.dart';
import '../domain/i_authentication_service.dart';
import '../domain/authentication_model.dart';
import '../domain/authentication_error.dart';
import '../domain/user_model.dart';
import 'user_dto.dart';

/// Supabase implementation of the authentication service
class SupabaseAuthenticationService implements IAuthenticationService {
  final SupabaseClient _supabase;
  final ITokenStorageService _tokenStorage;

  SupabaseAuthenticationService({
    SupabaseClient? supabase,
    ITokenStorageService? tokenStorage,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _tokenStorage = tokenStorage ?? SecureTokenStorageService();

  @override
  Future<Result<Map<String, dynamic>, AuthenticationError>> signIn(
    AuthenticationModel credentials,
  ) async {
    try {
      AppLogger.authInfo('SIGN_IN_ATTEMPT', 'Attempting sign in for ${credentials.email}');
      
      final response = await _supabase.auth.signInWithPassword(
        email: credentials.email,
        password: credentials.password,
      );

      if (response.user != null && response.session != null) {
        // Store tokens securely
        await _storeSessionTokens(response.session!);
        AppLogger.tokensStored();
        
        AppLogger.authSuccess('SIGN_IN', credentials.email);
        return Result.success({
          'id': response.user!.id,
          'email': response.user!.email,
          'created_at': response.user!.createdAt.toString(),
        });
      } else {
        AppLogger.authError('SIGN_IN', 'No user or session in response', credentials.email);
        return const Result.failure(AuthenticationError.invalidCredentials());
      }
    } on AuthException catch (e) {
      AppLogger.authError('SIGN_IN', e.message, credentials.email);
      return Result.failure(_mapAuthExceptionToError(e));
    } catch (e) {
      AppLogger.authError('SIGN_IN', e.toString(), credentials.email);
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  @override
  Future<Result<Map<String, dynamic>, AuthenticationError>> signUp(
    AuthenticationModel credentials,
  ) async {
    try {
      AppLogger.authInfo('SIGN_UP_ATTEMPT', 'Attempting sign up for ${credentials.email}');
      
      final response = await _supabase.auth.signUp(
        email: credentials.email,
        password: credentials.password,
      );
      
      if (response.user != null && response.session != null) {
        // Store tokens securely
        await _storeSessionTokens(response.session!);
        AppLogger.tokensStored();
        
        // Create user profile in public.users table
        final userProfileResult = await _createUserProfile(response.user!);
        if (userProfileResult.isFailure) {
          AppLogger.authError('USER_PROFILE_CREATION', 'Failed to create user profile', credentials.email);
          // Note: User is created in auth.users but profile creation failed
          // We could handle this differently based on requirements
        }
        
        AppLogger.authSuccess('SIGN_UP', credentials.email);
        return Result.success({
          'id': response.user!.id,
          'email': response.user!.email,
          'name': userProfileResult.isSuccess ? userProfileResult.data!.name : '',
          'initials': userProfileResult.isSuccess ? userProfileResult.data!.initials : null,
          'created_at': response.user!.createdAt.toString(),
        });
      } else {
        AppLogger.authError('SIGN_UP', 'No user or session in response', credentials.email);
        return const Result.failure(AuthenticationError.unknown('Sign up failed'));
      }
    } on AuthException catch (e) {
      AppLogger.authError('SIGN_UP', e.message, credentials.email);
      return Result.failure(_mapAuthExceptionToError(e));
    } catch (e) {
      AppLogger.authError('SIGN_UP', e.toString(), credentials.email);
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  @override
  Future<Result<void, AuthenticationError>> signOut() async {
    try {
      final currentUser = _supabase.auth.currentUser?.email;
      AppLogger.authInfo('SIGN_OUT_ATTEMPT', 'Attempting sign out${currentUser != null ? ' for $currentUser' : ''}');
      
      await _supabase.auth.signOut();
      await _tokenStorage.clearTokens();
      AppLogger.tokensCleared();
      
      AppLogger.sessionEnded(currentUser);
      return const Result.success(null);
    } on AuthException catch (e) {
      AppLogger.authError('SIGN_OUT', e.message, null);
      return Result.failure(_mapAuthExceptionToError(e));
    } catch (e) {
      AppLogger.authError('SIGN_OUT', e.toString(), null);
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
      final isAuth = user != null;
      AppLogger.authInfo('IS_AUTHENTICATED', 'User authentication status: ${isAuth ? 'AUTHENTICATED' : 'NOT_AUTHENTICATED'}${user?.email != null ? ' (${user!.email})' : ''}');
      return Result.success(isAuth);
    } catch (e) {
      AppLogger.authError('IS_AUTHENTICATED', e.toString(), null);
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  @override
  Future<Result<void, AuthenticationError>> resetPassword(String email) async {
    try {
      AppLogger.authInfo('PASSWORD_RESET_ATTEMPT', 'Attempting password reset for $email');
      await _supabase.auth.resetPasswordForEmail(email);
      AppLogger.passwordResetSent(email);
      return const Result.success(null);
    } on AuthException catch (e) {
      AppLogger.passwordResetError(email, e.message);
      return Result.failure(_mapAuthExceptionToError(e));
    } catch (e) {
      AppLogger.passwordResetError(email, e.toString());
      return const Result.failure(AuthenticationError.passwordResetFailed());
    }
  }

  @override
  Future<Result<Map<String, dynamic>, AuthenticationError>> refreshSession() async {
    try {
      final currentUser = _supabase.auth.currentUser?.email;
      AppLogger.authInfo('SESSION_REFRESH_ATTEMPT', 'Attempting session refresh${currentUser != null ? ' for $currentUser' : ''}');
      
      final response = await _supabase.auth.refreshSession();
      
      if (response.session != null && response.user != null) {
        // Store updated tokens
        await _storeSessionTokens(response.session!);
        AppLogger.tokensStored();
        AppLogger.sessionRefreshed(response.user!.email);
        
        return Result.success({
          'id': response.user!.id,
          'email': response.user!.email,
          'created_at': response.user!.createdAt.toString(),
        });
      } else {
        AppLogger.authError('SESSION_REFRESH', 'No session or user in refresh response', currentUser);
        return const Result.failure(AuthenticationError.sessionExpired());
      }
    } on AuthException catch (e) {
      AppLogger.authError('SESSION_REFRESH', e.message, null);
      return Result.failure(_mapAuthExceptionToError(e));
    } catch (e) {
      AppLogger.authError('SESSION_REFRESH', e.toString(), null);
      return const Result.failure(AuthenticationError.sessionExpired());
    }
  }

  @override
  Future<Result<void, AuthenticationError>> storeTokens(String accessToken, String refreshToken) async {
    try {
      final accessResult = await _tokenStorage.storeAccessToken(accessToken);
      final refreshResult = await _tokenStorage.storeRefreshToken(refreshToken);
      
      if (accessResult.isFailure || refreshResult.isFailure) {
        return const Result.failure(AuthenticationError.tokenStorageError());
      }
      
      return const Result.success(null);
    } catch (e) {
      return const Result.failure(AuthenticationError.tokenStorageError());
    }
  }

  @override
  Future<Result<void, AuthenticationError>> clearTokens() async {
    try {
      final result = await _tokenStorage.clearTokens();
      if (result.isFailure) {
        return const Result.failure(AuthenticationError.tokenStorageError());
      }
      return const Result.success(null);
    } catch (e) {
      return const Result.failure(AuthenticationError.tokenStorageError());
    }
  }

  /// Helper method to store session tokens
  Future<void> _storeSessionTokens(Session session) async {
    if (session.accessToken.isNotEmpty && session.refreshToken != null) {
      await _tokenStorage.storeAccessToken(session.accessToken);
      await _tokenStorage.storeRefreshToken(session.refreshToken!);
    }
  }

  /// Helper method to create user profile in public.users table
  Future<Result<UserModel, AuthenticationError>> _createUserProfile(User authUser) async {
    try {
      // Extract name from email (part before @)
      final emailName = authUser.email?.split('@').first ?? '';
      final displayName = emailName.isNotEmpty ? emailName : 'User';
      
      // Generate initials from display name
      final initials = _generateInitials(displayName);
      
      final userDto = UserDto(
        id: authUser.id,
        email: authUser.email ?? '',
        name: displayName,
        initials: initials,
        createdAt: DateTime.tryParse(authUser.createdAt.toString()),
      );

      final response = await _supabase
          .from('users')
          .insert(userDto.toJson())
          .select()
          .single();

      final createdUserDto = UserDto.fromJson(response);
      return Result.success(createdUserDto.toDomain());
    } catch (e) {
      AppLogger.authError('USER_PROFILE_CREATION', e.toString(), authUser.email);
      return const Result.failure(AuthenticationError.networkError());
    }
  }

  /// Helper method to generate initials from a name
  String _generateInitials(String name) {
    if (name.isEmpty) return '';
    
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    
    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    } else {
      return (words.first.substring(0, 1) + words.last.substring(0, 1)).toUpperCase();
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
      case 'Unable to validate email address: invalid format':
        return const AuthenticationError.invalidEmail();
      case 'For security purposes, you can only request this after 60 seconds.':
        return const AuthenticationError.passwordResetFailed();
      default:
        if (e.message.contains('email')) {
          return const AuthenticationError.invalidEmail();
        }
        if (e.message.toLowerCase().contains('session')) {
          return const AuthenticationError.sessionExpired();
        }
        return AuthenticationError.unknown(e.message);
    }
  }
}
