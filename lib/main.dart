import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CalorieCalculator.dart';
import 'LoginScreen.dart'; // ให้แน่ใจว่าได้เพิ่มการนำเข้า LoginScreen
import 'package:fitness_tracker1/ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // ตรวจสอบสถานะการเข้าสู่ระบบ
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.containsKey("username"); // ตรวจสอบว่ามี username ใน SharedPreferences หรือไม่
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => isLoggedIn
            ? CalorieCalculator(
          onThemeToggle: toggleTheme,
          isDarkMode: isDarkMode,
        )
            : LoginScreen(onLogin: (username, password) {
          setState(() {
            isLoggedIn = true;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CalorieCalculator(
                onThemeToggle: toggleTheme,
                isDarkMode: isDarkMode,
              ),
            ),
          );
        }),
        '/login': (context) => LoginScreen(onLogin: (username, password) {
          setState(() {
            isLoggedIn = true;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CalorieCalculator(
                onThemeToggle: toggleTheme,
                isDarkMode: isDarkMode,
              ),
            ),
          );
        }),
        // เพิ่มเส้นทางอื่น ๆ ที่คุณมี
      },
    );
  }
}
