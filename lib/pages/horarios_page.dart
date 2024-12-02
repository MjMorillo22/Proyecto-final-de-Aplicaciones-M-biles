import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                final materia = horarios[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(materia['nombre']),
                    subtitle: Text('Horario: ${materia['horario']} - Aula: ${materia['aula']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapaAulaPage(
                            nombre: materia['nombre'],
                            aula: materia['aula'],
                            ubicacion: materia['ubicacion'],
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

class MapaAulaPage extends StatelessWidget {
  final String nombre;
  final String aula;
  final String ubicacion;

  MapaAulaPage({required this.nombre, required this.aula, required this.ubicacion});

  @override
  Widget build(BuildContext context) {
    // Extract latitude and longitude from the location string
    final coords = ubicacion.split(',').map((e) => double.parse(e.trim())).toList();
    final LatLng position = LatLng(coords[0], coords[1]);

    return Scaffold(
      appBar: AppBar(title: Text('Ubicación del Aula')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Materia: $nombre', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Aula: $aula'),
                SizedBox(height: 10),
                Text('Ubicación: $ubicacion'),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('aula'),
                  position: position,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
