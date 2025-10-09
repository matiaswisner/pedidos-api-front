import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cart = [];

  void addToCart(Map<String, dynamic> product) {
    final index =
    _cart.indexWhere((item) => item['id'] == product['id']);
    if (index != -1) {
      setState(() => _cart[index]['quantity']++);
    } else {
      setState(() => _cart.add({
        'id': product['id'],
        'name': product['name'],
        'price': product['price'],
        'quantity': 1,
      }));
    }
  }

  void removeFromCart(int index) {
    setState(() {
      if (_cart[index]['quantity'] > 1) {
        _cart[index]['quantity']--;
      } else {
        _cart.removeAt(index);
      }
    });
  }

  double get totalPrice {
    return _cart.fold(
      0.0,
          (sum, item) =>
      sum + (item['price'] as num) * (item['quantity'] as num),
    );
  }

  Future<void> sendOrder() async {
    if (_cart.isEmpty) return;

    final orderData = {
      "customerId": 1, // 🔹 reemplazar por el ID real del cliente si aplica
      "items": _cart
          .map((item) => {
        "productId": item['id'],
        "quantity": item['quantity'],
      })
          .toList(),
      "paymentMethod": "CASH"
    };

    try {
      final success = await ApiService.createOrder(orderData);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pedido enviado correctamente',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        setState(() => _cart.clear());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentScreen(totalAmount: totalPrice),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error al enviar el pedido',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFFCC2222),
          ),
        );
      }
    } catch (e) {
      print('Error al crear pedido: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error de conexión con el servidor',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFFCC2222),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = {
      'celeste': const Color(0xFF6EC1E4),
      'rojoFederal': const Color(0xFFCC2222),
      'blanco': Colors.white,
      'dorado': const Color(0xFFFFD700),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        backgroundColor: colors['celeste'],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6EC1E4), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _cart.isEmpty
            ? const Center(
          child: Text('Tu carrito está vacío'),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _cart.length,
          itemBuilder: (context, index) {
            final item = _cart[index];
            return Card(
              elevation: 3,
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
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                subtitle: Text(
                  '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                  style:
                  const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => removeFromCart(index),
                    ),
                    Text('${item['quantity']}'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => addToCart(item),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors['blanco'],
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003366),
              ),
            ),
            ElevatedButton.icon(
              onPressed: sendOrder,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors['rojoFederal'],
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
