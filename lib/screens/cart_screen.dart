import 'package:flutter/material.dart';
import 'payment_screen.dart';
import 'products_screen.dart'; // para acceder a GlobalCart

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _increaseQuantity(int index) {
    setState(() => GlobalCart.items[index]['quantity']++);
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (GlobalCart.items[index]['quantity'] > 1) {
        GlobalCart.items[index]['quantity']--;
      } else {
        GlobalCart.items.removeAt(index);
        if (GlobalCart.items.isEmpty) GlobalCart.businessName = null;
      }
    });
  }

  double get total => GlobalCart.total;

  @override
  Widget build(BuildContext context) {
    final colors = {
      'celeste': const Color(0xFF6EC1E4),
      'blanco': Colors.white,
      'dorado': const Color(0xFFFFD700),
      'rojoFederal': const Color(0xFFCC2222),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrito de compras',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colors['celeste'],
        elevation: 5,
        actions: [
          if (GlobalCart.items.isNotEmpty)
            IconButton(
              tooltip: 'Vaciar carrito',
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Vaciar carrito'),
                    content: const Text(
                        '¿Seguro que querés eliminar todos los productos del carrito?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            GlobalCart.clear();
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('Vaciar'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6EC1E4), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GlobalCart.items.isEmpty
            ? const Center(
          child: Text(
            'Tu carrito está vacío 🛒',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF003366),
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: GlobalCart.items.length,
          itemBuilder: (context, index) {
            final item = GlobalCart.items[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: colors['blanco'],
                borderRadius: BorderRadius.circular(12),
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
                  child: Icon(item['icon'], color: colors['celeste']),
                ),
                title: Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                subtitle: Text(
                  '\$${item['price'].toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.black87),
                ),
                trailing: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: colors['rojoFederal'],
                        onPressed: () => _decreaseQuantity(index),
                      ),
                      Text(
                        '${item['quantity']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: colors['celeste'],
                        onPressed: () => _increaseQuantity(index),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: GlobalCart.items.isEmpty
          ? null
          : AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: colors['blanco'],
          boxShadow: [
            BoxShadow(
              color: colors['celeste']!.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors['celeste'],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors['rojoFederal'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration:
                    const Duration(milliseconds: 700),
                    pageBuilder: (_, __, ___) => const PaymentScreen(),
                    transitionsBuilder:
                        (_, animation, __, child) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                'Ir al pago',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
