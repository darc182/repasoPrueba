import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  static Future<void> assignRole(String userId, String role) async {
    await Supabase.instance.client.from('profiles').upsert({
      'id': userId,
      'role': role,
    });
  }

  static Future<String?> getRole(String userId) async {
    final res = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .single();
    return res['role'] as String?;
  }
}
