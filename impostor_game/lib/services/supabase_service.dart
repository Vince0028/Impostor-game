import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    await dotenv.load(fileName: ".env");

    // Note: VITE_ prefix is from web templates, but we can read them directly
    final supabaseUrl = dotenv.env['VITE_SUPABASE_URL'] ?? '';
    final supabaseKey = dotenv.env['VITE_SUPABASE_ANON_KEY'] ?? '';

    if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
      throw Exception('Supabase credentials not found in .env');
    }

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  }

  SupabaseClient get client => Supabase.instance.client;

  // Sign Up
  Future<AuthResponse> signUp(
    String email,
    String password,
    String username,
  ) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
      emailRedirectTo: 'io.supabase.impostorgame://login-callback',
    );
  }

  // Sign In
  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign Out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  // Update User (Password/Metadata)
  Future<UserResponse> updateUser({String? password, String? username}) async {
    final attributes = UserAttributes(
      password: password,
      data: username != null ? {'username': username} : null,
    );
    return await client.auth.updateUser(attributes);
  }
}
