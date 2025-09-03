/// Model representing a project member relationship
class ProjectMemberModel {
  const ProjectMemberModel({
    this.id = '',
    this.projectId = '',
    this.userId = '',
    this.role = 'member',
    this.joinedAt,
  });

  final String id;
  final String projectId;
  final String userId;
  final String role;
  final DateTime? joinedAt;

  /// Create a copy of this model with updated values
  ProjectMemberModel copyWith({
    String? id,
    String? projectId,
    String? userId,
    String? role,
    DateTime? joinedAt,
  }) {
    return ProjectMemberModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  /// Check if the model is valid
  bool get isValid => 
      id.isNotEmpty && 
      projectId.isNotEmpty && 
      userId.isNotEmpty && 
      role.isNotEmpty;

  /// Check if member is an owner/admin
  bool get isOwner => role == 'owner' || role == 'admin';

  /// Check if member is a regular member
  bool get isMember => role == 'member';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectMemberModel &&
        other.id == id &&
        other.projectId == projectId &&
        other.userId == userId &&
        other.role == role &&
        other.joinedAt == joinedAt;
  }

  @override
  int get hashCode => Object.hash(id, projectId, userId, role, joinedAt);

  @override
  String toString() => 'ProjectMemberModel(id: $id, projectId: $projectId, userId: $userId, role: $role)';
}