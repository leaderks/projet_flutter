import 'package:flutter/material.dart';
import 'InscriptionScreen.dart';
import 'ListeUtilisateurs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Utilisateurs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu principal")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InscriptionScreen()),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text("Inscription"),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ListeUtilisateurs()),
              );
            },
            icon: const Icon(Icons.list),
            label: const Text("Liste des utilisateurs"),
          ),
        ],
      ),
    );
  }
}
