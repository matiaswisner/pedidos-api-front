import 'package:flutter/material.dart';
import 'orders_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;

  final List<Map<String, dynamic>> _methods = [
    {'name': 'Efectivo', 'icon': Icons.payments_outlined, 'color': Colors.green},
    {'name': 'Mercado Pago', 'icon': Icons.account_balance_wallet_outlined, 'color': Colors.lightBlue},
    {'name': 'Tarjeta de crédito', 'icon': Icons.credit_card, 'color': Colors.orange},
  ];

  void _confirmPayment() {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccioná un método de pago'),
          backgroundColor: Color(0xFFCC2222),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const _PaymentSuccessScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
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
  }

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
          'Método de pago',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colors['celeste'],
        elevation: 5,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Seleccioná tu método de pago preferido:',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF003366),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // 🔘 Lista de métodos de pago
            Expanded(
              child: ListView.builder(
                itemCount: _methods.length,
                itemBuilder: (context, index) {
                  final method = _methods[index];
                  final isSelected = _selectedMethod == method['name'];

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors['blanco']!.withOpacity(0.9)
                          : colors['blanco'],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? colors['celeste']!
                            : colors['celeste']!.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors['celeste']!.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: method['color'],
                        child: Icon(method['icon'], color: Colors.white),
                      ),
                      title: Text(
                        method['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003366),
                        ),
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? colors['celeste']
                            : Colors.grey.shade400,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedMethod = method['name'];
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // 💳 Botón Confirmar pago
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors['rojoFederal'],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _confirmPayment,
              child: const Text(
                'Confirmar pago',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ✅ Pantalla de confirmación de pago
class _PaymentSuccessScreen extends StatelessWidget {
  const _PaymentSuccessScreen();

  @override
  Widget build(BuildContext context) {
    final colors = {
      'celeste': const Color(0xFF6EC1E4),
      'blanco': Colors.white,
      'dorado': const Color(0xFFFFD700),
      'rojoFederal': const Color(0xFFCC2222),
    };

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6EC1E4), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 100, color: colors['dorado']),
              const SizedBox(height: 20),
              const Text(
                '¡Pago confirmado!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tu pedido está siendo procesado.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors['celeste'],
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 700),
                      pageBuilder: (_, __, ___) => const OrdersScreen(),
                      transitionsBuilder: (_, animation, __, child) =>
                          FadeTransition(
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
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
