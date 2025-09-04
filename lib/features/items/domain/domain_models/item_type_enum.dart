enum ItemTypeEnum {
  knownIssue('known_issue', 'Known Issue', '🐛'),
  tip('tip', 'Tip', '💡'), 
  setupStep('setup_step', 'Setup Step', '⚙️'),
  workaround('workaround', 'Workaround', '🔧'),
  custom('custom', 'Custom', '📝');

  const ItemTypeEnum(this.value, this.displayName, this.icon);

  final String value;
  final String displayName;
  final String icon;

  static ItemTypeEnum fromValue(String value) {
    return ItemTypeEnum.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ItemTypeEnum.custom,
    );
  }

  static List<ItemTypeEnum> get defaultTypes => [
    ItemTypeEnum.knownIssue,
    ItemTypeEnum.tip,
    ItemTypeEnum.setupStep,
    ItemTypeEnum.workaround,
  ];
}