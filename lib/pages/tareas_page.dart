import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TareasPage extends StatelessWidget {
  final ApiService apiService;

  TareasPage({required this.apiService});

  Future<List<Map<String, dynamic>>> _fetchTareas() async {
    return await apiService.fetchTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Tareas')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTareas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final tareas = snapshot.data ?? [];
            if (tareas.isEmpty) {
              return Center(
                child: Text('No hay tareas disponibles.'),
              );
            }
            return ListView.builder(
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                final tarea = tareas[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(tarea['titulo'] ?? 'Sin título'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Descripción: ${tarea['descripcion'] ?? 'No disponible'}'),
                        Text('Fecha límite: ${tarea['fechaVencimiento'] ?? 'No disponible'}'),
                        Text(
                          'Estado: ${tarea['completada'] == true ? 'Completada' : 'Pendiente'}',
                          style: TextStyle(
                            color: tarea['completada'] == true
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    trailing: tarea['completada'] == true
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.pending, color: Colors.orange),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VirtualClassroomPage(
                url: 'https://soft.uasd.edu.do/UASDVirtualGateway/',
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
        title: Text('Aula Virtual'),
      ),
      body: WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
