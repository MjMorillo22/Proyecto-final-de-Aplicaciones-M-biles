import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String _baseUrl = 'https://uasdapi.ia3x.com';

  Future<String?> getAuthToken(String username, String password) async {
    try {
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('authToken');
      String? tokenExpiresOn = preferences.getString('tokenExpiresOn');

      if (token == null || tokenExpiresOn == null) {
        return await _fetchAndStoreToken(username, password);
      } else {
        final expiresOn = DateTime.parse(tokenExpiresOn);
        if (expiresOn.isBefore(DateTime.now())) {
          return await _fetchAndStoreToken(username, password);
        } else {
          return token;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<String?> _fetchAndStoreToken(String username, String password) async {
    try {
      final url = Uri.parse('$_baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        String expiresOn = data['expiresOn']; // Assuming API returns this field.

        final SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('authToken', token);
        await preferences.setString('tokenExpiresOn', expiresOn);

        return token;
      } else {
        if (kDebugMode) {
          print('Error ${response.statusCode}: ${response.body}');
        }
        return null;
      }
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
