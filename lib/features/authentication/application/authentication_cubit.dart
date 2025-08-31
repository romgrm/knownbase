import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/get_dep.dart';
import '../../../core/services/session_management_service.dart';
import '../../../core/services/app_logger.dart';
import '../domain/i_authentication_service.dart';
import '../../../core/utils/data_state.dart';
import 'authentication_state.dart';

/// Cubit for managing authentication state and operations
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final IAuthenticationService _authService;
  final ISessionManagementService _sessionService;
  StreamSubscription<AuthState>? _authStateSubscription;

  AuthenticationCubit({
    IAuthenticationService? service,
    ISessionManagementService? sessionService,
  })  : _authService = service ?? getdep<IAuthenticationService>(),
        _sessionService = sessionService ?? getdep<ISessionManagementService>(),
        super(AuthenticationState.initial());

  /// Initialize the cubit and check authentication status
  Future<void> initialize() async {
    emit(
      state.copyWith(
      isAuthenticatedState: const DataState.loading(),
    ));

    try {
      // Initialize session management first
      await _sessionService.initializeSession();
      
      // Listen to auth state changes
      _authStateSubscription?.cancel();
      _authStateSubscription = _sessionService.authStateChanges.listen(
        (authState) {
          _handleAuthStateChange(authState);
        },
      );

      final result = await _authService.isAuthenticated();
      if (result.isSuccess) {
        final isAuth = result.data!;
        emit(state.copyWith(
          isAuthenticatedState: DataState.success(isAuth),
        ));

        if (isAuth) {
          await _getCurrentUser();
        }
      } else {
        emit(state.copyWith(
          isAuthenticatedState: DataState.error(result.error?.message),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isAuthenticatedState: const DataState.error('Failed to check authentication status'),
      ));
    }
  }

  /// Update email in credentials
  void updateEmail(String email) {
    final updatedCredentials = state.credentials.copyWith(email: email);
    emit(state.copyWith(credentials: updatedCredentials));
  }

  /// Update password in credentials
  void updatePassword(String password) {
    final updatedCredentials = state.credentials.copyWith(password: password);
    emit(state.copyWith(credentials: updatedCredentials));
  }

  /// Toggle between sign in and sign up modes
  void toggleMode() {
    emit(state.copyWith(isSignInMode: !state.isSignInMode));
  }

  /// Sign in with current credentials
  Future<void> signIn() async {
    if (!state.areCredentialsValid) {
      emit(state.copyWith(
        signInState: const DataState.error('Please enter valid credentials'),
      ));
      return;
    }

    emit(state.copyWith(
      signInState: const DataState.loading(),
    ));

    try {
      final result = await _authService.signIn(state.credentials);
      if (result.isSuccess) {
        emit(state.copyWith(
          signInState: DataState.success(result.data!),
          isAuthenticatedState: const DataState.success(true),
        ));
        await _getCurrentUser();
      } else {
        emit(state.copyWith(
          signInState: DataState.error(result.error?.message),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        signInState: const DataState.error('Failed to sign in'),
      ));
    }
  }

  /// Sign up with current credentials
  Future<void> signUp() async {
    if (!state.areCredentialsValid) {
      emit(state.copyWith(
        signUpState: const DataState.error('Please enter valid credentials'),
      ));
      return;
    }

    emit(state.copyWith(
      signUpState: const DataState.loading(),
    ));

    try {
      final result = await _authService.signUp(state.credentials);
      if (result.isSuccess) {
        emit(state.copyWith(
          signUpState: DataState.success(result.data!),
          isAuthenticatedState: const DataState.success(true),
        ));
        await _getCurrentUser();
      } else {
        emit(state.copyWith(
          signUpState: DataState.error(result.error?.message),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        signUpState: const DataState.error('Failed to sign up'),
      ));
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    emit(state.copyWith(
      signOutState: const DataState.loading(),
    ));

    try {
      final result = await _authService.signOut();
      if (result.isSuccess) {
        emit(state.copyWith(
          signOutState: const DataState.success(null),
          isAuthenticatedState: const DataState.success(false),
          currentUserState: const DataState.idle(),
        ));
      } else {
        emit(state.copyWith(
          signOutState: DataState.error(result.error?.message),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        signOutState: const DataState.error('Failed to sign out'),
      ));
    }
  }

  /// Get current user information
  Future<void> _getCurrentUser() async {
    emit(state.copyWith(
      currentUserState: const DataState.loading(),
    ));

    try {
      final result = await _authService.getCurrentUser();
      if (result.isSuccess) {
        emit(state.copyWith(
          currentUserState: DataState.success(result.data!),
        ));
      } else {
        emit(state.copyWith(
          currentUserState: DataState.error(result.error?.message),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        currentUserState: const DataState.error('Failed to get current user'),
      ));
    }
  }

  /// Retry sign in operation
  Future<void> retrySignIn() async {
    await signIn();
  }

  /// Retry sign up operation
  Future<void> retrySignUp() async {
    await signUp();
  }

  /// Retry getting current user
  Future<void> retryGetCurrentUser() async {
    await _getCurrentUser();
  }

  /// Clear sign in state
  void clearSignInState() {
    emit(state.copyWith(
      signInState: const DataState.idle(),
    ));
  }

  /// Clear sign up state
  void clearSignUpState() {
    emit(state.copyWith(
      signUpState: const DataState.idle(),
    ));
  }

  /// Reset password for given email
  Future<void> resetPassword(String email) async {
    if (email.isEmpty || !_isValidEmail(email)) {
      emit(state.copyWith(
        passwordResetState: const DataState.error('Please enter a valid email address'),
      ));
      return;
    }

    emit(state.copyWith(
      passwordResetState: const DataState.loading(),
    ));

    try {
      final result = await _authService.resetPassword(email);
      if (result.isSuccess) {
        emit(state.copyWith(
          passwordResetState: const DataState.success(null),
        ));
      } else {
        emit(state.copyWith(
          passwordResetState: DataState.error(result.error?.message),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        passwordResetState: const DataState.error('Failed to send password reset email'),
      ));
    }
  }

  /// Refresh current session
  Future<void> refreshSession() async {
    emit(state.copyWith(
      sessionRefreshState: const DataState.loading(),
    ));

    try {
      final result = await _authService.refreshSession();
      if (result.isSuccess) {
        emit(state.copyWith(
          sessionRefreshState: DataState.success(result.data!),
          currentUserState: DataState.success(result.data!),
          isAuthenticatedState: const DataState.success(true),
        ));
      } else {
        emit(state.copyWith(
          sessionRefreshState: DataState.error(result.error?.message),
          isAuthenticatedState: const DataState.success(false),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        sessionRefreshState: const DataState.error('Failed to refresh session'),
        isAuthenticatedState: const DataState.success(false),
      ));
    }
  }

  /// Clear password reset state
  void clearPasswordResetState() {
    emit(state.copyWith(
      passwordResetState: const DataState.idle(),
    ));
  }

  /// Clear session refresh state
  void clearSessionRefreshState() {
    emit(state.copyWith(
      sessionRefreshState: const DataState.idle(),
    ));
  }

  /// Retry password reset operation
  Future<void> retryPasswordReset(String email) async {
    await resetPassword(email);
  }

  /// Retry session refresh operation
  Future<void> retrySessionRefresh() async {
    await refreshSession();
  }

  /// Handle auth state changes
  void _handleAuthStateChange(AuthState authState) {
    final userEmail = authState.session?.user.email;
    
    switch (authState.event) {
      case AuthChangeEvent.signedIn:
        AppLogger.sessionStarted(userEmail);
        emit(state.copyWith(
          isAuthenticatedState: const DataState.success(true),
        ));
        _getCurrentUser();
        break;
      case AuthChangeEvent.signedOut:
        AppLogger.sessionEnded(userEmail);
        emit(state.copyWith(
          isAuthenticatedState: const DataState.success(false),
          currentUserState: const DataState.idle(),
          signInState: const DataState.idle(),
          signUpState: const DataState.idle(),
        ));
        break;
      case AuthChangeEvent.tokenRefreshed:
        AppLogger.sessionRefreshed(userEmail);
        break;
      default:
        break;
    }
  }

  /// Helper method to validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
