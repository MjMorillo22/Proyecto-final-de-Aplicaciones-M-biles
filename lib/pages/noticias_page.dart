import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '/pages/login/login_page.dart';

class NoticiasPage extends StatelessWidget {
  final ApiService apiService; // Use shared ApiService instance

  // Constructor to accept the ApiService
  NoticiasPage({required this.apiService});

  Future<List<dynamic>> _fetchNoticias(BuildContext context) async {
    try {
      final response = await apiService.fetchNoticias();
      if (response['success'] == true) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch noticias.');
      }
    } catch (e) {
      // Handle unauthorized error
      if (e.toString().contains('Unauthorized')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sesión expirada. Por favor, inicia sesión nuevamente.')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
      rethrow; // Propagate other exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Noticias')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchNoticias(context), // Pass context for handling unauthorized
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final noticias = snapshot.data ?? [];
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                      noticia['img'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(noticia['title']),
                    subtitle: Text(noticia['date']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoticiaDetailPage(url: noticia['url']),
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

class NoticiaDetailPage extends StatelessWidget {
  final String url;

  NoticiaDetailPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Noticia')),
      body: Center(
        child: Text('Abrir enlace en el navegador: $url'),
      ),
    );
  }
}
