import 'package:flutter/material.dart';
import 'package:uasdfinal/pages/login/login_page.dart';
import 'package:uasdfinal/services/api_service.dart';

class SalirPage extends StatelessWidget {
  final ApiService apiService; // Optionally pass ApiService for cleanup

  // Constructor to accept ApiService if needed
  SalirPage({required this.apiService});

  void _cerrarSesion(BuildContext context) {
    // Clear any user data or tokens (if applicable)
    //apiService.clears(); // Hypothetical method for cleanup

    // Navigate to LoginPage and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cerrar Sesión')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _cerrarSesion(context),
          child: Text('Cerrar Sesión'),
        ),
      ),
    );
  }
}
