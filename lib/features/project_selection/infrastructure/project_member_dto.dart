import '../domain/project_member_model.dart';

/// Data Transfer Object for ProjectMember data from/to Supabase
class ProjectMemberDto {
  const ProjectMemberDto({
    this.id,
    this.projectId = '',
    this.userId = '',
    this.role = 'member',
    this.joinedAt,
  });

  final String? id;
  final String projectId;
  final String userId;
  final String role;
  final DateTime? joinedAt;

  /// Create ProjectMemberDto from JSON response
  factory ProjectMemberDto.fromJson(Map<String, dynamic> json) {
    return ProjectMemberDto(
      id: json['id']?.toString(),
      projectId: json['project_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'member',
      joinedAt: json['joined_at'] != null 
          ? DateTime.tryParse(json['joined_at'].toString())
          : null,
    );
  }

  /// Create ProjectMemberDto from domain model
  factory ProjectMemberDto.fromDomain(ProjectMemberModel member) {
    return ProjectMemberDto(
      id: member.id.isEmpty ? null : member.id,
      projectId: member.projectId,
      userId: member.userId,
      role: member.role,
      joinedAt: member.joinedAt,
    );
  }

  /// Convert to JSON for Supabase operations
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'project_id': projectId,
      'user_id': userId,
      'role': role,
    };

    if (id != null && id!.isNotEmpty) {
      json['id'] = id;
    }

    if (joinedAt != null) {
      json['joined_at'] = joinedAt!.toIso8601String();
    }

    return json;
  }

  /// Convert to domain model
  ProjectMemberModel toDomain() {
    return ProjectMemberModel(
      id: id ?? '',
      projectId: projectId,
      userId: userId,
      role: role,
      joinedAt: joinedAt,
    );
  }
}