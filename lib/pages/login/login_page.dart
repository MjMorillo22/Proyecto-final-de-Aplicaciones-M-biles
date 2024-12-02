import 'package:flutter/material.dart';
import 'package:uasdfinal/pages/home_page.dart';
import 'package:uasdfinal/pages/login/recovery_page.dart';
import 'package:uasdfinal/pages/login/register.dart';
import 'package:uasdfinal/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Username and password cannot be empty.';
      });
      return;
    }

    try {
      final response = await _apiService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response['success'] == true) {
        // Navigate to HomePage with the ApiService
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(apiService: _apiService),
          ),
        );
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Invalid username or password.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Contraseña incorrecta';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecuperarContrasenaPage(apiService: _apiService),
                  ),
                );
              },
              child: Text('Recuperar Contraseña'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationPage(apiService: _apiService),
                  ),
                );
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VirtualClassroomPage(
                url: 'https://uasd.edu.do/admisiones-grado/',
              ),
            ),
          );
        },
        child: Icon(Icons.school),
        tooltip: 'Acceder al Aula Virtual',
      ),
    );
  }
}

class VirtualClassroomPage extends StatelessWidget {
  final String url;

  VirtualClassroomPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudia con nosotros'),
      ),
      body: WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
