enum ItemPriorityEnum {
  low(0, 'Low', '🔵'),
  medium(1, 'Medium', '🟡'),
  high(2, 'High', '🟠'),
  critical(3, 'Critical', '🔴');

  const ItemPriorityEnum(this.value, this.displayName, this.icon);

  final int value;
  final String displayName;
  final String icon;

  static ItemPriorityEnum fromValue(int value) {
    return ItemPriorityEnum.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => ItemPriorityEnum.low,
    );
  }

  bool get isHighPriority => value >= 2;
  bool get isCritical => value == 3;
}