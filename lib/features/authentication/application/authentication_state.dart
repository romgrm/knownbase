import '../../../core/utils/data_state.dart';
import '../domain/authentication_model.dart';

/// State for authentication operations
class AuthenticationState {
  const AuthenticationState({
    required this.signInState,
    required this.signUpState,
    required this.signOutState,
    required this.currentUserState,
    required this.isAuthenticatedState,
    required this.passwordResetState,
    required this.sessionRefreshState,
    required this.credentials,
    this.isSignInMode = true,
  });

  final DataState<Map<String, dynamic>> signInState;
  final DataState<Map<String, dynamic>> signUpState;
  final DataState<void> signOutState;
  final DataState<Map<String, dynamic>> currentUserState;
  final DataState<bool> isAuthenticatedState;
  final DataState<void> passwordResetState;
  final DataState<Map<String, dynamic>> sessionRefreshState;
  final AuthenticationModel credentials;
  final bool isSignInMode;

  // Helper getters for derived states
  bool get isSignInLoading => signInState.isLoading;
  bool get hasSignInError => signInState.hasError;
  bool get isSignInSuccess => signInState.isSuccess;
  bool get isSignInIdle => signInState.isIdle;

  bool get isSignUpLoading => signUpState.isLoading;
  bool get hasSignUpError => signUpState.hasError;
  bool get isSignUpSuccess => signUpState.isSuccess;
  bool get isSignUpIdle => signUpState.isIdle;

  bool get isSignOutLoading => signOutState.isLoading;
  bool get hasSignOutError => signOutState.hasError;
  bool get isSignOutSuccess => signOutState.isSuccess;
  bool get isSignOutIdle => signOutState.isIdle;

  bool get isCurrentUserLoading => currentUserState.isLoading;
  bool get hasCurrentUserError => currentUserState.hasError;
  bool get isCurrentUserSuccess => currentUserState.isSuccess;
  bool get isCurrentUserIdle => currentUserState.isIdle;

  bool get isCheckingAuthentication => isAuthenticatedState.isLoading;
  bool get hasAuthenticationCheckError => isAuthenticatedState.hasError;
  bool get isAuthenticationCheckSuccess => isAuthenticatedState.isSuccess;
  bool get isAuthenticationCheckIdle => isAuthenticatedState.isIdle;

  bool get isPasswordResetLoading => passwordResetState.isLoading;
  bool get hasPasswordResetError => passwordResetState.hasError;
  bool get isPasswordResetSuccess => passwordResetState.isSuccess;
  bool get isPasswordResetIdle => passwordResetState.isIdle;

  bool get isSessionRefreshLoading => sessionRefreshState.isLoading;
  bool get hasSessionRefreshError => sessionRefreshState.hasError;
  bool get isSessionRefreshSuccess => sessionRefreshState.isSuccess;
  bool get isSessionRefreshIdle => sessionRefreshState.isIdle;

  /// Get current user data if available
  Map<String, dynamic>? get currentUser => currentUserState.data;

  /// Check if user is authenticated
  bool get isAuthenticated => isAuthenticatedState.data ?? false;

  /// Check if credentials are valid
  bool get areCredentialsValid => credentials.isValid && credentials.isEmailValid && credentials.isPasswordValid;

  /// Create a copy of this state with updated values
  AuthenticationState copyWith({
    DataState<Map<String, dynamic>>? signInState,
    DataState<Map<String, dynamic>>? signUpState,
    DataState<void>? signOutState,
    DataState<Map<String, dynamic>>? currentUserState,
    DataState<bool>? isAuthenticatedState,
    DataState<void>? passwordResetState,
    DataState<Map<String, dynamic>>? sessionRefreshState,
    AuthenticationModel? credentials,
    bool? isSignInMode,
  }) {
    return AuthenticationState(
      signInState: signInState ?? this.signInState,
      signUpState: signUpState ?? this.signUpState,
      signOutState: signOutState ?? this.signOutState,
      currentUserState: currentUserState ?? this.currentUserState,
      isAuthenticatedState: isAuthenticatedState ?? this.isAuthenticatedState,
      passwordResetState: passwordResetState ?? this.passwordResetState,
      sessionRefreshState: sessionRefreshState ?? this.sessionRefreshState,
      credentials: credentials ?? this.credentials,
      isSignInMode: isSignInMode ?? this.isSignInMode,
    );
  }

  /// Initial state
  factory AuthenticationState.initial() => const AuthenticationState(
    signInState: DataState.idle(),
    signUpState: DataState.idle(),
    signOutState: DataState.idle(),
    currentUserState: DataState.idle(),
    isAuthenticatedState: DataState.idle(),
    passwordResetState: DataState.idle(),
    sessionRefreshState: DataState.idle(),
    credentials: AuthenticationModel(),
    isSignInMode: true,
  );
}
