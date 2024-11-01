import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class PinCodeScreen extends StatefulWidget {
  final Function onAuthenticated;

  PinCodeScreen({required this.onAuthenticated});

  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final TextEditingController _pinController = TextEditingController();
  String? savedPin;

  @override
  void initState() {
    super.initState();
    _loadSavedPin();
  }

  Future<void> _loadSavedPin() async {
    // ดึงข้อมูล PIN จาก Firestore
    var doc = await FirebaseFirestore.instance.collection('users').doc('your_user_id').get();
    if (doc.exists) {
      setState(() {
        savedPin = doc['pin'];
      });
    }
  }

  void verifyPin(String enteredPin) {
    if (enteredPin == savedPin) {
      widget.onAuthenticated();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("รหัส PIN ไม่ถูกต้อง")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ใส่รหัส PIN ของคุณ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: "รหัส PIN"),
              obscureText: true,
              keyboardType: TextInputType.number,
              onSubmitted: verifyPin,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => verifyPin(_pinController.text),
              child: Text("ยืนยัน"),
            ),
          ],
        ),
      ),
    );
  }
}
