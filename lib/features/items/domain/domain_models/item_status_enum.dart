enum ItemStatusEnum {
  active('active', 'Active', '✅'),
  resolved('resolved', 'Resolved', '🎯'),
  archived('archived', 'Archived', '📦');

  const ItemStatusEnum(this.value, this.displayName, this.icon);

  final String value;
  final String displayName;
  final String icon;

  static ItemStatusEnum fromValue(String value) {
    return ItemStatusEnum.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ItemStatusEnum.active,
    );
  }
}