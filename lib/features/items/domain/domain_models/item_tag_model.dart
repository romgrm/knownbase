/// Model representing an item tag
class ItemTagModel {
  const ItemTagModel({
    this.id = '',
    this.itemId = '',
    this.name = '',
    this.createdAt,
  });

  final String id;
  final String itemId;
  final String name;
  final DateTime? createdAt;

  /// Create a copy of this model with updated values
  ItemTagModel copyWith({
    String? id,
    String? itemId,
    String? name,
    DateTime? createdAt,
  }) {
    return ItemTagModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if the model is valid
  bool get isValid => 
      id.isNotEmpty && 
      itemId.isNotEmpty && 
      name.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemTagModel &&
        other.id == id &&
        other.itemId == itemId &&
        other.name == name &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, itemId, name, createdAt);

  @override
  String toString() => 'ItemTagModel(id: $id, itemId: $itemId, name: $name)';
}