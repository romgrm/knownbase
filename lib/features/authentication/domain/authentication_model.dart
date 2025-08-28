/// Model representing authentication credentials
class AuthenticationModel {
  const AuthenticationModel({
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;

  /// Create a copy of this model with updated values
  AuthenticationModel copyWith({
    String? email,
    String? password,
  }) {
    return AuthenticationModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Check if the model is valid
  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  /// Check if email format is valid
  bool get isEmailValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Check if password meets minimum requirements
  bool get isPasswordValid => password.length >= 6;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthenticationModel &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  @override
  String toString() => 'AuthenticationModel(email: $email, password: $password)';
}
