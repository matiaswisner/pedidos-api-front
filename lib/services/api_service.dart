// 📁 lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080'; // cambia si usas otro host

  // 🔹 Obtener lista de productos
  static Future<List<dynamic>> getProducts() async {
    final url = Uri.parse('$baseUrl/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener productos (${response.statusCode})');
    }
  }

  // 🔹 Obtener lista de negocios (categorías)
  static Future<List<dynamic>> getBusinesses() async {
    final url = Uri.parse('$baseUrl/businesses');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener negocios (${response.statusCode})');
    }
  }

  // 🔹 Crear pedido
  static Future<bool> createOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Error al crear pedido: ${response.statusCode}');
      return false;
    }
  }
}
