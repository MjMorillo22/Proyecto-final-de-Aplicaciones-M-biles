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
        _errorMessage = 'El usuario y la contraseña no pueden estar vacíos.';
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
          _errorMessage =
              response['message'] ?? 'Usuario o contraseña inválida.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ha ocurrido un error. Inténtalo nuevamente.';
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Image.asset(
          'assets/logo_blanco.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                'Inicio de sesión',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Usuario'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Acceder'),
                ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecuperarContrasenaPage(apiService: _apiService),
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
                      builder: (context) =>
                          RegistrationPage(apiService: _apiService),
                    ),
                  );
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
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
