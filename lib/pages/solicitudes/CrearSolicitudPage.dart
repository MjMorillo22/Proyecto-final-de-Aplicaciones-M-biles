import 'package:flutter/material.dart';
import '/services/api_service.dart';

class CrearSolicitudPage extends StatefulWidget {
  final ApiService apiService;

  CrearSolicitudPage({required this.apiService});

  @override
  _CrearSolicitudPageState createState() => _CrearSolicitudPageState();
}

class _CrearSolicitudPageState extends State<CrearSolicitudPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  String? _selectedTipo; // Store selected tipo de solicitud
  List<dynamic> _tiposSolicitudes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTiposSolicitudes();
  }

  Future<void> _fetchTiposSolicitudes() async {
    try {
      final tipos = await widget.apiService.fetchTiposSolicitudes();
      setState(() {
        _tiposSolicitudes = tipos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar tipos de solicitudes: $e')),
      );
    }
  }

  Future<void> _crearSolicitud() async {
    if (_selectedTipo == null ||
        _tituloController.text.trim().isEmpty ||
        _descripcionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    try {
      await widget.apiService.crearSolicitud(
        _tituloController.text.trim(),
        _descripcionController.text.trim(),
        _selectedTipo!, // Pass the selected tipo
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solicitud creada exitosamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solo puedes crear 1 tipo de solicitud a la vez')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Solicitud')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedTipo,
                    hint: Text('Seleccione el tipo de solicitud'),
                    items: _tiposSolicitudes.map((tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo['codigo'], // Use codigo as value
                        child: Text(tipo['descripcion']), // Display descripcion
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTipo = value;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _tituloController,
                    decoration: InputDecoration(labelText: 'Título'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _descripcionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _crearSolicitud,
                    child: Text('Enviar'),
                  ),
                ],
              ),
            ),
    );
  }
}
