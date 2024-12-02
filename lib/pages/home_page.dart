import 'package:flutter/material.dart';
import 'package:uasdfinal/pages/login/UserInfoPage.dart';
import 'noticias_page.dart';
import 'horarios_page.dart';
import 'preseleccion_page.dart';
import 'deudas_page.dart';
import 'solicitudes/solicitudes_page.dart';
import 'tareas_page.dart';
import 'eventos_page.dart';
import 'videos_page.dart';
import 'acerca_de_page.dart';
import 'package:uasdfinal/services/api_service.dart';

class HomePage extends StatelessWidget {
  final ApiService apiService;

  // Accept the ApiService instance in the constructor
  HomePage({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person), // Ícono de usuario
          onPressed: () {
            // Navegar a la página de información del usuario
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserInfoPage(apiService: apiService),
              ),
            );
          },
        ),
        title: Text('Menu Principal'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10),
        children: [
          _buildMenuOption(
            context,
            'Noticias',
            Icons.article,
            NoticiasPage(apiService: apiService),
          ),
          _buildMenuOption(
            context,
            'Horarios',
            Icons.schedule,
            HorariosPage(apiService: apiService),
          ),
          _buildMenuOption(
            context,
            'Preselección',
            Icons.school,
            PreseleccionPage(apiService: apiService),
          ),
          _buildMenuOption(
            context,
            'Deudas',
            Icons.money,
            DeudasPage(apiService: apiService),
          ),
          _buildMenuOption(
            context,
            'Solicitudes',
            Icons.assignment,
            SolicitudesPage(apiService: apiService),
          ),
          _buildMenuOption(
            context,
            'Tareas',
            Icons.task,
            TareasPage(apiService: apiService),
          ),
          _buildMenuOption(
            context,
            'Eventos',
            Icons.event,
            EventosPage(apiService: apiService),
          ),
          _buildMenuOption(
            context,
            'Videos',
            Icons.video_library,
            VideosPage(apiService: apiService),
          ),
          _buildMenuOption(
            context,
            'Acerca de',
            Icons.info,
            AcercaDePage(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
