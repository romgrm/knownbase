import '../domain/project_model.dart';
import 'project_member_dto.dart';

/// Data Transfer Object for Project data from/to Supabase
class ProjectDto {
  const ProjectDto({
    this.id,
    this.name = '',
    this.slug = '',
    this.createdBy = '',
    this.createdAt,
    this.members = const [],
  });

  final String? id;
  final String name;
  final String slug;
  final String createdBy;
  final DateTime? createdAt;
  final List<ProjectMemberDto> members;

  /// Create ProjectDto from JSON response
  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    List<ProjectMemberDto> membersList = [];
    if (json['project_members'] is List) {
      membersList = (json['project_members'] as List)
          .map((memberJson) => ProjectMemberDto.fromJson(memberJson as Map<String, dynamic>))
          .toList();
    }

    return ProjectDto(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      members: membersList,
    );
  }

  /// Create ProjectDto from domain model
  factory ProjectDto.fromDomain(ProjectModel project) {
    return ProjectDto(
      id: project.id.isEmpty ? null : project.id,
      name: project.name,
      slug: project.slug.isEmpty ? project.generateSlug() : project.slug,
      createdBy: project.createdBy,
      createdAt: project.createdAt,
      members: project.members.map((member) => ProjectMemberDto.fromDomain(member)).toList(),
    );
  }

  /// Convert to JSON for Supabase operations
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'slug': slug.isEmpty ? _generateSlugFromName(name) : slug,
      'created_by': createdBy,
    };

    if (id != null && id!.isNotEmpty) {
      json['id'] = id;
    }

    if (createdAt != null) {
      json['created_at'] = createdAt!.toIso8601String();
    }

    return json;
  }

  /// Convert to domain model
  ProjectModel toDomain() {
    return ProjectModel(
      id: id ?? '',
      name: name,
      slug: slug,
      createdBy: createdBy,
      createdAt: createdAt,
      members: members.map((member) => member.toDomain()).toList(),
    );
  }

  /// Helper method to generate slug from name
  String _generateSlugFromName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}