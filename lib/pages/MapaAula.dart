import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../services/api_service.dart';

class MapaAulaPage extends StatelessWidget {
  final String nombre;
  final String aula;
  final String ubicacion;

  MapaAulaPage({required this.nombre, required this.aula, required this.ubicacion});

  @override
  Widget build(BuildContext context) {
    late LatLng position;
    bool isValidLocation = true;

    try {
      final coords = ubicacion.split(',').map((e) => double.parse(e.trim())).toList();
      position = LatLng(coords[0], coords[1]);
    } catch (e) {
      isValidLocation = false;
    }

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
                Text('Aula: $aula', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Ubicación: $ubicacion', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: isValidLocation
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: position,
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('aula'),
                        position: position,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                    },
                  )
                : Center(
                    child: Text(
                      'Ubicación no válida para esta aula.',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
