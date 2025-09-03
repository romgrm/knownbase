/// Model representing a user
class UserModel {
  const UserModel({
    this.id = '',
    this.email = '',
    this.name = '',
    this.initials,
    this.createdAt,
  });

  final String id;
  final String email;
  final String name;
  final String? initials;
  final DateTime? createdAt;

  /// Create a copy of this model with updated values
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? initials,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if the model is valid
  bool get isValid => id.isNotEmpty && email.isNotEmpty;

  /// Check if email format is valid
  bool get isEmailValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Get display name (name if available, otherwise email)
  String get displayName => name.isNotEmpty ? name : email;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.initials == initials &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, email, name, initials, createdAt);

  @override
  String toString() => 'UserModel(id: $id, email: $email, name: $name, initials: $initials)';
}