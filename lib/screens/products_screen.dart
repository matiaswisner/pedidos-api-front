import 'package:flutter/material.dart';
import 'cart_screen.dart';

class GlobalCart {
  static String? businessName;
  static final List<Map<String, dynamic>> items = [];

  static void clear() {
    businessName = null;
    items.clear();
  }

  static double get total =>
      items.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
}

class ProductsScreen extends StatefulWidget {
  final String categoryName;

  const ProductsScreen({super.key, required this.categoryName});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Productos simulados
  final List<Map<String, dynamic>> _allProducts = [
    {'name': 'Pan Francés', 'price': 1200.0, 'image': Icons.bakery_dining},
    {'name': 'Medialunas', 'price': 1800.0, 'image': Icons.coffee},
    {'name': 'Factura Mixta', 'price': 2000.0, 'image': Icons.local_cafe},
    {'name': 'Pan Integral', 'price': 1500.0, 'image': Icons.breakfast_dining},
    {'name': 'Tostadas Artesanales', 'price': 1300.0, 'image': Icons.restaurant},
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
          product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    // Si no hay carrito activo, inicia con el negocio actual
    if (GlobalCart.businessName == null) {
      GlobalCart.businessName = widget.categoryName;
    }

    // Si el carrito pertenece a otro negocio, mostrar alerta
    if (GlobalCart.businessName != widget.categoryName) {
      _showBusinessDialog(product);
      return;
    }

    // Agrega el producto
    final existing = GlobalCart.items.firstWhere(
          (item) => item['name'] == product['name'],
      orElse: () => {},
    );

    if (existing.isNotEmpty) {
      existing['quantity'] += 1;
    } else {
      GlobalCart.items.add({
        'name': product['name'],
        'price': product['price'],
        'quantity': 1,
        'icon': product['image'],
      });
    }

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} agregado al carrito'),
        backgroundColor: const Color(0xFF6EC1E4),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _showBusinessDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Carrito activo en otro negocio'),
        content: Text(
          'Tu carrito actual es de "${GlobalCart.businessName}".\n'
              '¿Querés vaciarlo y comenzar uno nuevo con "${widget.categoryName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mantener carrito'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              GlobalCart.clear();
              GlobalCart.businessName = widget.categoryName;
              _addToCart(product);
            },
            child: const Text('Vaciar y cambiar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = {
      'celeste': const Color(0xFF6EC1E4),
      'blanco': Colors.white,
      'dorado': const Color(0xFFFFD700),
      'rojoFederal': const Color(0xFFCE2B37),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: colors['celeste'],
        elevation: 6,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors['celeste']!, colors['blanco']!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Buscador
            TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colors['blanco'],
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors['celeste']!, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: colors['celeste']!.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🧾 Lista de productos
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: colors['blanco'],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: colors['celeste']!.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: colors['celeste']!.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colors['dorado'],
                        child: Icon(product['image'], color: colors['celeste']),
                      ),
                      title: Text(
                        product['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors['celeste'],
                        ),
                      ),
                      subtitle: Text(
                        '\$${product['price'].toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart,
                            color: colors['rojoFederal']),
                        onPressed: () => _addToCart(product),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 🛒 Botón inferior (ir al carrito)
      bottomNavigationBar: GlobalCart.items.isEmpty
          ? null
          : AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors['blanco'],
          boxShadow: [
            BoxShadow(
              color: colors['celeste']!.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${GlobalCart.items.length} ítem(s) • \$${GlobalCart.total.toStringAsFixed(2)}',
              style: TextStyle(
                color: colors['celeste'],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart_checkout,
                  color: Colors.white),
              label: const Text('Finalizar compra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors['rojoFederal'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 700),
                    pageBuilder: (_, __, ___) => const CartScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: animation, curve: Curves.easeInOut)),
                            child: child,
                          ),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
