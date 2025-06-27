import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ModifierUtilisateur.dart';


class ListeUtilisateurs extends StatefulWidget {
  @override
  _ListeUtilisateursState createState() => _ListeUtilisateursState();
}

class _ListeUtilisateursState extends State<ListeUtilisateurs> {
  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('http://localhost/App_users/api/get_users.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        users = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteUser(int id) async {
    final url = Uri.parse('http://localhost/App_users/api/delete_user.php');
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    final result = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result['message']),
      backgroundColor: result['success'] ? Colors.green : Colors.red,
    ));

    if (result['success']) fetchUsers();
  }

void goToUpdate(Map user) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ModifierUtilisateur(
        user: user,
        onUserUpdated: fetchUsers,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des utilisateurs')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(user['nom']),
                    subtitle: Text(user['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => goToUpdate(user),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteUser(user['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
