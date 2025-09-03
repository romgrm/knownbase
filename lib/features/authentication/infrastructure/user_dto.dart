import '../domain/user_model.dart';

/// Data Transfer Object for User data from/to Supabase
class UserDto {
  const UserDto({
    this.id,
    this.email = '',
    this.name = '',
    this.initials,
    this.createdAt,
  });

  final String? id;
  final String email;
  final String name;
  final String? initials;
  final DateTime? createdAt;

  /// Create UserDto from JSON response
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id']?.toString(),
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      initials: json['initials']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Create UserDto from domain model
  factory UserDto.fromDomain(UserModel user) {
    return UserDto(
      id: user.id.isEmpty ? null : user.id,
      email: user.email,
      name: user.name,
      initials: user.initials,
      createdAt: user.createdAt,
    );
  }

  /// Convert to JSON for Supabase operations
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
    };

    if (id != null && id!.isNotEmpty) {
      json['id'] = id;
    }

    if (initials != null) {
      json['initials'] = initials;
    }

    if (createdAt != null) {
      json['created_at'] = createdAt!.toIso8601String();
    }

    return json;
  }

  /// Convert to domain model
  UserModel toDomain() {
    return UserModel(
      id: id ?? '',
      email: email,
      name: name,
      initials: initials,
      createdAt: createdAt,
    );
  }
}