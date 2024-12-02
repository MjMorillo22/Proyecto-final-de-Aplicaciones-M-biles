import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/api_service.dart';
import 'login/login_page.dart';

class EventoDetallesPage extends StatelessWidget {
  final dynamic evento;

  EventoDetallesPage({required this.evento});

  @override
  Widget build(BuildContext context) {
    // Extract coordinates from the event
    final coordinates = evento['coordenadas'].split(',');
    final latitude = double.parse(coordinates[0]);
    final longitude = double.parse(coordinates[1]);

    return Scaffold(
      appBar: AppBar(title: Text('Detalles del Evento')),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Título: ${evento['titulo']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Fecha: ${evento['fechaEvento']}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Lugar: ${evento['lugar']}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Descripción:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(evento['descripcion'], style: TextStyle(fontSize: 14)),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('eventLocation'),
                      position: LatLng(latitude, longitude),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
