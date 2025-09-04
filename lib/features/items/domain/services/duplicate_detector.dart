import '../domain_models/item_model.dart';
import 'content_processor.dart';

/// Service for detecting potential duplicate items
class DuplicateDetector {
  final ContentProcessor _contentProcessor;
  
  const DuplicateDetector({
    ContentProcessor? contentProcessor,
  }) : _contentProcessor = contentProcessor ?? const ContentProcessor();

  /// Find potential duplicates based on title and content similarity
  List<DuplicateMatch> findPotentialDuplicates({
    required String title,
    required String description,
    required List<ItemModel> existingItems,
    double similarityThreshold = 0.7,
  }) {
    final matches = <DuplicateMatch>[];
    
    for (final item in existingItems) {
      final similarity = _calculateSimilarity(
        title: title,
        description: description,
        existingItem: item,
      );
      
      if (similarity.overallScore >= similarityThreshold) {
        matches.add(DuplicateMatch(
          item: item,
          similarity: similarity,
        ));
      }
    }
    
    // Sort by similarity score (highest first)
    matches.sort((a, b) => b.similarity.overallScore.compareTo(a.similarity.overallScore));
    
    return matches;
  }

  /// Calculate similarity between new content and existing item
  SimilarityScore _calculateSimilarity({
    required String title,
    required String description,
    required ItemModel existingItem,
  }) {
    // Title similarity (weighted heavily)
    final titleSimilarity = _calculateTextSimilarity(
      title.toLowerCase(),
      existingItem.title.toLowerCase(),
    );
    
    // Description similarity
    final descriptionSimilarity = _calculateTextSimilarity(
      description.toLowerCase(),
      existingItem.description.toLowerCase(),
    );
    
    // Content similarity (if available)
    final existingContent = _contentProcessor.extractPlainText(existingItem.content);
    final contentSimilarity = _calculateTextSimilarity(
      description.toLowerCase(),
      existingContent.toLowerCase(),
    );
    
    // Tag similarity
    final newTags = _extractWords('$title $description');
    final tagSimilarity = _calculateTagSimilarity(newTags, existingItem.tags);
    
    // Calculate weighted overall score
    final overallScore = (titleSimilarity * 0.5) +  // Title is most important
                        (descriptionSimilarity * 0.2) +
                        (contentSimilarity * 0.2) +
                        (tagSimilarity * 0.1);
    
    return SimilarityScore(
      titleSimilarity: titleSimilarity,
      descriptionSimilarity: descriptionSimilarity,
      contentSimilarity: contentSimilarity,
      tagSimilarity: tagSimilarity,
      overallScore: overallScore,
    );
  }

  /// Calculate text similarity using Jaccard similarity
  double _calculateTextSimilarity(String text1, String text2) {
    if (text1.isEmpty && text2.isEmpty) return 1.0;
    if (text1.isEmpty || text2.isEmpty) return 0.0;
    
    final words1 = _extractWords(text1).toSet();
    final words2 = _extractWords(text2).toSet();
    
    if (words1.isEmpty && words2.isEmpty) return 1.0;
    if (words1.isEmpty || words2.isEmpty) return 0.0;
    
    final intersection = words1.intersection(words2);
    final union = words1.union(words2);
    
    return intersection.length / union.length;
  }

  /// Calculate tag similarity
  double _calculateTagSimilarity(List<String> words1, List<String> tags2) {
    if (words1.isEmpty && tags2.isEmpty) return 1.0;
    if (words1.isEmpty || tags2.isEmpty) return 0.0;
    
    final set1 = words1.map((w) => w.toLowerCase()).toSet();
    final set2 = tags2.map((t) => t.toLowerCase()).toSet();
    
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);
    
    return intersection.length / union.length;
  }

  /// Extract meaningful words from text
  List<String> _extractWords(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length >= 3)
        .where((word) => !_isStopWord(word))
        .toList();
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

/// Represents a potential duplicate match
class DuplicateMatch {
  final ItemModel item;
  final SimilarityScore similarity;
  
  const DuplicateMatch({
    required this.item,
    required this.similarity,
  });
  
  /// Get risk level based on similarity score
  DuplicateRisk get riskLevel {
    if (similarity.overallScore >= 0.9) return DuplicateRisk.high;
    if (similarity.overallScore >= 0.7) return DuplicateRisk.medium;
    return DuplicateRisk.low;
  }
  
  /// Get human-readable description
  String get description {
    final score = (similarity.overallScore * 100).round();
    return '$score% similar to "${item.title}"';
  }
}

/// Similarity scores for different aspects
class SimilarityScore {
  final double titleSimilarity;
  final double descriptionSimilarity;
  final double contentSimilarity;
  final double tagSimilarity;
  final double overallScore;
  
  const SimilarityScore({
    required this.titleSimilarity,
    required this.descriptionSimilarity,
    required this.contentSimilarity,
    required this.tagSimilarity,
    required this.overallScore,
  });
}

/// Risk levels for duplicate detection
enum DuplicateRisk {
  low,
  medium,
  high;
  
  String get displayName {
    switch (this) {
      case DuplicateRisk.low:
        return 'Low Risk';
      case DuplicateRisk.medium:
        return 'Medium Risk';
      case DuplicateRisk.high:
        return 'High Risk';
    }
  }
  
  String get description {
    switch (this) {
      case DuplicateRisk.low:
        return 'Some similarities detected';
      case DuplicateRisk.medium:
        return 'Significant similarities found';
      case DuplicateRisk.high:
        return 'Very similar content detected';
    }
  }
}