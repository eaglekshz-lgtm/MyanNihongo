import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration
/// 
/// Loads credentials from .env file
/// You can find these in your Supabase project settings:
/// https://app.supabase.com/project/YOUR_PROJECT/settings/api
class SupabaseConfig {
  SupabaseConfig._();
  
  /// Your Supabase project URL
  /// Loaded from SUPABASE_URL in .env file
  static String get supabaseUrl => 
      dotenv.get('SUPABASE_URL', fallback: 'YOUR_SUPABASE_URL');
  
  /// Your Supabase anonymous key
  /// Loaded from SUPABASE_ANON_KEY in .env file
  /// This is safe to use in client-side code
  static String get supabaseAnonKey => 
      dotenv.get('SUPABASE_ANON_KEY', fallback: 'YOUR_SUPABASE_ANON_KEY');
  
  /// Check if Supabase is configured
  static bool get isConfigured =>
      supabaseUrl != 'YOUR_SUPABASE_URL' && 
      supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY';
}
