import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'dashboard_page.dart';

import 'teacher_dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('user_role');
    print('Checking login status: token=$token, role=$role');
    return token != null && role == 'student';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data == true) {
          return const DashboardPage();
        } else if (snapshot.hasData && snapshot.data == false) {
          final prefs = SharedPreferences.getInstance();
          prefs.then((prefs) {
            final role = prefs.getString('user_role');
            if (role == 'teacher') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const TeacherDashboardPage()),
              );
            }
          });
        }
        return const LoginPage();
      },
    );
  }
}
