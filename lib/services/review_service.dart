import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  static final _client = Supabase.instance.client;

  static Future<void> addReview({
    required String postId,
    required String contenido,
    required int calificacion,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    await _client.from('reviews').insert({
      'post_id': postId,
      'user_id': user.id,
      'contenido': contenido,
      'calificacion': calificacion,
    });
  }

  static Future<List<Map<String, dynamic>>> getReviews(String postId) async {
    final res = await _client
        .from('reviews')
        .select('*, review_replies(*, profiles(nombre, avatar_url))')
        .eq('post_id', postId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  static Future<void> addReply({
    required String reviewId,
    required String contenido,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    await _client.from('review_replies').insert({
      'review_id': reviewId,
      'user_id': user.id,
      'contenido': contenido,
    });
  }
}
