import 'package:flutter/material.dart';
import 'package:repaso_prueba/theme/app_theme.dart';
import 'package:repaso_prueba/services/supabase_service.dart';
import 'package:repaso_prueba/screens/auth_screen.dart';
import 'package:repaso_prueba/screens/splash_screen.dart';
import 'package:repaso_prueba/screens/home_screen.dart';
import 'package:repaso_prueba/screens/visitante_screen.dart';
import 'package:repaso_prueba/screens/publicar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/visitante': (context) => const VisitanteScreen(),
        '/publicar': (context) => const PublicarScreen(),
      },
    );
  }
}
