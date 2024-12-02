import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://uasdapi.ia3x.com';

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/login'); // Endpoint para login
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Decodifica la respuesta
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          return {'success': true, 'token': data['token']};
        } else {
          return {'success': false, 'message': 'Token no encontrado en la respuesta.'};
        }
      } else {
        return {'success': false, 'message': 'Error ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de red: $e'};
    }
  }
}
