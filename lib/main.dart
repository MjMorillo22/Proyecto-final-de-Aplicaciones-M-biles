import 'package:flutter/material.dart';
import 'package:uasdfinal/pages/login/login_page.dart';
import 'package:uasdfinal/pages/landing/landingpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UASD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(), // Initial landing page
        '/login': (context) => LoginPage(), // Define the login page route
      },
    );
  }
}
