import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/result.dart';

abstract class ITokenStorageService {
  Future<Result<void, String>> storeAccessToken(String token);
  Future<Result<void, String>> storeRefreshToken(String token);
  Future<Result<String?, String>> getAccessToken();
  Future<Result<String?, String>> getRefreshToken();
  Future<Result<void, String>> clearTokens();
  Future<Result<bool, String>> hasValidTokens();
}

class SecureTokenStorageService implements ITokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  final FlutterSecureStorage _secureStorage;

  SecureTokenStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? 
          const FlutterSecureStorage(
            aOptions: AndroidOptions(
              encryptedSharedPreferences: true,
            ),
          );

  @override
  Future<Result<void, String>> storeAccessToken(String token) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: token);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to store access token: $e');
    }
  }

  @override
  Future<Result<void, String>> storeRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to store refresh token: $e');
    }
  }

  @override
  Future<Result<String?, String>> getAccessToken() async {
    try {
      final token = await _secureStorage.read(key: _accessTokenKey);
      return Result.success(token);
    } catch (e) {
      return Result.failure('Failed to get access token: $e');
    }
  }

  @override
  Future<Result<String?, String>> getRefreshToken() async {
    try {
      final token = await _secureStorage.read(key: _refreshTokenKey);
      return Result.success(token);
    } catch (e) {
      return Result.failure('Failed to get refresh token: $e');
    }
  }

  @override
  Future<Result<void, String>> clearTokens() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to clear tokens: $e');
    }
  }

  @override
  Future<Result<bool, String>> hasValidTokens() async {
    try {
      final accessTokenResult = await getAccessToken();
      final refreshTokenResult = await getRefreshToken();
      
      if (accessTokenResult.isFailure || refreshTokenResult.isFailure) {
        return const Result.success(false);
      }
      
      final hasTokens = accessTokenResult.data != null && 
                       refreshTokenResult.data != null &&
                       accessTokenResult.data!.isNotEmpty &&
                       refreshTokenResult.data!.isNotEmpty;
      
      return Result.success(hasTokens);
    } catch (e) {
      return Result.failure('Failed to check token validity: $e');
    }
  }
}