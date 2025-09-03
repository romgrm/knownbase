import '../domain/item_model.dart';
import 'item_tag_dto.dart';
import 'item_type_dto.dart';

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
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.itemType,
  });

  final String? id;
  final String projectId;
  final String itemTypeId;
  final String createdBy;
  final String title;
  final String description;
  final String solution;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ItemTagDto> tags;
  final ItemTypeDto? itemType;

  /// Create ItemDto from JSON response
  factory ItemDto.fromJson(Map<String, dynamic> json) {
    List<ItemTagDto> tagsList = [];
    if (json['item_tags'] is List) {
      tagsList = (json['item_tags'] as List)
          .map((tagJson) => ItemTagDto.fromJson(tagJson as Map<String, dynamic>))
          .toList();
    }

    ItemTypeDto? itemTypeDto;
    if (json['items_types'] is Map<String, dynamic>) {
      itemTypeDto = ItemTypeDto.fromJson(json['items_types'] as Map<String, dynamic>);
    }

    return ItemDto(
      id: json['id']?.toString(),
      projectId: json['project_id']?.toString() ?? '',
      itemTypeId: json['item_type_id']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      solution: json['solution']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      tags: tagsList,
      itemType: itemTypeDto,
    );
  }

  /// Create ItemDto from domain model
  factory ItemDto.fromDomain(ItemModel item) {
    return ItemDto(
      id: item.id.isEmpty ? null : item.id,
      projectId: item.projectId,
      itemTypeId: item.itemTypeId,
      createdBy: item.createdBy,
      title: item.title,
      description: item.description,
      solution: item.solution,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      tags: item.tags.map((tag) => ItemTagDto.fromDomain(tag)).toList(),
      itemType: item.itemType != null ? ItemTypeDto.fromDomain(item.itemType!) : null,
    );
  }

  /// Convert to JSON for Supabase operations
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'project_id': projectId,
      'item_type_id': itemTypeId,
      'created_by': createdBy,
      'title': title,
      'description': description,
      'solution': solution,
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

    return json;
  }

  /// Convert to domain model
  ItemModel toDomain() {
    return ItemModel(
      id: id ?? '',
      projectId: projectId,
      itemTypeId: itemTypeId,
      createdBy: createdBy,
      title: title,
      description: description,
      solution: solution,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags.map((tag) => tag.toDomain()).toList(),
      itemType: itemType?.toDomain(),
    );
  }
}