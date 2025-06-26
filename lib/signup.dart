import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController teacherIdController = TextEditingController();
  String role = 'student';
  bool _isLoading = false;

  Future<void> _signup() async {
    setState(() => _isLoading = true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();
      final regNo = regNoController.text.trim();
      final teacherId = teacherIdController.text.trim();

      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw Exception('Please fill in all required fields');
      }
      if (!email.contains('@') || !email.contains('.')) {
        throw Exception('Enter a valid email');
      }
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }
      if (role == 'student' && regNo.isEmpty) {
        throw Exception('Enter registration number');
      }
      if (role == 'teacher' && teacherId.isEmpty) {
        throw Exception('Enter teacher ID');
      }

      final prefs = await SharedPreferences.getInstance();

      // Check if already registered
      final existing = prefs.getString('email_$email');
      if (existing != null) {
        throw Exception('Email already registered');
      }

      // Save using keys matching login.dart
      await prefs.setString('email_$email', email);
      await prefs.setString('password_$email', password);
      await prefs.setString('role_$email', role);
      await prefs.setString('user_name_$email', name);
      if (role == 'student') {
        await prefs.setString('user_reg_no_$email', regNo);
      } else {
        await prefs.setString('user_teacher_id_$email', teacherId);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful! Please login.')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    regNoController.dispose();
    teacherIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/instagram.png',
                  height: 100,
                  width: 100,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 100, color: Colors.white),
                ).animate().fadeIn(duration: const Duration(milliseconds: 800)),
                const SizedBox(height: 16),
                Text(
                  role == 'student' ? 'Student Signup' : 'Teacher Signup',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ).animate().fadeIn(duration: const Duration(milliseconds: 800)),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: role,
                  items: const [
                    DropdownMenuItem(value: 'student', child: Text('Student')),
                    DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                  ],
                  onChanged: (value) => setState(() => role = value!),
                  dropdownColor: Colors.deepPurple,
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                const SizedBox(height: 16),
                if (role == 'student')
                  TextField(
                    controller: regNoController,
                    decoration: const InputDecoration(
                      labelText: 'Registration No',
                      hintText: 'e.g., REG12345',
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                if (role == 'teacher')
                  TextField(
                    controller: teacherIdController,
                    decoration: const InputDecoration(
                      labelText: 'Teacher ID',
                      hintText: 'e.g., TEACH001',
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ).animate().fadeIn(duration: const Duration(milliseconds: 1200)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.white70),
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 1200)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
