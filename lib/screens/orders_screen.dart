import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'products_screen.dart';
import '../services/api_service.dart'; // 🆕 Import del servicio HTTP

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> businesses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusinesses();
  }

  Future<void> _loadBusinesses() async {
    try {
      final data = await ApiService.getBusinesses();
      setState(() {
        businesses = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar negocios: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = {
      'celeste': const Color(0xFF6EC1E4),
      'blanco': Colors.white,
      'rojoFederal': const Color(0xFFCC2222),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Negocios'),
        backgroundColor: colors['celeste'],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
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
                            transitionDuration:
                            const Duration(milliseconds: 600),
                            pageBuilder: (_, __, ___) => const LoginScreen(),
                            transitionsBuilder:
                                (_, animation, __, child) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : businesses.isEmpty
            ? const Center(child: Text('No hay negocios disponibles'))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: businesses.length,
          itemBuilder: (context, index) {
            final business = businesses[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: colors['celeste'],
                  child: const Icon(Icons.store, color: Colors.white),
                ),
                title: Text(
                  business['name'] ?? 'Negocio sin nombre',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                subtitle: Text(
                  business['category'] ?? 'Sin categoría',
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing:
                const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration:
                      const Duration(milliseconds: 700),
                      pageBuilder: (_, __, ___) => ProductsScreen(
                        categoryName: business['name'],
                      ),
                      transitionsBuilder: (_, animation, __, child) {
                        var fade = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).chain(CurveTween(curve: Curves.easeInOut));
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
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors['rojoFederal'],
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
