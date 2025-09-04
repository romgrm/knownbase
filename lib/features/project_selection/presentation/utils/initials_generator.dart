/// Utility class for generating initials from text
class InitialsGenerator {
  const InitialsGenerator._();

  /// Generate initials from a given text (typically name or title)
  ///
  /// Examples:
  /// - "Mobile App v2.0" -> "MA"
  /// - "John Doe" -> "JD"
  /// - "API Integration" -> "AI"
  /// - "single" -> "S"
  /// - "" -> "?"
  static String generate(String text) {
    if (text.isEmpty) return '?';

    // Split by spaces and take first letter of each word
    final words = text.trim().split(RegExp(r'\s+'));

    if (words.length == 1) {
      // Single word: take first letter or first two letters if available
      final word = words[0];
      if (word.length == 1) {
        return word.toUpperCase();
      }
      return word.substring(0, 2).toUpperCase();
    }

    // Multiple words: take first letter of first two words
    final firstInitial = words[0].isNotEmpty ? words[0][0] : '';
    final secondInitial =
        words.length > 1 && words[1].isNotEmpty ? words[1][0] : '';

    return (firstInitial + secondInitial).toUpperCase();
  }

  /// Generate initials from user's name (firstName lastName format)
  static String generateFromUserName(String firstName, String lastName) {
    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0] : '';

    if (firstInitial.isEmpty && lastInitial.isEmpty) return '?';
    if (firstInitial.isEmpty) return lastInitial.toUpperCase();
    if (lastInitial.isEmpty) return firstInitial.toUpperCase();

    return (firstInitial + lastInitial).toUpperCase();
  }

  /// Generate color based on text for consistent avatar colors
  static int generateColorSeed(String text) {
    if (text.isEmpty) return 0;

    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = ((hash << 5) - hash + text.codeUnitAt(i)) & 0xffffffff;
    }
    return hash.abs();
  }
}
