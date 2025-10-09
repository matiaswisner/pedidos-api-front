import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/payment_screen.dart';

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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6EC1E4),
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      // 🔹 Pantalla inicial
      initialRoute: '/login',

      // 🔹 Rutas principales
      routes: {
        '/login': (_) => const LoginScreen(),
        '/orders': (_) => const OrdersScreen(),
        '/products': (_) => const ProductsScreen(categoryName: 'General'),
        '/cart': (_) => const CartScreen(),
        '/payment': (_) => const PaymentScreen(totalAmount: 0),
      },

      // 🔹 Control central de rutas con animaciones suaves
      onGenerateRoute: (settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/login':
            builder = (_) => const LoginScreen();
            break;
          case '/orders':
            builder = (_) => const OrdersScreen();
            break;
          case '/products':
            final args = settings.arguments as Map<String, dynamic>?;
            builder = (_) => ProductsScreen(
              categoryName: args?['categoryName'] ?? 'General',
            );
            break;
          case '/cart':
            builder = (_) => const CartScreen();
            break;
          case '/payment':
            final args = settings.arguments as Map<String, dynamic>?;
            builder = (_) => PaymentScreen(
              totalAmount: args?['totalAmount'] ?? 0,
            );
            break;
          default:
            builder = (_) => const LoginScreen();
        }

        // 🔹 Transición personalizada (fade + slide)
        return PageRouteBuilder(
          pageBuilder: (context, __, ___) => builder(context),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, animation, __, child) {
            var fade = Tween<double>(begin: 0, end: 1)
                .chain(CurveTween(curve: Curves.easeInOut));
            var slide = Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut));

            return FadeTransition(
              opacity: animation.drive(fade),
              child: SlideTransition(
                position: animation.drive(slide),
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
