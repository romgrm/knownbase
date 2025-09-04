import '../domain_models/item_model.dart';
import '../domain_models/item_content_model.dart';
import '../domain_models/item_error.dart';
import '../../../../core/utils/result.dart';

/// Validator for item business rules
class ItemValidator {
  const ItemValidator();

  /// Validate item creation
  Result<void, ItemError> validateForCreation({
    required String title,
    required String description,
    required ItemContentModel content,
    required List<String> tags,
  }) {
    // Title validation
    final titleResult = validateTitle(title);
    if (titleResult.isFailure) {
      return Result.failure(titleResult.error!);
    }

    // Content validation
    final contentResult = validateContent(content);
    if (contentResult.isFailure) {
      return Result.failure(contentResult.error!);
    }

    // Tags validation
    final tagsResult = validateTags(tags);
    if (tagsResult.isFailure) {
      return Result.failure(tagsResult.error!);
    }

    return const Result.success(null);
  }

  /// Validate item update
  Result<void, ItemError> validateForUpdate({
    String? title,
    String? description,
    ItemContentModel? content,
    List<String>? tags,
  }) {
    // Title validation (if provided)
    if (title != null) {
      final titleResult = validateTitle(title);
      if (titleResult.isFailure) {
        return Result.failure(titleResult.error!);
      }
    }

    // Content validation (if provided)
    if (content != null) {
      final contentResult = validateContent(content);
      if (contentResult.isFailure) {
        return Result.failure(contentResult.error!);
      }
    }

    // Tags validation (if provided)
    if (tags != null) {
      final tagsResult = validateTags(tags);
      if (tagsResult.isFailure) {
        return Result.failure(tagsResult.error!);
      }
    }

    return const Result.success(null);
  }

  /// Validate title
  Result<void, ItemError> validateTitle(String title) {
    final trimmedTitle = title.trim();
    
    if (trimmedTitle.isEmpty) {
      return Result.failure(ItemValidationError.emptyTitle());
    }

    if (trimmedTitle.length > 200) {
      return Result.failure(const ItemValidationError('Title too long (max 200 characters)'));
    }

    // Check for malicious content
    if (_containsSuspiciousContent(trimmedTitle)) {
      return Result.failure(const ItemValidationError('Title contains invalid content'));
    }

    return const Result.success(null);
  }

  /// Validate content
  Result<void, ItemError> validateContent(ItemContentModel content) {
    if (content.blocks.isEmpty) {
      return Result.failure(ItemValidationError.emptyContent());
    }

    // Validate each content block
    for (final block in content.blocks) {
      final blockResult = _validateContentBlock(block);
      if (blockResult.isFailure) {
        return Result.failure(blockResult.error!);
      }
    }

    // Check total content length
    final totalLength = content.blocks
        .map((block) => block.content.length)
        .fold<int>(0, (sum, length) => sum + length);

    if (totalLength > 50000) { // 50KB limit
      return Result.failure(const ItemValidationError('Content too long (max 50,000 characters)'));
    }

    return const Result.success(null);
  }

  /// Validate tags
  Result<void, ItemError> validateTags(List<String> tags) {
    if (tags.length > 10) {
      return Result.failure(ItemValidationError.tooManyTags());
    }

    final cleanTags = <String>[];
    for (final tag in tags) {
      final trimmedTag = tag.trim().toLowerCase();
      
      if (trimmedTag.isEmpty) continue;
      
      if (trimmedTag.length > 50) {
        return Result.failure(ItemValidationError.tagTooLong(tag));
      }

      // Check for valid tag format (alphanumeric, hyphens, underscores)
      if (!RegExp(r'^[a-z0-9_-]+$').hasMatch(trimmedTag)) {
        return Result.failure(ItemValidationError('Invalid tag format: $tag'));
      }

      // Avoid duplicates
      if (!cleanTags.contains(trimmedTag)) {
        cleanTags.add(trimmedTag);
      }
    }

    return const Result.success(null);
  }

  /// Validate project access
  Future<Result<void, ItemError>> validateProjectAccess(String projectId, String userId) async {
    // TODO: Implement project access validation
    // This would check if user has permission to create/edit items in the project
    return const Result.success(null);
  }

  /// Validate content block
  Result<void, ItemError> _validateContentBlock(ContentBlock block) {
    if (block.content.trim().isEmpty) {
      return Result.failure(const ItemValidationError('Content block cannot be empty'));
    }

    // Validate specific block types
    switch (block.type) {
      case ContentBlockType.code:
        return _validateCodeBlock(block);
      case ContentBlockType.heading:
        return _validateHeadingBlock(block);
      case ContentBlockType.text:
      case ContentBlockType.list:
      case ContentBlockType.quote:
        return _validateTextBlock(block);
    }
  }

  /// Validate code block
  Result<void, ItemError> _validateCodeBlock(ContentBlock block) {
    if (block.content.length > 10000) {
      return Result.failure(const ItemValidationError('Code block too long (max 10,000 characters)'));
    }

    // Validate language if specified
    final language = block.metadata['language'] as String?;
    if (language != null && !_isValidCodeLanguage(language)) {
      return Result.failure(ItemValidationError('Invalid code language: $language'));
    }

    return const Result.success(null);
  }

  /// Validate heading block
  Result<void, ItemError> _validateHeadingBlock(ContentBlock block) {
    if (block.content.length > 100) {
      return Result.failure(const ItemValidationError('Heading too long (max 100 characters)'));
    }

    final level = block.metadata['level'] as int?;
    if (level != null && (level < 1 || level > 6)) {
      return Result.failure(const ItemValidationError('Invalid heading level (must be 1-6)'));
    }

    return const Result.success(null);
  }

  /// Validate text block
  Result<void, ItemError> _validateTextBlock(ContentBlock block) {
    if (block.content.length > 5000) {
      return Result.failure(const ItemValidationError('Text block too long (max 5,000 characters)'));
    }

    if (_containsSuspiciousContent(block.content)) {
      return Result.failure(const ItemValidationError('Content contains invalid content'));
    }

    return const Result.success(null);
  }

  /// Check for suspicious content (basic XSS prevention)
  bool _containsSuspiciousContent(String content) {
    final lowerContent = content.toLowerCase();
    final suspiciousPatterns = [
      '<script',
      'javascript:',
      'onload=',
      'onerror=',
      'onclick=',
      'eval(',
    ];

    return suspiciousPatterns.any((pattern) => lowerContent.contains(pattern));
  }

  /// Validate code language
  bool _isValidCodeLanguage(String language) {
    const validLanguages = {
      'javascript', 'typescript', 'python', 'java', 'cpp', 'c', 'csharp',
      'php', 'ruby', 'go', 'rust', 'swift', 'kotlin', 'dart', 'html',
      'css', 'scss', 'sql', 'json', 'yaml', 'xml', 'markdown', 'bash',
      'shell', 'powershell', 'dockerfile', 'nginx', 'apache', 'plaintext'
    };

    return validLanguages.contains(language.toLowerCase());
  }
}