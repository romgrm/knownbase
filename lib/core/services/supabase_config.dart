import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuration for Supabase
class SupabaseConfig {
  static const String _supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String _supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Get Supabase auth instance
  static GoTrueClient get auth => Supabase.instance.client.auth;
}
