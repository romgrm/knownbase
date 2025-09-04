import '../domain_models/item_content_model.dart';

/// Processor for item content operations
class ContentProcessor {
  const ContentProcessor();

  /// Extract plain text from content for search indexing
  String extractPlainText(ItemContentModel content) {
    return content.blocks
        .map((block) => _extractBlockText(block))
        .where((text) => text.isNotEmpty)
        .join('\n');
  }

  /// Extract code blocks for syntax highlighting
  List<ContentBlock> extractCodeBlocks(ItemContentModel content) {
    return content.blocks
        .where((block) => block.type == ContentBlockType.code)
        .toList();
  }

  /// Get content summary (first 200 characters)
  String generateSummary(ItemContentModel content) {
    final plainText = extractPlainText(content);
    if (plainText.length <= 200) {
      return plainText;
    }
    
    // Try to cut at word boundary
    final truncated = plainText.substring(0, 200);
    final lastSpaceIndex = truncated.lastIndexOf(' ');
    
    if (lastSpaceIndex > 150) {
      return '${truncated.substring(0, lastSpaceIndex)}...';
    }
    
    return '${truncated}...';
  }

  /// Extract keywords from content for tagging suggestions
  List<String> extractKeywords(ItemContentModel content) {
    final plainText = extractPlainText(content).toLowerCase();
    final words = plainText
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length >= 3)
        .where((word) => !_isStopWord(word))
        .toList();

    // Count word frequency
    final wordCount = <String, int>{};
    for (final word in words) {
      wordCount[word] = (wordCount[word] ?? 0) + 1;
    }

    // Return top keywords sorted by frequency
    final sortedWords = wordCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedWords
        .take(10)
        .map((entry) => entry.key)
        .toList();
  }

  /// Clean and normalize content blocks
  ItemContentModel normalizeContent(ItemContentModel content) {
    final normalizedBlocks = content.blocks
        .where((block) => block.content.trim().isNotEmpty)
        .map((block) => _normalizeBlock(block))
        .toList();

    return ItemContentModel(blocks: normalizedBlocks);
  }

  /// Validate content structure
  bool isValidContentStructure(ItemContentModel content) {
    if (content.blocks.isEmpty) return false;
    
    // Check for valid block types and content
    for (final block in content.blocks) {
      if (block.content.trim().isEmpty) return false;
      
      // Validate block-specific constraints
      switch (block.type) {
        case ContentBlockType.heading:
          final level = block.metadata['level'] as int?;
          if (level == null || level < 1 || level > 6) return false;
        case ContentBlockType.code:
          // Code blocks should have reasonable length
          if (block.content.length > 10000) return false;
        default:
          break;
      }
    }
    
    return true;
  }

  /// Convert content to searchable format
  Map<String, dynamic> toSearchableFormat(ItemContentModel content) {
    return {
      'plain_text': extractPlainText(content),
      'has_code': content.codeBlocks.isNotEmpty,
      'block_count': content.blocks.length,
      'keywords': extractKeywords(content),
      'summary': generateSummary(content),
    };
  }

  /// Extract text from a single content block
  String _extractBlockText(ContentBlock block) {
    switch (block.type) {
      case ContentBlockType.code:
        // For code blocks, add language info if available
        final language = block.metadata['language'] as String?;
        final prefix = language != null ? '[$language]\n' : '';
        return '$prefix${block.content}';
      case ContentBlockType.heading:
        // Add heading level indicators
        final level = block.metadata['level'] as int? ?? 1;
        final prefix = '${'#' * level} ';
        return '$prefix${block.content}';
      case ContentBlockType.list:
        // Format list items
        return block.content
            .split('\n')
            .map((line) => '• ${line.trim()}')
            .join('\n');
      case ContentBlockType.quote:
        // Format quote
        return '> ${block.content}';
      case ContentBlockType.text:
      default:
        return block.content;
    }
  }

  /// Normalize a single content block
  ContentBlock _normalizeBlock(ContentBlock block) {
    final trimmedContent = block.content.trim();
    
    switch (block.type) {
      case ContentBlockType.heading:
        // Ensure heading level is valid
        var level = block.metadata['level'] as int? ?? 1;
        if (level < 1 || level > 6) level = 1;
        
        return ContentBlock(
          type: block.type,
          content: trimmedContent,
          metadata: {'level': level},
        );
        
      case ContentBlockType.code:
        // Normalize language name
        var language = block.metadata['language'] as String?;
        if (language != null) {
          language = language.toLowerCase().trim();
          if (language.isEmpty) language = null;
        }
        
        return ContentBlock(
          type: block.type,
          content: trimmedContent,
          metadata: language != null ? {'language': language} : {},
        );
        
      default:
        return ContentBlock(
          type: block.type,
          content: trimmedContent,
          metadata: block.metadata,
        );
    }
  }

  /// Check if word is a stop word
  bool _isStopWord(String word) {
    const stopWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'is', 'are', 'was', 'were', 'be', 'been', 'have',
      'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could', 'should',
      'may', 'might', 'can', 'this', 'that', 'these', 'those', 'i', 'you',
      'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her', 'us', 'them',
    };
    
    return stopWords.contains(word);
  }
}