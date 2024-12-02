import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uasdfinal/pages/EventoDetallesPage.dart';
import '../services/api_service.dart';
import 'login/login_page.dart';

class EventosPage extends StatelessWidget {
  final ApiService apiService; // Use shared ApiService instance

  EventosPage({required this.apiService});

  Future<List<dynamic>> _fetchEventos(BuildContext context) async {
    try {
      final eventos = await apiService.fetchEventos();
      return eventos; // Return the list of events directly
    } catch (e) {
      // Handle unauthorized error
      if (e.toString().contains('Unauthorized')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sesión expirada. Por favor, inicia sesión nuevamente.')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to login
          (route) => false,
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchEventos(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final eventos = snapshot.data ?? [];
            return ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    title: Text(evento['titulo'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Fecha: ${evento['fechaEvento']}'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventoDetallesPage(evento: evento),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
