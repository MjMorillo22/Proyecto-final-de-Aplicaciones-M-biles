import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:uasdfinal/pages/MapaAula.dart';
import '../services/api_service.dart';

class HorariosPage extends StatelessWidget {
  final ApiService apiService;

  HorariosPage({required this.apiService});

  Future<List<dynamic>> _fetchHorarios() async {
    return await apiService.fetchHorarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Horarios')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchHorarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final horarios = snapshot.data ?? [];
            if (horarios.isEmpty) {
              return Center(child: Text('No hay horarios disponibles.'));
            }
            return ListView.builder(
              itemCount: horarios.length,
              itemBuilder: (context, index) {
                final horario = horarios[index];
                final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
                    .format(DateTime.parse(horario['fechaHora']));
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(horario['materia'].toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Horario: $formattedDate\nAula: ${horario['aula']}'),
                    trailing: Icon(Icons.location_on, color: Colors.red),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapaAulaPage(
                            nombre: horario['materia'],
                            aula: horario['aula'],
                            ubicacion: horario['ubicacion'],
                          ),
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
