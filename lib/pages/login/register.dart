import 'package:flutter/material.dart';
import '/services/api_service.dart';

class RegistrationPage extends StatefulWidget {
  final ApiService apiService;

  RegistrationPage({required this.apiService});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

 Future<void> _register() async {
  if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Las contraseñas no coinciden.'),
    ));
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    await widget.apiService.createUser(
      _nombreController.text.trim(),
      _apellidoController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text.trim(),
      _emailController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Usuario creado exitosamente.'),
    ));
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error al crear usuario: Asegurese de llenar todos los campos'),
    ));
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _register,
                child: Text('Registrarse'),
              ),
          ],
        ),
      ),
    );
  }
}
