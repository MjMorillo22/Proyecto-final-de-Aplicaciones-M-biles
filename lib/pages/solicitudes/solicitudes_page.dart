import 'package:flutter/material.dart';
import 'package:uasdfinal/pages/solicitudes/CrearSolicitudPage.dart';
import '/services/api_service.dart';

class SolicitudesPage extends StatefulWidget {
  final ApiService apiService;

  SolicitudesPage({required this.apiService});

  @override
  _SolicitudesPageState createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  late Future<List<dynamic>> _solicitudesFuture;

  @override
  void initState() {
    super.initState();
    _solicitudesFuture = _fetchSolicitudes();
  }

  Future<List<dynamic>> _fetchSolicitudes() async {
    final response = await widget.apiService.fetchSolicitudes();
    if (response['success'] == true) {
      return response['data'] ?? [];
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch solicitudes.');
    }
  }

  Future<void> _cancelSolicitud(int solicitudId) async {
    try {
      await widget.apiService.cancelarSolicitud(solicitudId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Solicitud cancelada exitosamente'),
      ));
      setState(() {
        _solicitudesFuture = _fetchSolicitudes(); // Refresh the list
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al cancelar la solicitud'),
      ));
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Solicitudes')),
      body: FutureBuilder<List<dynamic>>(
        future: _solicitudesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final solicitudes = snapshot.data ?? [];
            if (solicitudes.isEmpty) {
              return Center(
                child: Text('No hay solicitudes disponibles.'),
              );
            }
            return ListView.builder(
              itemCount: solicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = solicitudes[index];
                final estado = solicitud['estado'] ?? 'Desconocido';
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(solicitud['descripcion'] ?? 'Descripción no disponible'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipo: ${_getTipoDescripcion(solicitud['tipo'])}'),
                        Row(
                          children: [
                            Text('Estado: $estado'),
                            SizedBox(width: 10),
                            _getEstadoIcon(estado), // Add the corresponding icon
                          ],
                        ),
                        Text('Fecha: ${solicitud['fechaSolicitud'] ?? 'Sin fecha'}'),
                      ],
                    ),
                    trailing: estado == 'Pendiente'
                        ? IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              _cancelSolicitud(solicitud['id']);
                              _showNotification('La solicitud ha sido cancelada.');
                            },
                          )
                        : null, // Only show cancel button for pending solicitudes
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearSolicitudPage(apiService: widget.apiService),
            ),
          );
          setState(() {
            _solicitudesFuture = _fetchSolicitudes(); // Refresh data
          });
        },
      ),
    );
  }

  String _getTipoDescripcion(String? tipo) {
    final tiposMap = {
      "beca": "Solicitud de beca",
      "carta_estudio": "Carta de estudios",
      "record_nota": "Record de nota",
    };
    return tiposMap[tipo] ?? 'Tipo desconocido';
  }

  Widget _getEstadoIcon(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Icon(Icons.pending, color: Colors.orange);
      case 'aceptado':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'rechazado':
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.help_outline, color: Colors.grey);
    }
  }
}
