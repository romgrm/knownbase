import '../domain/item_type_model.dart';

/// Data Transfer Object for ItemType data from/to Supabase
class ItemTypeDto {
  const ItemTypeDto({
    this.id,
    this.name = '',
    this.createdAt,
  });

  final String? id;
  final String name;
  final DateTime? createdAt;

  /// Create ItemTypeDto from JSON response
  factory ItemTypeDto.fromJson(Map<String, dynamic> json) {
    return ItemTypeDto(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Create ItemTypeDto from domain model
  factory ItemTypeDto.fromDomain(ItemTypeModel itemType) {
    return ItemTypeDto(
      id: itemType.id.isEmpty ? null : itemType.id,
      name: itemType.name,
      createdAt: itemType.createdAt,
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

    if (createdAt != null) {
      json['created_at'] = createdAt!.toIso8601String();
    }

    return json;
  }

  /// Convert to domain model
  ItemTypeModel toDomain() {
    return ItemTypeModel(
      id: id ?? '',
      name: name,
      createdAt: createdAt,
    );
  }
}