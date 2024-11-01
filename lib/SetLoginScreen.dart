
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetLoginScreen extends StatefulWidget {
  final Function(String, String) onLoginSet;

  SetLoginScreen({required this.onLoginSet});

  @override
  _SetLoginScreenState createState() => _SetLoginScreenState();
}

class _SetLoginScreenState extends State<SetLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> saveLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc('unique_user_id').set({
        'username': username,
        'password': password,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username and Password saved successfully!")),
      );

      widget.onLoginSet(username, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in both fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Login Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveLogin,
              child: Text("Save Login"),
            ),
          ],
        ),
      ),
    );
  }
}
