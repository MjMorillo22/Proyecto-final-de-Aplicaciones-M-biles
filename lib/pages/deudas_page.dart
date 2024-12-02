import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/services/api_service.dart';

class DeudasPage extends StatelessWidget {
  final ApiService apiService; // Use shared ApiService instance

  // Constructor to accept ApiService
  DeudasPage({required this.apiService});

  Future<List<dynamic>> _fetchDeudas() async {
    final response = await apiService.fetchDeudas();
    if (response is List) {
      return response; // Ensure it's a list
    } else {
      throw Exception('Unexpected response format for deudas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estado de Deudas')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchDeudas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final deudas = snapshot.data ?? [];
            if (deudas.isEmpty) {
              return Center(child: Text('No hay deudas disponibles.'));
            }
            return ListView.builder(
              itemCount: deudas.length,
              itemBuilder: (context, index) {
                final deuda = deudas[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text("Deuda a pagar"),
                    subtitle: Text(
                      'Monto: \$${deuda['monto'] ?? '0.00'}',
                    ),
                    trailing: ElevatedButton(
                      child: Text('Pagar'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PagoWebViewPage(
                              url: 'https://uasd.edu.do/servicios/pago-en-linea/',
                            ),
                          ),
                        );
                      },
                    ),
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

class PagoWebViewPage extends StatefulWidget {
  final String url;

  PagoWebViewPage({required this.url});

  @override
  State<PagoWebViewPage> createState() => _PagoWebViewPageState();
}

class _PagoWebViewPageState extends State<PagoWebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pago en Línea'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
