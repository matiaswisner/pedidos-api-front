//api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// 🔹 Servicio de conexión con el backend (Pedidos API)
class ApiService {
  // 📡 Dirección base de tu backend (IP de tu PC en la red local)
  static const String baseUrl = 'http://192.168.100.5:8080';

  /// 🧩 Función genérica para manejar respuestas HTTP
  static dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      // ✅ Éxito
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if (status == 400) {
      throw Exception("❌ Error 400: Solicitud incorrecta.");
    } else if (status == 404) {
      throw Exception("❌ Error 404: Recurso no encontrado.");
    } else if (status == 500) {
      throw Exception("💥 Error 500: Error interno del servidor.");
    } else {
      throw Exception("⚠️ Error inesperado (${response.statusCode}).");
    }
  }

  /// 🔹 Obtener lista de productos
  static Future<List<dynamic>> getProducts() async {
    final url = Uri.parse('$baseUrl/api/products');

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      throw Exception("🌐 No hay conexión a internet o el servidor no responde.");
    } on HttpException {
      throw Exception("⚙️ Error al procesar la solicitud HTTP.");
    } on FormatException {
      throw Exception("📦 Error al interpretar la respuesta del servidor.");
    }
  }

  /// 🔹 Obtener lista de negocios
  static Future<List<dynamic>> getBusinesses() async {
    final url = Uri.parse('$baseUrl/api/businesses');

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Error al obtener negocios: $e");
    }
  }

  /// 🔹 Crear un pedido
  static Future<bool> createOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/api/orders');

    try {
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('❌ Error al crear pedido: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print("🚨 Excepción al crear pedido: $e");
      return false;
    }
  }

  /// 🔹 Verificar conexión al servidor
  static Future<bool> checkServerConnection() async {
    final url = Uri.parse('$baseUrl/api/users');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
