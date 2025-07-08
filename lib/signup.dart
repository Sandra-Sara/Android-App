import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'login.dart';

enum LoginType { student, teacher }

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController regOrTeacherIdController = TextEditingController();
  LoginType _loginType = LoginType.student;

  Future<void> _handleSignUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text.trim();
    String regOrTeacherId = regOrTeacherIdController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty || regOrTeacherId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid email"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    String userKey = 'user_${email.hashCode}';
    String? storedEmail = prefs.getString('${userKey}_email');

    if (storedEmail != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email already registered"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await prefs.setString('${userKey}_email', email);
    await prefs.setString('${userKey}_password', password);
    await prefs.setString('${userKey}_role', _loginType == LoginType.student ? 'student' : 'teacher');
    await prefs.setString('${userKey}_name', name);
    if (_loginType == LoginType.student) {
      await prefs.setString('${userKey}_reg', regOrTeacherId);
    } else {
      await prefs.setString('${userKey}_teacherId', regOrTeacherId);
    }

    await prefs.setString('token', 'mock_token_${email.hashCode}');
    await prefs.setString('user_role', _loginType == LoginType.student ? 'student' : 'teacher');
    await prefs.setString('profile_email', email);
    await prefs.setString('profile_name', name);
    if (_loginType == LoginType.student) {
      await prefs.setString('profile_reg', regOrTeacherId);
    } else {
      await prefs.setString('profile_teacherId', regOrTeacherId);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${_loginType == LoginType.student ? 'Student' : 'Teacher'} account created successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    regOrTeacherIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.deepPurple],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/dulogo.png',
                    width: 220,
                    height: 110,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 220,
                        height: 110,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.white70,
                        ),
                      );
                    },
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOut),
                ),
                const SizedBox(height: 16),
                const Text(
                  'University Of Dhaka',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SegmentedButton<LoginType>(
                              segments: const [
                                ButtonSegment(
                                  value: LoginType.student,
                                  label: Text('Student'),
                                  icon: Icon(Icons.school),
                                ),
                                ButtonSegment(
                                  value: LoginType.teacher,
                                  label: Text('Teacher'),
                                  icon: Icon(Icons.person_2),
                                ),
                              ],
                              selected: {_loginType},
                              onSelectionChanged: (newSelection) {
                                setState(() {
                                  _loginType = newSelection.first;
                                  emailController.clear();
                                  passwordController.clear();
                                  confirmPasswordController.clear();
                                  nameController.clear();
                                  regOrTeacherIdController.clear();
                                });
                              },
                            ).animate().fadeIn(duration: 600.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Full Name',
                                hintText: 'e.g. John Doe',
                                prefixIcon: const Icon(Icons.person, color: Colors.white70),
                                labelStyle: const TextStyle(color: Colors.white70),
                                hintStyle: const TextStyle(color: Colors.white54),
                              ),
                              style: const TextStyle(color: Colors.white),
                            )
                                .animate()
                                .slideX(
                              begin: -0.5,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            )
                                .fadeIn(duration: 600.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Email',
                                hintText: 'e.g. user@example.com',
                                prefixIcon: const Icon(Icons.email, color: Colors.white70),
                                labelStyle: const TextStyle(color: Colors.white70),
                                hintStyle: const TextStyle(color: Colors.white54),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                            )
                                .animate()
                                .slideX(
                              begin: -0.5,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            )
                                .fadeIn(duration: 600.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                                labelStyle: const TextStyle(color: Colors.white70),
                                hintStyle: const TextStyle(color: Colors.white54),
                              ),
                              style: const TextStyle(color: Colors.white),
                            )
                                .animate()
                                .slideX(
                              begin: 0.5,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            )
                                .fadeIn(duration: 600.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Confirm Password',
                                hintText: 'Re-enter your password',
                                prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                                labelStyle: const TextStyle(color: Colors.white70),
                                hintStyle: const TextStyle(color: Colors.white54),
                              ),
                              style: const TextStyle(color: Colors.white),
                            )
                                .animate()
                                .slideX(
                              begin: 0.5,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            )
                                .fadeIn(duration: 600.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: regOrTeacherIdController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: _loginType == LoginType.student
                                    ? 'Registration Number'
                                    : 'Teacher ID',
                                hintText: _loginType == LoginType.student
                                    ? 'e.g. 2022315933'
                                    : 'e.g. T12345',
                                prefixIcon: const Icon(Icons.badge, color: Colors.white70),
                                labelStyle: const TextStyle(color: Colors.white70),
                                hintStyle: const TextStyle(color: Colors.white54),
                              ),
                              style: const TextStyle(color: Colors.white),
                            )
                                .animate()
                                .slideX(
                              begin: 0.5,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            )
                                .fadeIn(duration: 600.ms),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.deepPurple],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 800.ms)
                                .scaleXY(
                              begin: 0.9,
                              end: 1.0,
                              duration: 600.ms,
                              curve: Curves.bounceOut,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 1000.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}