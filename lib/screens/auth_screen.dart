import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../services/user_profile_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String? _error;
  bool _loading = false;
  String _selectedRole = 'visitante';

  Future<void> _auth() async {
    setState(() => _loading = true);
    try {
      if (_isLogin) {
        final res = await SupabaseService.client.auth.signInWithPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (res.session != null) {
          final userId = res.user?.id;
          if (userId != null) {
            final role = await UserProfileService.getRole(userId);
            if (!mounted) return;
            if (role == 'publicador') {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              Navigator.pushReplacementNamed(context, '/visitante');
            }
          }
        }
      } else {
        final res = await SupabaseService.client.auth.signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );
        final userId = res.user?.id;
        if (userId != null) {
          await UserProfileService.assignRole(userId, _selectedRole);
        }
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? 'Iniciar Sesión' : 'Registrarse',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              if (!_isLogin) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de perfil',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'visitante',
                      child: Text('Visitante (solo visualiza y reseña)'),
                    ),
                    DropdownMenuItem(
                      value: 'publicador',
                      child: Text('Publicador (puede publicar y gestionar)'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedRole = v ?? 'visitante'),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _loading ? null : _auth,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isLogin ? 'Entrar' : 'Registrarse'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin
                    ? '¿No tienes cuenta? Regístrate'
                    : '¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
