import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InscriptionScreen extends StatefulWidget {
  @override
  _InscriptionScreenState createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool isLoading = false;

  Future<void> inscrire() async {
    final url = Uri.parse('http://localhost/App_users/api/register.php'); // localhost pour émulateur Android
    setState(() => isLoading = true);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': _nomController.text,
        'email': _emailController.text,
        'password': _passController.text,
      }),
    );

    setState(() => isLoading = false);
    final data = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(data['message']),
      backgroundColor: data['success'] ? Colors.green : Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nomController, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passController, decoration: InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: inscrire, child: Text('S\'inscrire')),
          ],
        ),
      ),
    );
  }
}
