import '../domain_models/item_model.dart';
import 'content_processor.dart';

/// Service for suggesting tags based on content
class TagSuggester {
  final ContentProcessor _contentProcessor;
  
  const TagSuggester({
    ContentProcessor? contentProcessor,
  }) : _contentProcessor = contentProcessor ?? const ContentProcessor();

  /// Generate tag suggestions based on content
  List<TagSuggestion> suggestTags({
    required String title,
    required String description,
    required List<ItemModel> existingItems,
    int maxSuggestions = 10,
  }) {
    final suggestions = <TagSuggestion>[];
    
    // Extract keywords from title and description
    final contentKeywords = _extractKeywords('$title $description');
    
    // Get existing tags from similar items
    final existingTags = _getRelevantExistingTags(
      content: '$title $description',
      existingItems: existingItems,
    );
    
    // Combine and score suggestions
    final allSuggestions = <String, TagSuggestion>{};
    
    // Add keyword-based suggestions
    for (final keyword in contentKeywords) {
      allSuggestions[keyword] = TagSuggestion(
        tag: keyword,
        confidence: 0.8,
        source: TagSource.content,
        reason: 'Found in content',
      );
    }
    
    // Add existing tag suggestions with higher confidence
    for (final entry in existingTags.entries) {
      final tag = entry.key;
      final frequency = entry.value;
      final confidence = (frequency / existingItems.length).clamp(0.0, 1.0);
      
      allSuggestions[tag] = TagSuggestion(
        tag: tag,
        confidence: confidence * 0.9, // Slightly lower than exact matches
        source: TagSource.similar,
        reason: 'Used in $frequency similar items',
      );
    }
    
    // Add technology/framework detection
    final techTags = _detectTechnologyTags('$title $description');
    for (final tag in techTags) {
      allSuggestions[tag] = TagSuggestion(
        tag: tag,
        confidence: 0.9,
        source: TagSource.technology,
        reason: 'Technology detected',
      );
    }
    
    // Sort by confidence and return top suggestions
    final sortedSuggestions = allSuggestions.values.toList()
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    
    return sortedSuggestions.take(maxSuggestions).toList();
  }

  /// Extract keywords from text
  List<String> _extractKeywords(String text) {
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length >= 3)
        .where((word) => !_isStopWord(word))
        .where((word) => _isValidTag(word))
        .toList();
    
    // Count frequency and return most common
    final wordCount = <String, int>{};
    for (final word in words) {
      wordCount[word] = (wordCount[word] ?? 0) + 1;
    }
    
    return wordCount.entries
        .where((entry) => entry.value >= 2) // Minimum frequency
        .map((entry) => entry.key)
        .toList();
  }

  /// Get relevant existing tags from similar items
  Map<String, int> _getRelevantExistingTags({
    required String content,
    required List<ItemModel> existingItems,
  }) {
    final contentWords = _extractKeywords(content).toSet();
    final tagFrequency = <String, int>{};
    
    for (final item in existingItems) {
      final itemContent = '${item.title} ${item.description}';
      final itemWords = _extractKeywords(itemContent).toSet();
      
      // Check if items are similar based on keyword overlap
      final overlap = contentWords.intersection(itemWords);
      if (overlap.isNotEmpty) {
        // Add tags from similar items
        for (final tag in item.tags) {
          tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;
        }
      }
    }
    
    return tagFrequency;
  }

  /// Detect technology-specific tags
  List<String> _detectTechnologyTags(String content) {
    final lowerContent = content.toLowerCase();
    final techTags = <String>[];
    
    // Programming languages
    const languages = {
      'javascript': ['javascript', 'js', 'node', 'npm'],
      'typescript': ['typescript', 'ts'],
      'python': ['python', 'py', 'pip', 'django', 'flask'],
      'java': ['java', 'spring', 'maven', 'gradle'],
      'csharp': ['c#', 'csharp', '.net', 'dotnet'],
      'php': ['php', 'laravel', 'symfony'],
      'ruby': ['ruby', 'rails', 'gem'],
      'go': ['golang', 'go'],
      'rust': ['rust', 'cargo'],
      'swift': ['swift', 'ios'],
      'kotlin': ['kotlin', 'android'],
      'dart': ['dart', 'flutter'],
    };
    
    for (final entry in languages.entries) {
      final tag = entry.key;
      final keywords = entry.value;
      
      if (keywords.any((keyword) => lowerContent.contains(keyword))) {
        techTags.add(tag);
      }
    }
    
    // Frameworks and libraries
    const frameworks = {
      'react': ['react', 'jsx', 'reactjs'],
      'vue': ['vue', 'vuejs'],
      'angular': ['angular', 'ng'],
      'express': ['express', 'expressjs'],
      'docker': ['docker', 'dockerfile', 'container'],
      'kubernetes': ['kubernetes', 'k8s', 'kubectl'],
      'aws': ['aws', 'amazon web services'],
      'firebase': ['firebase'],
      'mongodb': ['mongodb', 'mongo'],
      'postgresql': ['postgresql', 'postgres'],
      'mysql': ['mysql'],
      'redis': ['redis'],
      'graphql': ['graphql'],
      'api': ['api', 'rest', 'endpoint'],
      'database': ['database', 'db', 'sql'],
      'frontend': ['frontend', 'ui', 'ux'],
      'backend': ['backend', 'server'],
      'mobile': ['mobile', 'app', 'ios', 'android'],
      'web': ['web', 'website', 'browser'],
      'testing': ['test', 'testing', 'jest', 'cypress'],
      'deployment': ['deploy', 'deployment', 'ci', 'cd'],
    };
    
    for (final entry in frameworks.entries) {
      final tag = entry.key;
      final keywords = entry.value;
      
      if (keywords.any((keyword) => lowerContent.contains(keyword))) {
        techTags.add(tag);
      }
    }
    
    // Issue types
    const issueTypes = {
      'bug': ['bug', 'error', 'issue', 'problem', 'broken'],
      'feature': ['feature', 'enhancement', 'new'],
      'documentation': ['docs', 'documentation', 'readme'],
      'performance': ['performance', 'slow', 'optimization'],
      'security': ['security', 'vulnerability', 'auth'],
      'configuration': ['config', 'configuration', 'setup'],
      'migration': ['migration', 'upgrade', 'update'],
    };
    
    for (final entry in issueTypes.entries) {
      final tag = entry.key;
      final keywords = entry.value;
      
      if (keywords.any((keyword) => lowerContent.contains(keyword))) {
        techTags.add(tag);
      }
    }
    
    return techTags;
  }

  /// Check if word is a valid tag
  bool _isValidTag(String word) {
    // Must be alphanumeric with optional hyphens/underscores
    if (!RegExp(r'^[a-z0-9_-]+$').hasMatch(word)) return false;
    
    // Must not be too short or too long
    if (word.length < 3 || word.length > 20) return false;
    
    // Must not be a generic stop word
    if (_isStopWord(word)) return false;
    
    return true;
  }

  /// Check if word is a stop word
  bool _isStopWord(String word) {
    const stopWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'is', 'are', 'was', 'were', 'be', 'been', 'have',
      'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could', 'should',
      'may', 'might', 'can', 'this', 'that', 'these', 'those', 'i', 'you',
      'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her', 'us', 'them',
      'how', 'why', 'what', 'where', 'when', 'who', 'which', 'get', 'set',
      'use', 'using', 'used', 'make', 'made', 'create', 'created', 'add',
      'added', 'remove', 'removed', 'update', 'updated', 'fix', 'fixed',
    };
    
    return stopWords.contains(word);
  }
}

/// Represents a tag suggestion with metadata
class TagSuggestion {
  final String tag;
  final double confidence; // 0.0 to 1.0
  final TagSource source;
  final String reason;
  
  const TagSuggestion({
    required this.tag,
    required this.confidence,
    required this.source,
    required this.reason,
  });
  
  /// Get confidence as percentage
  int get confidencePercentage => (confidence * 100).round();
  
  /// Get display text for UI
  String get displayText => '$tag (${confidencePercentage}%)';
}

/// Sources for tag suggestions
enum TagSource {
  content,    // Extracted from content keywords
  similar,    // From similar existing items
  technology, // Detected technology/framework
  manual;     // Manually added by user
  
  String get displayName {
    switch (this) {
      case TagSource.content:
        return 'Content';
      case TagSource.similar:
        return 'Similar Items';
      case TagSource.technology:
        return 'Technology';
      case TagSource.manual:
        return 'Manual';
    }
  }
}