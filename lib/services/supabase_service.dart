import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://ryfakjzylnhkvbdnzkby.supabase.co', // Reemplaza con tu URL de Supabase
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ5ZmFranp5bG5oa3ZiZG56a2J5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgyOTcyNzQsImV4cCI6MjA2Mzg3MzI3NH0.xrCwVhfGTkIqg8h_ud39Y8kMxppMFsKMSwh-imrlgME', // Reemplaza con tu anon key
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
