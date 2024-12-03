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
  bool _isLoadingPreseleccion = true;
  bool _isLoadingDisponibles = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchMiPreseleccion();
  }

  Future<void> _fetchMiPreseleccion() async {
    setState(() {
      _isLoadingPreseleccion = true;
    });
    try {
      final preseleccion = await widget.apiService.fetchPreseleccion();
      setState(() {
        _miPreseleccion = preseleccion;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar mi preselección.')),
      );
    } finally {
      setState(() {
        _isLoadingPreseleccion = false;
      });
    }
  }

  Future<void> _fetchMateriasDisponibles() async {
    if (_isLoadingDisponibles) return; // Prevent duplicate API calls
    setState(() {
      _isLoadingDisponibles = true;
    });
    try {
      final materias = await widget.apiService.fetchMateriasDisponibles();
      setState(() {
        _materiasDisponibles = materias.where((materia) {
          return !_miPreseleccion.any(
              (preseleccionada) => preseleccionada['codigo'] == materia['codigo']);
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar materias disponibles.')),
      );
    } finally {
      setState(() {
        _isLoadingDisponibles = false;
      });
    }
  }

  Future<void> _enviarPreseleccion() async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      for (String codigo in _materiasSeleccionadas) {
        if (!_miPreseleccion.any((materia) => materia['codigo'] == codigo)) {
          await widget.apiService.preseleccionarMateria(codigo);
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preselección enviada con éxito.')),
      );
      await _fetchMiPreseleccion();
      setState(() {
        _materiasSeleccionadas.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la preselección.')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _cancelarPreseleccion(String codigo) async {
    try {
      await widget.apiService.cancelarPreseleccionMateria(codigo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preselección cancelada con éxito.')),
      );
      await _fetchMiPreseleccion();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cancelar la preselección.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preselección de Materias')),
      body: Column(
        children: [
          if (_isLoadingPreseleccion)
            Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      'Mis Materias Preseleccionadas',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._miPreseleccion.map((materia) {
                    return ListTile(
                      title: Text(materia['nombre']),
                      subtitle: Text('Aula: ${materia['aula']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _cancelarPreseleccion(materia['codigo']),
                      ),
                    );
                  }).toList(),
                  Divider(),
                  ElevatedButton(
                    onPressed: !_isLoadingDisponibles ? _fetchMateriasDisponibles : null,
                    child: _isLoadingDisponibles
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Preseleccionar Nuevas Materias'),
                  ),
                  if (_materiasDisponibles.isNotEmpty)
                    ListTile(
                      title: Text(
                        'Materias Disponibles',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ..._materiasDisponibles.map((materia) {
                    return CheckboxListTile(
                      title: Text(materia['nombre']),
                      subtitle:
                          Text('Horario: ${materia['horario']} - Aula: ${materia['aula']}'),
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
                  }).toList(),
                  if (_materiasSeleccionadas.isNotEmpty)
                    ElevatedButton(
                      onPressed: !_isSubmitting ? _enviarPreseleccion : null,
                      child: _isSubmitting
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Confirmar Preselección'),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
