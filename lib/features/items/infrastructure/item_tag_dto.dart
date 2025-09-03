import '../domain/item_tag_model.dart';

/// Data Transfer Object for ItemTag data from/to Supabase
class ItemTagDto {
  const ItemTagDto({
    this.id,
    this.itemId = '',
    this.name = '',
    this.createdAt,
  });

  final String? id;
  final String itemId;
  final String name;
  final DateTime? createdAt;

  /// Create ItemTagDto from JSON response
  factory ItemTagDto.fromJson(Map<String, dynamic> json) {
    return ItemTagDto(
      id: json['id']?.toString(),
      itemId: json['item_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Create ItemTagDto from domain model
  factory ItemTagDto.fromDomain(ItemTagModel tag) {
    return ItemTagDto(
      id: tag.id.isEmpty ? null : tag.id,
      itemId: tag.itemId,
      name: tag.name,
      createdAt: tag.createdAt,
    );
  }

  /// Convert to JSON for Supabase operations
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'item_id': itemId,
      'name': name,
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
  ItemTagModel toDomain() {
    return ItemTagModel(
      id: id ?? '',
      itemId: itemId,
      name: name,
      createdAt: createdAt,
    );
  }
}