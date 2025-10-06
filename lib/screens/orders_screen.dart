import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'business_list_screen.dart'; // 🆕 reemplaza al import anterior de products_screen.dart

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Almacén', 'icon': Icons.store, 'color': Colors.blueAccent},
      {'name': 'Kiosco', 'icon': Icons.local_convenience_store, 'color': Colors.teal},
      {'name': 'Ropa', 'icon': Icons.checkroom, 'color': Colors.purple},
      {'name': 'Verdulería', 'icon': Icons.eco, 'color': Colors.green},
      {'name': 'Panadería', 'icon': Icons.bakery_dining, 'color': Colors.amber},
      {'name': 'Farmacia', 'icon': Icons.local_pharmacy, 'color': Colors.indigo}, // 🆕 ejemplo extra
      {'name': 'Delivery', 'icon': Icons.delivery_dining, 'color': Colors.redAccent},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Negocios'),
        backgroundColor: const Color(0xFF6EC1E4),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              // 🧩 Confirmación antes de salir
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('¿Deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            pageBuilder: (_, __, ___) => const LoginScreen(),
                            transitionsBuilder: (_, animation, __, child) =>
                                FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: const Text('Sí'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6EC1E4), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 🔍 Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: '¿Qué estás buscando?',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 📋 Lista de categorías
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: category['color'],
                          child: Icon(category['icon'], color: Colors.white),
                        ),
                        title: Text(
                          category['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003366),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          // 🆕 Navegación animada hacia BusinessListScreen
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 700),
                              pageBuilder: (_, __, ___) => BusinessListScreen(
                                categoryName: category['name'],
                              ),
                              transitionsBuilder: (_, animation, __, child) {
                                var fade = Tween<double>(begin: 0.0, end: 1.0)
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
                            ),
                          );

                          // Muestra una notificación rápida
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Abriendo ${category['name']}...',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: category['color'],
                              duration: const Duration(milliseconds: 800),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCC2222), // Rojo Federal
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Nuevo negocio agregado',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFFCC2222),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
