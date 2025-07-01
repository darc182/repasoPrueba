import 'package:flutter/material.dart';
import '../services/review_service.dart';

class ReviewsScreen extends StatefulWidget {
  final String postId;
  const ReviewsScreen({super.key, required this.postId});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _reviewController = TextEditingController();
  int _calificacion = 5;
  String? _error;

  Future<void> _addReview() async {
    if (_reviewController.text.isEmpty) {
      setState(() => _error = 'Escribe una reseña.');
      return;
    }
    await ReviewService.addReview(
      postId: widget.postId,
      contenido: _reviewController.text,
      calificacion: _calificacion,
    );
    _reviewController.clear();
    setState(() => _error = null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reseñas del sitio')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ReviewService.getReviews(widget.postId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reviews = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Agrega tu reseña:', style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: i <= _calificacion ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () => setState(() => _calificacion = i),
                    ),
                ],
              ),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(labelText: 'Escribe tu reseña'),
                maxLines: 2,
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              ElevatedButton(
                onPressed: _addReview,
                child: const Text('Publicar reseña'),
              ),
              const Divider(height: 32),
              ...reviews.map((r) => Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              for (int i = 1; i <= 5; i++)
                                Icon(Icons.star,
                                    color: i <= (r['calificacion'] ?? 0) ? Colors.amber : Colors.grey, size: 18),
                            ],
                          ),
                          Text(r['contenido'] ?? ''),
                          const SizedBox(height: 8),
                          if (r['review_replies'] != null && (r['review_replies'] as List).isNotEmpty)
                            ...List.generate((r['review_replies'] as List).length, (j) {
                              final reply = r['review_replies'][j];
                              return Padding(
                                padding: const EdgeInsets.only(left: 16, top: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.reply, size: 16, color: Colors.teal),
                                    const SizedBox(width: 4),
                                    Text(reply['contenido'] ?? '', style: const TextStyle(color: Colors.teal)),
                                  ],
                                ),
                              );
                            }),
                          TextButton(
                            onPressed: () async {
                              final controller = TextEditingController();
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Responder reseña'),
                                  content: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(labelText: 'Respuesta'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await ReviewService.addReply(
                                          reviewId: r['id'],
                                          contenido: controller.text,
                                        );
                                        Navigator.pop(ctx);
                                        setState(() {});
                                      },
                                      child: const Text('Responder'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Responder', style: TextStyle(color: Colors.teal)),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
