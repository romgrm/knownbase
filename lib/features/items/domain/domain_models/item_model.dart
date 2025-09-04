import 'item_content_model.dart';
import 'item_type_enum.dart';
import 'item_status_enum.dart';
import 'item_priority_enum.dart';

/// Model representing a knowledge item with rich content
class ItemModel {
  const ItemModel({
    this.id = '',
    this.projectId = '',
    this.title = '',
    this.description = '',
    this.content = const ItemContentModel(),
    this.itemType = ItemTypeEnum.tip,
    this.status = ItemStatusEnum.active,
    this.priority = ItemPriorityEnum.low,
    this.tags = const [],
    this.authorId = '',
    this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.viewCount = 0,
    this.voteScore = 0,
  });

  final String id;
  final String projectId;
  final String title;
  final String description;
  final ItemContentModel content;
  final ItemTypeEnum itemType;
  final ItemStatusEnum status;
  final ItemPriorityEnum priority;
  final List<String> tags;
  final String authorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final int viewCount;
  final int voteScore;

  /// Create a copy of this model with updated values
  ItemModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    ItemContentModel? content,
    ItemTypeEnum? itemType,
    ItemStatusEnum? status,
    ItemPriorityEnum? priority,
    List<String>? tags,
    String? authorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    int? viewCount,
    int? voteScore,
  }) {
    return ItemModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      itemType: itemType ?? this.itemType,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      viewCount: viewCount ?? this.viewCount,
      voteScore: voteScore ?? this.voteScore,
    );
  }

  /// Check if the model is valid
  bool get isValid => 
      id.isNotEmpty && 
      projectId.isNotEmpty && 
      authorId.isNotEmpty && 
      title.isNotEmpty;

  /// Status checks
  bool get isResolved => status == ItemStatusEnum.resolved;
  bool get isArchived => status == ItemStatusEnum.archived;
  bool get isActive => status == ItemStatusEnum.active;

  /// Priority checks
  bool get hasHighPriority => priority.isHighPriority;
  bool get isCritical => priority.isCritical;

  /// Content checks
  bool get hasDescription => description.isNotEmpty;
  bool get hasContent => content.blocks.isNotEmpty;
  bool get hasTags => tags.isNotEmpty;

  /// Check if item has specific tag
  bool hasTag(String tagName) => 
      tags.any((tag) => tag.toLowerCase() == tagName.toLowerCase());

  /// Get searchable text for full-text search
  String get searchableText {
    final contentText = content.plainText;
    final tagsText = tags.join(' ');
    return '$title $description $contentText $tagsText'.toLowerCase();
  }

  /// Age calculations
  Duration get age => DateTime.now().difference(createdAt ?? DateTime.now());
  bool get isRecent => age.inDays <= 7;
  bool get isOld => age.inDays >= 90;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemModel &&
        other.id == id &&
        other.projectId == projectId &&
        other.title == title &&
        other.description == description &&
        other.content == content &&
        other.itemType == itemType &&
        other.status == status &&
        other.priority == priority &&
        other.tags == tags &&
        other.authorId == authorId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.resolvedAt == resolvedAt &&
        other.viewCount == viewCount &&
        other.voteScore == voteScore;
  }

  @override
  int get hashCode => Object.hash(
    id, 
    projectId, 
    title, 
    description, 
    content,
    itemType,
    status,
    priority,
    tags,
    authorId,
    createdAt,
    updatedAt,
    resolvedAt,
    viewCount,
    voteScore,
  );

  @override
  String toString() => 'ItemModel(id: $id, projectId: $projectId, title: $title, type: ${itemType.displayName}, status: ${status.displayName})';
}