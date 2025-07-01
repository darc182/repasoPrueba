import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostService {
  static final _client = Supabase.instance.client;

  static Future<String?> createPost({
    required String titulo,
    required String descripcion,
    required String ubicacion,
    required List imagenes, // Puede ser List<File> o List<XFile>
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final postRes = await _client.from('posts').insert({
      'user_id': user.id,
      'titulo': titulo,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
    }).select().single();
    final postId = postRes['id'] as String?;
    if (postId == null) return null;
    // Subir imágenes al bucket y guardar URLs
    for (final img in imagenes) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${kIsWeb ? (img.name ?? 'web') : img.path.split('/').last}';
      try {
        if (kIsWeb) {
          // img es XFile en web
          final bytes = await img.readAsBytes();
          await _client.storage.from('fotos-sitios').uploadBinary('posts/$postId/$fileName', bytes);
        } else {
          // img es File en móvil
          await _client.storage.from('fotos-sitios').upload('posts/$postId/$fileName', img);
        }
        final url = _client.storage.from('fotos-sitios').getPublicUrl('posts/$postId/$fileName');
        await _client.from('post_photos').insert({
          'post_id': postId,
          'url': url,
        });
      } catch (e) {
        // Manejo de error: puedes mostrar un mensaje o continuar
        continue;
      }
    }
    return postId;
  }

  static Future<List<Map<String, dynamic>>> getPosts() async {
    final res = await _client.from('posts').select('*, post_photos(url)').order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }
}
