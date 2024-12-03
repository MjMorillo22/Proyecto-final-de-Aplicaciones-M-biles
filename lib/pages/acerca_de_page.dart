import 'package:flutter/material.dart';

class AcercaDePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DeveloperInfo(
              imagePath: 'assets/marcos.png',
              name: 'Marcos Jose Morillo Suarez',
              matricula: 'Matrícula: 2020-10624',
              aporte: 'Desarrollo de la aplicacion',
            ),
            DeveloperInfo(
            imagePath: 'assets/vago2.jpg',
            name: 'Yesica De Los Santos',
            matricula: 'Matrícula: 2022-0748',
            aporte: 'Absolutamente nada',
            ),
            DeveloperInfo(
            imagePath: 'assets/vago3.jpg',
            name: 'Eduardo Pérez',
            matricula: 'Matrícula: 2020-10473',
            aporte: 'Absolutamente nada',
            ),
            DeveloperInfo(
            imagePath: 'assets/vago1.jpg',
            name: 'Vicmairy Adelina Charles Laureano',
            matricula: 'Matrícula: 2022-0261',
            aporte: 'Absolutamente nada',
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  final String imagePath;
  final String name;
  final String matricula;
  final String aporte;

  const DeveloperInfo({
    required this.imagePath,
    required this.name,
    required this.matricula,
    required this.aporte,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(imagePath),
        onBackgroundImageError: (_, __) =>
            Icon(Icons.error, color: Colors.red), // Fallback if image fails
      ),
      title: Text(name),
      subtitle: Text(matricula),
    );
  }
}
