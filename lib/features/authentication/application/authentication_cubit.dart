import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/get_dep.dart';
import '../domain/i_authentication_service.dart';
import '../../../core/utils/data_state.dart';
import 'authentication_state.dart';

/// Cubit for managing authentication state and operations
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final IAuthenticationService _service;

  AuthenticationCubit({
    IAuthenticationService? service,
  })  : _service = service ?? getdep<IAuthenticationService>(),
        super(AuthenticationState.initial());

  /// Initialize the cubit and check authentication status
  Future<void> initialize() async {
    emit(state.copyWith(
      isAuthenticatedState: const DataState.loading(),
    ));

    try {
      final result = await _service.isAuthenticated();
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
      // Mock authentication - always successful for demo purposes
      // TODO: Replace with actual authentication service call
      // await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // // Simulate successful authentication
      // final mockUser = {
      //   'id': 'mock-user-id',
      //   'email': state.credentials.email,
      //   'created_at': DateTime.now().toIso8601String(),
      // };
      
      // emit(state.copyWith(
      //   signInState: DataState.success(mockUser),
      //   isAuthenticatedState: const DataState.success(true),
      //   currentUserState: DataState.success(mockUser),
      // ));
      
      // Uncomment below for real authentication
      final result = await _service.signIn(state.credentials);
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
      final result = await _service.signUp(state.credentials);
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
      final result = await _service.signOut();
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
      final result = await _service.getCurrentUser();
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
}
