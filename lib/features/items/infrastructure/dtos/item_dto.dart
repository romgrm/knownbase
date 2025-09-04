import '../../domain/domain_models/item_model.dart';
import '../../domain/domain_models/item_content_model.dart';
import '../../domain/domain_models/item_type_enum.dart';
import '../../domain/domain_models/item_status_enum.dart';
import '../../domain/domain_models/item_priority_enum.dart';

/// Data Transfer Object for Item data from/to Supabase
class ItemDto {
  const ItemDto({
    this.id,
    this.projectId = '',
    this.itemTypeId = '',
    this.createdBy = '',
    this.title = '',
    this.description = '',
    this.solution = '',
    this.content = const {},
    this.itemType = 'tip',
    this.status = 'active',
    this.priority = 0,
    this.tags = const [],
    this.authorId = '',
    this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.viewCount = 0,
    this.voteScore = 0,
  });

  final String? id;
  final String projectId;
  final String itemTypeId;
  final String createdBy;
  final String title;
  final String description;
  final String solution;
  final Map<String, dynamic> content;
  final String itemType;
  final String status;
  final int priority;
  final List<String> tags;
  final String authorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final int viewCount;
  final int voteScore;

  /// Create ItemDto from JSON response
  factory ItemDto.fromJson(Map<String, dynamic> json) {
    return ItemDto(
      id: json['id']?.toString(),
      projectId: json['project_id']?.toString() ?? '',
      itemTypeId: json['item_type_id']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      solution: json['solution']?.toString() ?? '',
      content: json['content'] as Map<String, dynamic>? ?? {},
      itemType: json['item_type']?.toString() ?? 'tip',
      status: json['status']?.toString() ?? 'active',
      priority: json['priority'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      authorId: json['author_id']?.toString() ?? json['created_by']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      resolvedAt: json['resolved_at'] != null 
          ? DateTime.tryParse(json['resolved_at'].toString())
          : null,
      viewCount: json['view_count'] as int? ?? 0,
      voteScore: json['vote_score'] as int? ?? 0,
    );
  }

  /// Create ItemDto from domain model
  factory ItemDto.fromDomain(ItemModel item) {
    return ItemDto(
      id: item.id.isEmpty ? null : item.id,
      projectId: item.projectId,
      itemTypeId: '', // Legacy field, mapped from enum
      createdBy: item.authorId,
      title: item.title,
      description: item.description,
      solution: '', // Legacy field, content now in JSONB
      content: item.content.toJson(),
      itemType: item.itemType.value,
      status: item.status.value,
      priority: item.priority.value,
      tags: item.tags,
      authorId: item.authorId,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      resolvedAt: item.resolvedAt,
      viewCount: item.viewCount,
      voteScore: item.voteScore,
    );
  }

  /// Convert to JSON for Supabase operations
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'project_id': projectId,
      'title': title,
      'description': description.isNotEmpty ? description : null,
      'content': content,
      'item_type': itemType,
      'status': status,
      'priority': priority,
      'tags': tags.isNotEmpty ? tags : null,
      'author_id': authorId.isNotEmpty ? authorId : createdBy,
    };

    if (id != null && id!.isNotEmpty) {
      json['id'] = id;
    }

    if (createdAt != null) {
      json['created_at'] = createdAt!.toIso8601String();
    }

    if (updatedAt != null) {
      json['updated_at'] = updatedAt!.toIso8601String();
    }

    if (resolvedAt != null) {
      json['resolved_at'] = resolvedAt!.toIso8601String();
    }

    // Legacy fields for backward compatibility
    if (itemTypeId.isNotEmpty) {
      json['item_type_id'] = itemTypeId;
    }
    if (solution.isNotEmpty) {
      json['solution'] = solution;
    }
    if (createdBy.isNotEmpty) {
      json['created_by'] = createdBy;
    }

    return json;
  }

  /// Convert to domain model
  ItemModel toDomain() {
    try {
      return ItemModel(
        id: id ?? '',
        projectId: projectId,
        title: title,
        description: description,
        content: ItemContentModel.fromJson(content),
        itemType: ItemTypeEnum.fromValue(itemType),
        status: ItemStatusEnum.fromValue(status),
        priority: ItemPriorityEnum.fromValue(priority),
        tags: tags,
        authorId: authorId.isNotEmpty ? authorId : createdBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
        resolvedAt: resolvedAt,
        viewCount: viewCount,
        voteScore: voteScore,
      );
    } catch (e) {
      // Fallback for legacy data
      return ItemModel(
        id: id ?? '',
        projectId: projectId,
        title: title,
        description: description,
        content: ItemContentModel(
          blocks: solution.isNotEmpty 
            ? [ContentBlock.text(solution)]
            : description.isNotEmpty 
              ? [ContentBlock.text(description)]
              : [],
        ),
        itemType: ItemTypeEnum.tip,
        status: ItemStatusEnum.active,
        priority: ItemPriorityEnum.low,
        tags: tags,
        authorId: authorId.isNotEmpty ? authorId : createdBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
        resolvedAt: resolvedAt,
        viewCount: viewCount,
        voteScore: voteScore,
      );
    }
  }

  /// Create DTO for insert operation
  Map<String, dynamic> toInsertJson() {
    return {
      'project_id': projectId,
      'title': title,
      'description': description.isNotEmpty ? description : null,
      'content': content,
      'item_type': itemType,
      'status': status,
      'priority': priority,
      'tags': tags.isNotEmpty ? tags : null,
      'author_id': authorId.isNotEmpty ? authorId : createdBy,
    };
  }
}