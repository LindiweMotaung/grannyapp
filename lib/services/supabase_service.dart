import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
  }

  // Check if user is logged in
  static bool get isLoggedIn => client.auth.currentUser != null;
  
  // Get current user
  static User? get currentUser => client.auth.currentUser;
  
  // Get user role from metadata
  static String? get userRole {
    final user = currentUser;
    if (user == null) return null;
    return user.userMetadata?['role'] as String?;
  }
}
