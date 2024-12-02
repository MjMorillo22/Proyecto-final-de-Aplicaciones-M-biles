import 'package:flutter/material.dart';
import 'package:uasdfinal/pages/login/ResetPasswordPage.dart';
import 'package:uasdfinal/pages/login/changepassword.dart';
import '/services/api_service.dart';

class RecuperarContrasenaPage extends StatelessWidget {
  final ApiService apiService;

  RecuperarContrasenaPage({required this.apiService});

  Widget _buildMenuOption(
      String title, IconData icon, VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Contraseña')),
      body: ListView(
        children: [
          _buildMenuOption(
            'Cambiar a Contraseña Genérica',
            Icons.lock_reset,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ResetPasswordPage(apiService: apiService),
                ),
              );
            },
          ),         
        ],
      ),
    );
  }
}
