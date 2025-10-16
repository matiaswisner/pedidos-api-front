//products_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String categoryName;

  const ProductsScreen({super.key, required this.categoryName});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final data = await ApiService.getProducts();
      setState(() {
        // Filtrar productos por categoría si la API devuelve ese campo
        products = List<Map<String, dynamic>>.from(data).where((p) {
          return (p['category'] ?? '') == widget.categoryName;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar productos: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = {
      'celeste': const Color(0xFF6EC1E4),
      'blanco': Colors.white,
      'rojoFederal': const Color(0xFFCC2222),
      'dorado': const Color(0xFFFFD700),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: colors['celeste'],
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Ver carrito',
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (_, __, ___) => const CartScreen(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
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
            : products.isEmpty
            ? const Center(child: Text('No hay productos disponibles'))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: colors['celeste'],
                  child: const Icon(Icons.shopping_bag,
                      color: Colors.white),
                ),
                title: Text(
                  product['name'] ?? 'Producto sin nombre',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                subtitle: Text(
                  '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
                trailing:
                const Icon(Icons.add_shopping_cart, size: 22),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product['name']} agregado al carrito',
                        style:
                        const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: colors['rojoFederal'],
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
