import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repaso_prueba/services/post_service.dart';

class PublicarScreen extends StatefulWidget {
  const PublicarScreen({super.key});

  @override
  State<PublicarScreen> createState() => _PublicarScreenState();
}

class _PublicarScreenState extends State<PublicarScreen> {
  final _tituloController = TextEditingController();
  final _descController = TextEditingController();
  final _ubicacionController = TextEditingController();
  List<XFile> _imagenes = [];
  final ImagePicker _picker = ImagePicker();
  String? _error;

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage(imageQuality: 80);
    if ((kIsWeb && images.isNotEmpty) || images.length >= 5) {
      setState(() {
        _imagenes = kIsWeb ? images : images.take(5).toList();
        _error = null;
      });
    } else {
      setState(() => _error = kIsWeb
          ? 'Debes seleccionar al menos 1 imagen en web.'
          : 'Debes seleccionar al menos 5 imágenes.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicar sitio turístico')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ubicacionController,
              decoration: const InputDecoration(labelText: 'Ubicación'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.photo_library),
              label: const Text('Seleccionar imágenes (mínimo 5)'),
            ),
            const SizedBox(height: 8),
            if (_imagenes.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagenes.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: kIsWeb
                        ? FutureBuilder<Uint8List?>(
                            future: _imagenes[i].readAsBytes(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return const SizedBox(width: 100, child: Center(child: CircularProgressIndicator()));
                              return Image.memory(
                                snapshot.data!,
                                width: 100,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.file(
                            File(_imagenes[i].path),
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if ((kIsWeb && _imagenes.isEmpty) || (!kIsWeb && _imagenes.length < 5)) {
                    setState(() => _error = kIsWeb
                        ? 'Debes seleccionar al menos 1 imagen en web.'
                        : 'Debes seleccionar al menos 5 imágenes.');
                    return;
                  }
                  setState(() => _error = null);
                  try {
                    final postId = await PostService.createPost(
                      titulo: _tituloController.text,
                      descripcion: _descController.text,
                      ubicacion: _ubicacionController.text,
                      imagenes: kIsWeb
                          ? _imagenes // XFile en web
                          : _imagenes.map((x) => File(x.path)).toList(),
                    );
                    if (postId != null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Sitio publicado exitosamente!'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      Navigator.pop(context, true); // Indicamos éxito al volver
                    } else {
                      setState(() => _error = 'Error al publicar.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al publicar el sitio.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() => _error = 'Error inesperado al publicar.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error inesperado al publicar.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text('Publicar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
