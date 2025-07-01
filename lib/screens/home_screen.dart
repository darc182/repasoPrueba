import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_profile_service.dart';
import '../services/post_service.dart';
import 'reviews_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sitios Turísticos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: PostService.getPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return const Center(child: Text('No hay sitios publicados aún.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              final post = posts[i];
              final fotos = post['post_photos'] as List<dynamic>?;
              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewsScreen(postId: post['id']),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['titulo'] ?? '', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(post['ubicacion'] ?? '', style: const TextStyle(color: Colors.teal)),
                        const SizedBox(height: 8),
                        if (fotos != null && fotos.isNotEmpty)
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: fotos.length,
                              itemBuilder: (context, j) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(
                                  fotos[j]['url'],
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(post['descripcion'] ?? ''),
                        const SizedBox(height: 8),
                        Text('Ver reseñas', style: TextStyle(color: Colors.teal[700], fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/publicar');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
