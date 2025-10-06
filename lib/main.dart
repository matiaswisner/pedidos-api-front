import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PedidosApp());
}

class PedidosApp extends StatelessWidget {
  const PedidosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pedidos App',
      theme: ThemeData(
        // 🎨 Paleta Federal Argentina
        primaryColor: const Color(0xFF6EC1E4), // Celeste bandera
        scaffoldBackgroundColor: Colors.white, // Fondo blanco
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFFD700), // Dorado del sol
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF003366), // Azul profundo
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
