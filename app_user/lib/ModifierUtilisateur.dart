import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModifierUtilisateur extends StatefulWidget {
  final Map user;
  final VoidCallback onUserUpdated;

  ModifierUtilisateur({required this.user, required this.onUserUpdated});

  @override
  _ModifierUtilisateurState createState() => _ModifierUtilisateurState();
}

class _ModifierUtilisateurState extends State<ModifierUtilisateur> {
  late TextEditingController nomController;
  late TextEditingController emailController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.user['nom']);
    emailController = TextEditingController(text: widget.user['email']);
  }

  Future<void> updateUser() async {
    final url = Uri.parse('http://localhost/App_users/api/update_user.php');

    setState(() => isLoading = true);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': widget.user['id'],
        'nom': nomController.text,
        'email': emailController.text,
      }),
    );

    final result = jsonDecode(response.body);
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result['message']),
      backgroundColor: result['success'] ? Colors.green : Colors.red,
    ));

    if (result['success']) {
      widget.onUserUpdated(); // pour refresh la liste
      Navigator.pop(context); // revenir à la liste
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier l\'utilisateur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: updateUser,
                    child: Text('Mettre à jour'),
                  ),
          ],
        ),
      ),
    );
  }
}
