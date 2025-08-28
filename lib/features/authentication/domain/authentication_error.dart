/// Authentication error types
sealed class AuthenticationError {
  const AuthenticationError._();

  /// Invalid email format
  const factory AuthenticationError.invalidEmail() = _InvalidEmail;

  /// Invalid password format
  const factory AuthenticationError.invalidPassword() = _InvalidPassword;

  /// Invalid credentials
  const factory AuthenticationError.invalidCredentials() = _InvalidCredentials;

  /// Network error
  const factory AuthenticationError.networkError() = _NetworkError;

  /// User not found
  const factory AuthenticationError.userNotFound() = _UserNotFound;

  /// User already exists
  const factory AuthenticationError.userAlreadyExists() = _UserAlreadyExists;

  /// Unknown error
  const factory AuthenticationError.unknown(String? message) = _Unknown;

  /// Get error message for display
  String get message => switch (this) {
    _InvalidEmail() => 'Please enter a valid email address',
    _InvalidPassword() => 'Password must be at least 6 characters',
    _InvalidCredentials() => 'Invalid email or password',
    _NetworkError() => 'Network error. Please check your connection',
    _UserNotFound() => 'User not found',
    _UserAlreadyExists() => 'User already exists with this email',
    _Unknown() => 'An unknown error occurred',
  };
}

class _InvalidEmail extends AuthenticationError {
  const _InvalidEmail() : super._();
}

class _InvalidPassword extends AuthenticationError {
  const _InvalidPassword() : super._();
}

class _InvalidCredentials extends AuthenticationError {
  const _InvalidCredentials() : super._();
}

class _NetworkError extends AuthenticationError {
  const _NetworkError() : super._();
}

class _UserNotFound extends AuthenticationError {
  const _UserNotFound() : super._();
}

class _UserAlreadyExists extends AuthenticationError {
  const _UserAlreadyExists() : super._();
}

class _Unknown extends AuthenticationError {
  final String? _message;
  const _Unknown(this._message) : super._();
  
  @override
  String get message => _message ?? 'An unknown error occurred';
}
