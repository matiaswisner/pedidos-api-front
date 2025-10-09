import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'CASH';

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
        title: const Text('Pago'),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Total a pagar:',
                style: TextStyle(
                  fontSize: 20,
                  color: colors['rojoFederal'],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${widget.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 28,
                  color: colors['dorado'],
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Seleccioná el método de pago',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              _buildPaymentOption('CASH', 'Efectivo', Icons.money),
              _buildPaymentOption('CARD', 'Tarjeta', Icons.credit_card),
              _buildPaymentOption('MP', 'Mercado Pago', Icons.account_balance),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Pago confirmado con $selectedMethod',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: colors['rojoFederal'],
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors['rojoFederal'],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirmar pago',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    return RadioListTile<String>(
      value: value,
      groupValue: selectedMethod,
      activeColor: const Color(0xFFCC2222),
      title: Text(label),
      secondary: Icon(icon, color: const Color(0xFF6EC1E4)),
      onChanged: (val) => setState(() => selectedMethod = val!),
    );
  }
}
