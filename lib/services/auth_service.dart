import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final _client = SupabaseService.client;

  // Admin login
  Future<AuthResponse> adminLogin(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // Verify admin role
      final role = response.user?.userMetadata?['role'];
      if (role != 'admin') {
        await _client.auth.signOut();
        throw Exception('Access denied. Admin credentials required.');
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Visitor/Resident registration
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
    required String role, // 'visitor' or 'resident'
    String? phone,
    int? age,
    String? gender,
    String? relationship,
    String? residentId,
  }) async {
    try {
      // Create auth user
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'role': role,
          'full_name': fullName,
          'phone': phone ?? '',
        },
      );

      if (response.user == null) {
        throw Exception('Registration failed');
      }

      // If resident, create resident record
      if (role == 'resident' && age != null && gender != null) {
        try {
          await _client.from('residents').insert({
            'id': response.user!.id,
            'name': fullName,
            'age': age,
            'gender': gender,
            'room_number': 'TBD',
            'medical_conditions': '',
            'emergency_contact': fullName,
            'emergency_phone': phone ?? '',
            'admission_date': DateTime.now().toIso8601String().split('T')[0],
            'status': 'active',
          });
        } catch (e) {
          // If resident insert fails, silently continue (user is still created in auth)
          // Could also delete the auth user here if you want atomic transaction
        }
      }

      // If visitor, create family link if residentId provided
      if (role == 'visitor' && residentId != null && relationship != null) {
        await _client.from('resident_family_links').insert({
          'resident_id': residentId,
          'visitor_id': response.user!.id,
          'relationship': relationship,
        });
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Login for visitor/resident
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // Verify not admin
      final role = response.user?.userMetadata?['role'];
      if (role == 'admin') {
        await _client.auth.signOut();
        throw Exception('Please use admin login.');
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // Check if logged in
  bool isLoggedIn() {
    return _client.auth.currentUser != null;
  }

  // Get current user role
  String? getUserRole() {
    return _client.auth.currentUser?.userMetadata?['role'];
  }
}
