import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'student_dashboard.dart';
import 'teacher_dashboard.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isStudent = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix input errors')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final role = _isStudent ? 'student' : 'teacher';

      final storedEmail = prefs.getString('email_$email');
      final storedPassword = prefs.getString('password_$email');
      final storedRole = prefs.getString('role_$email');

      if (storedEmail == email &&
          storedPassword == password &&
          storedRole == role) {
        await prefs.setString('token', 'mock_token_$email');
        await prefs.setString('user_email', email);
        await prefs.setString('user_role', role);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => _isStudent
                ? const DashboardPage()
                : const TeacherDashboardPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Gmail or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
                const SizedBox(height: 40),
                Image.asset(
                  'assets/instagram.png',
                  height: 100,
                  width: 100,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 100, color: Colors.white),
                ).animate().fadeIn(duration: const Duration(milliseconds: 800)),
                const SizedBox(height: 16),
                Text(
                  _isStudent ? 'Student Login' : 'Teacher Login',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 800)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Student'),
                      selected: _isStudent,
                      selectedColor: Colors.deepPurple,
                      labelStyle: TextStyle(
                        color: _isStudent ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.white24,
                      onSelected: (selected) {
                        if (selected) setState(() => _isStudent = true);
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Teacher'),
                      selected: !_isStudent,
                      selectedColor: Colors.deepPurple,
                      labelStyle: TextStyle(
                        color: !_isStudent ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.white24,
                      onSelected: (selected) {
                        if (selected) setState(() => _isStudent = false);
                      },
                    ),
                  ],
                ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Gmail',
                          hintText: 'Enter your Gmail',
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Gmail';
                          }
                          if (!RegExp(r'^[\w-\.]+@gmail\.com$').hasMatch(value)) {
                            return 'Please enter a valid Gmail address';
                          }
                          return null;
                        },
                      ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(),
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
                      const SizedBox(height: 32),
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 16)),
                      ).animate().fadeIn(duration: const Duration(milliseconds: 1200)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Sign up',
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
