import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        name = userData['name'] ?? 'ไม่ระบุ';
      });
    }
  }

  Future<void> _logout() async {
    await _auth.signOut(); // ออกจากระบบ
    Navigator.of(context).pushReplacementNamed('/login'); // นำทางไปยังหน้า login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์', style: TextStyle(color: Colors.white)), // สีตัวอักษรใน AppBar
        backgroundColor: Colors.grey[850], // สีพื้นหลัง AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.grey[850], // ตั้งค่าพื้นหลังของการ์ด
          elevation: 5, // เพิ่มเงาให้การ์ด
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // มุมของการ์ด
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ชื่อ: $name', style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _logout,
                  child: Text('ออกจากระบบ', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // ตั้งค่าสีปุ่มเป็นสีแดง
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
