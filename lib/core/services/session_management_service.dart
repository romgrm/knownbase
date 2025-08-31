import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/result.dart';
import 'token_storage_service.dart';
import 'app_logger.dart';

abstract class ISessionManagementService {
  Future<Result<void, String>> initializeSession();
  Future<Result<bool, String>> isSessionValid();
  Future<Result<void, String>> refreshSessionIfNeeded();
  Future<Result<void, String>> clearSession();
  Stream<AuthState> get authStateChanges;
}

class SupabaseSessionManagementService implements ISessionManagementService {
  static const Duration _refreshThreshold = Duration(minutes: 30);
  
  final SupabaseClient _supabase;
  final ITokenStorageService _tokenStorage;
  Timer? _refreshTimer;
  
  SupabaseSessionManagementService({
    SupabaseClient? supabase,
    ITokenStorageService? tokenStorage,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _tokenStorage = tokenStorage ?? SecureTokenStorageService();

  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  @override
  Future<Result<void, String>> initializeSession() async {
    try {
      AppLogger.authInfo('SESSION_INIT', 'Initializing session management');
      
      // Check if we have stored tokens
      final hasTokensResult = await _tokenStorage.hasValidTokens();
      if (hasTokensResult.isFailure) {
        AppLogger.authError('SESSION_INIT', 'Failed to check stored tokens: ${hasTokensResult.error}', null);
        return Result.failure('Failed to check stored tokens: ${hasTokensResult.error}');
      }

      if (hasTokensResult.data == true) {
        // Try to recover session from stored tokens
        final accessTokenResult = await _tokenStorage.getAccessToken();
        
        // No need to check again - hasValidTokens() already validated everything
        await _supabase.auth.setSession(accessTokenResult.data!);
        AppLogger.sessionRecovered();
      } else {
        AppLogger.authInfo('SESSION_INIT', 'No valid stored tokens found');
      }

      // Start periodic session refresh
      _startPeriodicRefresh();
      AppLogger.authInfo('SESSION_INIT', 'Session management initialized successfully');
      
      return const Result.success(null);
    } catch (e) {
      AppLogger.authError('SESSION_INIT', e.toString(), null);
      return Result.failure('Failed to initialize session: $e');
    }
  }

  @override
  Future<Result<bool, String>> isSessionValid() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) {
        return const Result.success(false);
      }

      // Check if session is expired
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final isExpired = now >= session.expiresAt!;
      
      return Result.success(!isExpired);
    } catch (e) {
      return Result.failure('Failed to check session validity: $e');
    }
  }

  @override
  Future<Result<void, String>> refreshSessionIfNeeded() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) {
        return const Result.failure('No active session to refresh');
      }

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final timeUntilExpiry = session.expiresAt! - now;
      
      // Refresh if session expires within the threshold
      if (timeUntilExpiry <= _refreshThreshold.inSeconds) {
        final response = await _supabase.auth.refreshSession();
        
        if (response.session != null) {
          // Store updated tokens
          await _storeSessionTokens(response.session!);
          return const Result.success(null);
        } else {
          return const Result.failure('Failed to refresh session');
        }
      }
      
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to refresh session: $e');
    }
  }

  @override
  Future<Result<void, String>> clearSession() async {
    try {
      _refreshTimer?.cancel();
      _refreshTimer = null;
      
      await _supabase.auth.signOut();
      await _tokenStorage.clearTokens();
      
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to clear session: $e');
    }
  }

  /// Start periodic session refresh
  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 15), // Check every 15 minutes
      (timer) async {
        await refreshSessionIfNeeded();
      },
    );
  }

  /// Store session tokens securely
  Future<void> _storeSessionTokens(Session session) async {
    if (session.accessToken.isNotEmpty && session.refreshToken != null) {
      await _tokenStorage.storeAccessToken(session.accessToken);
      await _tokenStorage.storeRefreshToken(session.refreshToken!);
    }
  }

  /// Clean up resources
  void dispose() {
    _refreshTimer?.cancel();
  }
}