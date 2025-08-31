import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  // Authentication related logs
  static void authSuccess(String operation, String? email) {
    _logger.i('🔐 AUTH SUCCESS: $operation${email != null ? ' for $email' : ''}');
  }

  static void authError(String operation, String error, String? email) {
    _logger.e('❌ AUTH ERROR: $operation failed${email != null ? ' for $email' : ''}\n   Error: $error');
  }

  static void authInfo(String operation, String details) {
    _logger.i('ℹ️  AUTH INFO: $operation - $details');
  }

  // Session related logs
  static void sessionStarted(String? email) {
    _logger.i('🚀 SESSION STARTED${email != null ? ' for $email' : ''}');
  }

  static void sessionEnded(String? email) {
    _logger.w('👋 SESSION ENDED${email != null ? ' for $email' : ''}');
  }

  static void sessionRefreshed(String? email) {
    _logger.i('🔄 SESSION REFRESHED${email != null ? ' for $email' : ''}');
  }

  static void sessionRecovered() {
    _logger.i('💾 SESSION RECOVERED from stored tokens');
  }

  // Token related logs
  static void tokensStored() {
    _logger.d('🔒 TOKENS STORED securely');
  }

  static void tokensCleared() {
    _logger.d('🧹 TOKENS CLEARED from storage');
  }

  // Password reset logs
  static void passwordResetSent(String email) {
    _logger.i('📧 PASSWORD RESET sent to $email');
  }

  static void passwordResetError(String email, String error) {
    _logger.e('❌ PASSWORD RESET failed for $email\n   Error: $error');
  }

  // Navigation logs
  static void navigationTo(String route) {
    _logger.d('📍 NAVIGATING to $route');
  }

  // General app logs
  static void appStarted() {
    _logger.i('🎯 KNOWNBASE STARTED');
  }

  static void info(String message) {
    _logger.i('ℹ️  $message');
  }

  static void warning(String message) {
    _logger.w('⚠️  $message');
  }

  static void error(String message, [Object? error]) {
    _logger.e('💥 $message${error != null ? '\n   Error: $error' : ''}');
  }

  static void debug(String message) {
    _logger.d('🐛 $message');
  }
}