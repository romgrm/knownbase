import 'project_member_model.dart';

/// Model representing a project
class ProjectModel {
  const ProjectModel({
    this.id = '',
    this.name = '',
    this.slug = '',
    this.createdBy = '',
    this.description = '',
    this.cardsCount = 0,
    this.isCurrent = false,
    this.userRole = 'Member',
    this.createdAt,
    this.lastUpdated,
    this.members = const [],
  });

  final String id;
  final String name;
  final String slug;
  final String createdBy;
  final String description;
  final int cardsCount;
  final bool isCurrent;
  final String userRole;
  final DateTime? createdAt;
  final DateTime? lastUpdated;
  final List<ProjectMemberModel> members;

  /// Create a copy of this model with updated values
  ProjectModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? createdBy,
    String? description,
    int? cardsCount,
    bool? isCurrent,
    String? userRole,
    DateTime? createdAt,
    DateTime? lastUpdated,
    List<ProjectMemberModel>? members,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      cardsCount: cardsCount ?? this.cardsCount,
      isCurrent: isCurrent ?? this.isCurrent,
      userRole: userRole ?? this.userRole,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      members: members ?? this.members,
    );
  }

  /// Check if the model is valid
  bool get isValid => id.isNotEmpty && name.isNotEmpty && createdBy.isNotEmpty;

  /// Check if user is the owner/creator
  bool isOwnedBy(String userId) => createdBy == userId;

  /// Generate slug from name if not provided
  String generateSlug() {
    if (slug.isNotEmpty) return slug;
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Get member by user ID
  ProjectMemberModel? getMember(String userId) {
    try {
      return members.firstWhere((member) => member.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is a member of this project
  bool hasMember(String userId) => getMember(userId) != null;

  /// Get all member IDs
  List<String> get memberIds => members.map((m) => m.userId).toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectModel &&
        other.id == id &&
        other.name == name &&
        other.slug == slug &&
        other.createdBy == createdBy &&
        other.description == description &&
        other.cardsCount == cardsCount &&
        other.isCurrent == isCurrent &&
        other.userRole == userRole &&
        other.createdAt == createdAt &&
        other.lastUpdated == lastUpdated &&
        other.members == members;
  }

  @override
  int get hashCode => Object.hash(
    id, 
    name, 
    slug, 
    createdBy, 
    description, 
    cardsCount, 
    isCurrent, 
    userRole, 
    createdAt, 
    lastUpdated, 
    members,
  );

  @override
  String toString() => 'ProjectModel(id: $id, name: $name, slug: $slug, createdBy: $createdBy)';
}