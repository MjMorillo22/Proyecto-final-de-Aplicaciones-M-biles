import 'package:flutter/material.dart';
import 'package:uasdfinal/pages/login/login_page.dart';
import 'package:uasdfinal/pages/login/changepassword.dart';
import '/services/api_service.dart';

class UserInfoPage extends StatelessWidget {
  final ApiService apiService;

  UserInfoPage({required this.apiService});

  Future<Map<String, dynamic>> _fetchUserInfo() async {
    return await apiService.fetchUserInfo();
  }

  void _logout(BuildContext context) {
    apiService.logout(); // Clear any session tokens
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Usuario'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userInfo = snapshot.data ?? {};
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre: ${userInfo['nombre'] ?? 'No disponible'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text('Apellido: ${userInfo['apellido'] ?? 'No disponible'}'),
                  SizedBox(height: 10),
                  Text('Usuario: ${userInfo['username'] ?? 'No disponible'}'),
                  SizedBox(height: 10),
                  Text('Correo: ${userInfo['email'] ?? 'No disponible'}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangePasswordPage(apiService: apiService),
                        ),
                      );
                    },
                    child: Text('Cambiar Contraseña'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
