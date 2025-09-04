/// Model representing an item type
class ItemTypeModel {
  const ItemTypeModel({
    this.id = '',
    this.name = '',
    this.createdAt,
  });

  final String id;
  final String name;
  final DateTime? createdAt;

  /// Create a copy of this model with updated values
  ItemTypeModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return ItemTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if the model is valid
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemTypeModel &&
        other.id == id &&
        other.name == name &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);

  @override
  String toString() => 'ItemTypeModel(id: $id, name: $name)';
}