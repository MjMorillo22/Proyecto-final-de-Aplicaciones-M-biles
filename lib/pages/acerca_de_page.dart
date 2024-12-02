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
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Marcos Jose Morillo Suarez'),
              subtitle: Text('Matrícula: 202010624'),
            ),
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Marcos Jose Morillo Suarez'),
              subtitle: Text('Matrícula: 202010624'),
            ),
          ],
        ),
      ),
    );
  }
}
