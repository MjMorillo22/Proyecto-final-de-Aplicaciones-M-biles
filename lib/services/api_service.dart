import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://uasdapi.ia3x.com';
  String? _authToken; // Store the token

  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      // Extract and save the token correctly
      _authToken = data['data']['authToken'];
      return data;
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  // Obtener información del usuario
  Future<Map<String, dynamic>> fetchUserInfo() async {
    if (_authToken == null) {
      throw Exception('Unauthorized: No token found');
    }

    final response = await _authenticatedGet('/info_usuario');
    if (response['success'] == true) {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch user info.');
    }
  }

  // Reset Password
  Future<void> resetPassword(String username, String email) async {
    final url = Uri.parse('$baseUrl/reset_password');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "usuario": username,
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (!responseData['success']) {
        throw Exception('Failed to reset password: ${responseData['message']}');
      }
    } else {
      throw Exception('Failed to reset password: ${response.reasonPhrase}');
    }
  }

  // Change Password
  Future<void> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    if (_authToken == null) {
      throw Exception('Unauthorized: No token found');
    }

    final url = Uri.parse('$baseUrl/cambiar_password');
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_authToken", // Asegúrate de incluir el token aquí
        "Content-Type": "application/json",
      },
      body: json.encode({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to change password: ${response.reasonPhrase}, Body: ${response.body}');
    }
  }

  void logout() {
    _authToken = null; // Clear stored token or session
  }

  // Create User
  Future<void> createUser(String nombre, String apellido, String username, String password, String email) async {
    final url = Uri.parse('$baseUrl/crear_usuario');
    final payload = {
      "id": 0,
      "nombre": nombre,
      "apellido": apellido,
      "username": username,
      "password": password,
      "email": email,
    };

    print('Request URL: $url');
    print('Request Body: $payload');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(payload),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('Usuario creado exitosamente');
        } else {
          throw Exception('Error al crear usuario: ${data['message']}');
        }
      } else {
        throw Exception('Error al crear usuario: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
      throw e;
    }
  }




  // Noticias
  Future<Map<String, dynamic>> fetchNoticias() async {
    return await _authenticatedGet('/noticias');
  }

  // Horarios
  // Horarios
  Future<List<dynamic>> fetchHorarios() async {
    if (_authToken == null) {
      throw Exception('Unauthorized: No token found');
    }

    final url = Uri.parse('$baseUrl/horarios');
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $_authToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Ensure response is parsed as a list
      return json.decode(response.body) as List<dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to fetch horarios: ${response.reasonPhrase}');
    }
  }

  // Preseleccionar Materia
  Future<void> preseleccionarMateria(String codigoMateria) async {
    await _authenticatedPostRaw('/preseleccionar_materia', '"$codigoMateria"');
  }

  // Fetch Preseleccion
  Future<List<dynamic>> fetchPreseleccion() async {
    final response = await _authenticatedGet('/ver_preseleccion');
    if (response is Map && response['success'] == true) {
      return response['data'] ?? [];
    } else {
      throw Exception('Failed to fetch preselección');
    }
  }


    // Cancelar Preseleccion Materia
  Future<void> cancelarPreseleccionMateria(String codigo) async {
    await _authenticatedPostRaw('/cancelar_preseleccion_materia', '"$codigo"');
  }


  // Materias Disponibles para Preselección
  Future<List<dynamic>> fetchMateriasDisponibles() async {
    final response = await _authenticatedGet('/materias_disponibles');

    if (response is List) {
      return response as List<dynamic>;
    } else {
      throw Exception('Unexpected response format for materias disponibles');
    }
  }


  // Enviar Preselección
  Future<void> enviarPreseleccion(List<String> materiasSeleccionadas) async {
  if (materiasSeleccionadas.isEmpty) {
    throw Exception('No materias selected for preselection');
  }

  for (String codigo in materiasSeleccionadas) {
    try {
      print('Sending preselection for: $codigo');
      await _authenticatedPostRaw('/preseleccionar_materia', json.encode(codigo));
      print('Successfully preselected: $codigo');
    } catch (e) {
      print('Failed to preselect $codigo: $e');
      throw Exception('Error sending preselection for $codigo');
    }
  }
}

  // Deudas
  Future<List<dynamic>> fetchDeudas() async {
    final response = await _authenticatedGet('/deudas');
    if (response is List) {
      return response; // Ensure it's a list
    } else {
      throw Exception('Unexpected response format for deudas');
    }
  }

  // Solicitudes
  Future<Map<String, dynamic>> fetchSolicitudes() async {
    final response = await _authenticatedGet('/mis_solicitudes');
    if (response is Map<String, dynamic> && response['success'] == true) {
      return response;
    } else {
      throw Exception('Unexpected response format for solicitudes');
    }
  }


  // Fetch types of solicitudes
  Future<List<dynamic>> fetchTiposSolicitudes() async {
    final response = await _authenticatedGet('/tipos_solicitudes');
    if (response['success'] == true) {
      return response['data'] ?? []; // Extract 'data' or return an empty list
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch tipos de solicitudes.');
    }
  }

  // Crear Solicitud
  Future<void> crearSolicitud(String titulo, String descripcion, String tipo) async {
    final payload = {
      "titulo": titulo,
      "descripcion": descripcion,
      "tipo": tipo // Include tipo de solicitud
    };

    print('Sending solicitud creation payload: $payload');

    final response = await _authenticatedPost('/crear_solicitud', payload);

    if (response['success'] != true) {
      throw Exception('Failed to create solicitud: ${response['message']}');
    }

    print('Solicitud created successfully.');
  }

  // Cancelar Solicitud
  // Cancelar Solicitud
  Future<void> cancelarSolicitud(int solicitudId) async {
    final endpoint = '/cancelar_solicitud';
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_authToken",
        "Content-Type": "application/json",
      },
      body: json.encode(solicitudId), // Send the ID as raw body
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to cancel solicitud: ${response.reasonPhrase}, Body: ${response.body}',
      );
    }
  }

  // Fetch Tareas
  Future<List<Map<String, dynamic>>> fetchTareas() async {
    final response = await _authenticatedGet('/tareas');
    print('Raw Response: $response'); // Debugging line

    if (response is List) {
      // Parse each item in the response to ensure proper typing
      return List<Map<String, dynamic>>.from(response.map((e) => Map<String, dynamic>.from(e)));
    } else {
      throw Exception('Unexpected response format: Expected a list.');
    }
  }

  // Eventos
  Future<List<dynamic>> fetchEventos() async {
    return await _authenticatedGet('/eventos') as List<dynamic>;
  }

  // Videos
  Future<List<Map<String, dynamic>>> fetchVideos() async {
    final response = await _authenticatedGet('/videos');
    if (response is List) {
      // Safely convert response to a List of Maps
      return List<Map<String, dynamic>>.from(response);
    } else {
      throw Exception('Unexpected response format for videos');
    }
  }


  // Generic methods for authenticated GET requests
  Future<dynamic> _authenticatedGet(String endpoint) async {
    if (_authToken == null) {
      throw Exception('Unauthorized: No token found');
    }

    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $_authToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw Exception('Failed to parse JSON: ${response.body}');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to load $endpoint: ${response.reasonPhrase}');
    }
  }


  // Generic methods for authenticated POST requests
  Future<dynamic> _authenticatedPost(String endpoint, Map<String, dynamic> body) async {
    if (_authToken == null) {
      throw Exception('Unauthorized: No token found');
    }

    final url = Uri.parse('$baseUrl$endpoint');

    print('Request URL: $url');
    print('Request Headers: ${{
      "Authorization": "Bearer $_authToken",
      "Content-Type": "application/json",
    }}');
    print('Request Body: ${json.encode(body)}');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_authToken",
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception(
          'Failed to post to $endpoint: ${response.reasonPhrase}, Body: ${response.body}');
    }
  }

  Future<void> _authenticatedPostRaw(String endpoint, String body) async {
    if (_authToken == null) {
      throw Exception('Unauthorized: No token found');
    }

    final url = Uri.parse('$baseUrl$endpoint');
    print('Request URL: $url');
    print('Request Headers: ${{
      "Authorization": "Bearer $_authToken",
      "Content-Type": "application/json",
    }}');
    print('Request Body: $body');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_authToken",
        "Content-Type": "application/json",
      },
      body: body, // Send raw string
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      }
      throw Exception(
          'Failed to post to $endpoint: ${response.reasonPhrase}, Body: ${response.body}');
    }
  }
}
