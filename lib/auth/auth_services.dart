import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  String? getCurrentUserEmail() {
    return supabase.auth.currentUser?.email;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final response = await supabase
        .from('users')
        .select('name, email, foto, telepon')
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  // Sign Up
  Future<void> signUpWithEmailPassword(String name, String email, String password, String telepon) async {
    try {
      final response = await supabase.auth.signUp(email: email, password: password);
      if (response.user != null) {
        await supabase.from('users').insert({
          'id': response.user!.id,
          'name': name,
          'email': email,
          'telepon': telepon,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
    } catch (e) {
      throw Exception("Gagal mendaftar: $e");
    }
  }

  // Sign In
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(email: email, password: password);

      if (response.user == null) {
        throw Exception("Login gagal! Periksa email dan password.");
      }

      return response;
    } catch (e) {
      throw Exception("Error saat login: $e");
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception("Error saat logout: $e");
    }
  }

  // Get User
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
}
