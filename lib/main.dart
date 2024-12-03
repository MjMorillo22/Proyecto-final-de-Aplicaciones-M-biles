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
        primarySwatch: Colors.blue, // Set the primary color to blue
        scaffoldBackgroundColor: Colors.white, // Set the background color to white
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0D47A1), // AppBar background color
          foregroundColor: Colors.white, // AppBar text and icon color
        ),
        cardTheme: CardTheme(
          color: Colors.white, // Card background color
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF0D47A1), // Button background color
          textTheme: ButtonTextTheme.primary, // Button text color
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey, // Default border color
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF0D47A1), // Border color when focused
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.grey, // Default label color
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade400, // Hint text color
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.blue.shade700; // Pressed state color
              } else if (states.contains(MaterialState.disabled)) {
                return Colors.grey; // Disabled state color
              }
              return Colors.blue; // Default background color
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.white; // Text color when pressed
              }
              return Colors.white; // Default text color
            }),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
          ),
        ),

        // TextButton Theme
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.blue.shade700; // Text color when pressed
              }
              return Colors.blue; // Default text color
            }),
          ),
        ),

        // OutlinedButton Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            side: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return BorderSide(color: Colors.blue.shade700); // Pressed border color
              }
              return BorderSide(color: Colors.blue); // Default border color
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(255, 7, 54, 100); // Text color when pressed
              }
              return Colors.blue; // Default text color
            }),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(), // Initial landing page
        '/login': (context) => LoginPage(), // Define the login page route
      },
    );
  }
}
