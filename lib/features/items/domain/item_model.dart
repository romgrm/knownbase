import 'item_tag_model.dart';
import 'item_type_model.dart';

/// Model representing an item (bug, feature, task, etc.)
class ItemModel {
  const ItemModel({
    this.id = '',
    this.projectId = '',
    this.itemTypeId = '',
    this.createdBy = '',
    this.title = '',
    this.description = '',
    this.solution = '',
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.itemType,
  });

  final String id;
  final String projectId;
  final String itemTypeId;
  final String createdBy;
  final String title;
  final String description;
  final String solution;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ItemTagModel> tags;
  final ItemTypeModel? itemType;

  /// Create a copy of this model with updated values
  ItemModel copyWith({
    String? id,
    String? projectId,
    String? itemTypeId,
    String? createdBy,
    String? title,
    String? description,
    String? solution,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ItemTagModel>? tags,
    ItemTypeModel? itemType,
  }) {
    return ItemModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      itemTypeId: itemTypeId ?? this.itemTypeId,
      createdBy: createdBy ?? this.createdBy,
      title: title ?? this.title,
      description: description ?? this.description,
      solution: solution ?? this.solution,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      itemType: itemType ?? this.itemType,
    );
  }

  /// Check if the model is valid
  bool get isValid => 
      id.isNotEmpty && 
      projectId.isNotEmpty && 
      itemTypeId.isNotEmpty && 
      createdBy.isNotEmpty && 
      title.isNotEmpty;

  /// Check if item has solution
  bool get hasSolution => solution.isNotEmpty;

  /// Check if item has description
  bool get hasDescription => description.isNotEmpty;

  /// Get tag names as list of strings
  List<String> get tagNames => tags.map((tag) => tag.name).toList();

  /// Check if item has specific tag
  bool hasTag(String tagName) => 
      tags.any((tag) => tag.name.toLowerCase() == tagName.toLowerCase());

  /// Get item type name (fallback to ID if type not loaded)
  String get typeName => itemType?.name ?? itemTypeId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemModel &&
        other.id == id &&
        other.projectId == projectId &&
        other.itemTypeId == itemTypeId &&
        other.createdBy == createdBy &&
        other.title == title &&
        other.description == description &&
        other.solution == solution &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.tags == tags &&
        other.itemType == itemType;
  }

  @override
  int get hashCode => Object.hash(
    id, 
    projectId, 
    itemTypeId, 
    createdBy, 
    title, 
    description, 
    solution, 
    createdAt, 
    updatedAt, 
    tags, 
    itemType,
  );

  @override
  String toString() => 'ItemModel(id: $id, projectId: $projectId, title: $title, type: $typeName)';
}