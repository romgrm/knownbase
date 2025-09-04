class ItemContentModel {
  final List<ContentBlock> blocks;

  const ItemContentModel({
    this.blocks = const [],
  });

  factory ItemContentModel.fromJson(Map<String, dynamic> json) {
    final blocksJson = json['blocks'] as List<dynamic>? ?? [];
    final blocks = blocksJson
        .map((block) => ContentBlock.fromJson(block as Map<String, dynamic>))
        .toList();

    return ItemContentModel(blocks: blocks);
  }

  Map<String, dynamic> toJson() {
    return {
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }

  ItemContentModel copyWith({
    List<ContentBlock>? blocks,
  }) {
    return ItemContentModel(
      blocks: blocks ?? this.blocks,
    );
  }

  String get plainText {
    return blocks
        .where((block) => block.type == ContentBlockType.text)
        .map((block) => block.content)
        .join('\n');
  }

  List<ContentBlock> get codeBlocks {
    return blocks.where((block) => block.type == ContentBlockType.code).toList();
  }
}

enum ContentBlockType {
  text('text'),
  code('code'),
  heading('heading'),
  list('list'),
  quote('quote');

  const ContentBlockType(this.value);
  final String value;

  static ContentBlockType fromValue(String value) {
    return ContentBlockType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ContentBlockType.text,
    );
  }
}

class ContentBlock {
  final ContentBlockType type;
  final String content;
  final Map<String, dynamic> metadata;

  const ContentBlock({
    required this.type,
    required this.content,
    this.metadata = const {},
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: ContentBlockType.fromValue(json['type'] as String),
      content: json['content'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'content': content,
      'metadata': metadata,
    };
  }

  ContentBlock copyWith({
    ContentBlockType? type,
    String? content,
    Map<String, dynamic>? metadata,
  }) {
    return ContentBlock(
      type: type ?? this.type,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
    );
  }

  factory ContentBlock.text(String content) {
    return ContentBlock(type: ContentBlockType.text, content: content);
  }

  factory ContentBlock.code(String content, {String? language}) {
    return ContentBlock(
      type: ContentBlockType.code,
      content: content,
      metadata: language != null ? {'language': language} : {},
    );
  }

  factory ContentBlock.heading(String content, {int level = 1}) {
    return ContentBlock(
      type: ContentBlockType.heading,
      content: content,
      metadata: {'level': level},
    );
  }
}