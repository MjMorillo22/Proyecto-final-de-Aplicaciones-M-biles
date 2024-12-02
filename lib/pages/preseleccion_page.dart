import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PreseleccionPage extends StatefulWidget {
  final ApiService apiService;

  PreseleccionPage({required this.apiService});

  @override
  _PreseleccionPageState createState() => _PreseleccionPageState();
}

class _PreseleccionPageState extends State<PreseleccionPage> {
  List<dynamic> _miPreseleccion = [];
  List<dynamic> _materiasDisponibles = [];
  List<String> _materiasSeleccionadas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMiPreseleccion();
  }

  Future<void> _fetchMiPreseleccion() async {
    try {
      final preseleccion = await widget.apiService.fetchPreseleccion();
      setState(() {
        _miPreseleccion = preseleccion;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al cargar mi preselección'),
      ));
    }
  }

  Future<void> _fetchMateriasDisponibles() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final materias = await widget.apiService.fetchMateriasDisponibles();
      setState(() {
        // Filter out already preselected subjects
        _materiasDisponibles = materias.where((materia) {
          return !_miPreseleccion.any((preseleccionada) => preseleccionada['codigo'] == materia['codigo']);
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al cargar materias disponibles'),
      ));
    }
  }

  Future<void> _enviarPreseleccion() async {
    try {
      for (String codigo in _materiasSeleccionadas) {
        // Check if the subject is already preselected
        if (_miPreseleccion.any((materia) => materia['codigo'] == codigo)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('La materia con código $codigo ya está preseleccionada.'),
          ));
          continue;
        }
        await widget.apiService.preseleccionarMateria(codigo);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Preselección enviada con éxito'),
      ));
      _fetchMiPreseleccion();
      setState(() {
        _materiasSeleccionadas.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al enviar la preselección'),
      ));
    }
  }

  Future<void> _cancelarPreseleccion(String codigo) async {
    try {
      await widget.apiService.cancelarPreseleccionMateria(codigo);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Preselección cancelada con éxito'),
      ));
      _fetchMiPreseleccion();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al cancelar la preselección'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preselección de Materias')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _miPreseleccion.length,
                    itemBuilder: (context, index) {
                      final materia = _miPreseleccion[index];
                      return ListTile(
                        title: Text(materia['nombre']),
                        subtitle: Text('Aula: ${materia['aula']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _cancelarPreseleccion(materia['codigo']);
                          },
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _fetchMateriasDisponibles,
                  child: Text('Preseleccionar Nuevas Materias'),
                ),
                if (_materiasDisponibles.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _materiasDisponibles.length,
                      itemBuilder: (context, index) {
                        final materia = _materiasDisponibles[index];
                        return CheckboxListTile(
                          title: Text(materia['nombre']),
                          subtitle: Text('Horario: ${materia['horario']} - Aula: ${materia['aula']}'),
                          value: _materiasSeleccionadas.contains(materia['codigo']),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                _materiasSeleccionadas.add(materia['codigo']);
                              } else {
                                _materiasSeleccionadas.remove(materia['codigo']);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                if (_materiasSeleccionadas.isNotEmpty)
                  ElevatedButton(
                    onPressed: _enviarPreseleccion,
                    child: Text('Confirmar Preselección'),
                  ),
              ],
            ),
    );
  }
}
