import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String email = _emailController.text.trim();
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Passwords do not match';
        });
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      String userKey = 'user_${email.hashCode}';
      String? storedEmail = prefs.getString('${userKey}_email');
      String? storedRole = prefs.getString('${userKey}_role');

      if (storedEmail == email && storedRole != null) {
        await prefs.setString('${userKey}_password', newPassword);
        setState(() {
          _errorMessage = 'Password reset successfully';
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No account found for this email';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
            child: Form(
              key: _formKey,
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
                            Icons.lock_reset,
                            size: 60,
                            color: Colors.white70,
                          ),
                        );
                      },
                    ).animate().fadeIn(duration: 800.ms).scaleXY(
                      begin: 0.8,
                      end: 1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'University Of Dhaka',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                  const SizedBox(height: 16),
                  const Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 650.ms),
                  const SizedBox(height: 32),
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
                              TextFormField(
                                controller: _emailController,
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
                                validator: (value) {
                                  if (value!.trim().isEmpty) return 'Please enter your email';
                                  if (!value.contains('@') || !value.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ).animate().slideX(
                                begin: -0.5,
                                end: 0,
                                duration: 600.ms,
                                curve: Curves.easeOut,
                              ).fadeIn(duration: 600.ms),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _newPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white24,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: 'New Password',
                                  hintText: 'Enter new password',
                                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  hintStyle: const TextStyle(color: Colors.white54),
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value!.trim().isEmpty) return 'Please enter a new password';
                                  if (value.length < 6) return 'Password must be at least 6 characters';
                                  return null;
                                },
                              ).animate().slideX(
                                begin: 0.5,
                                end: 0,
                                duration: 600.ms,
                                curve: Curves.easeOut,
                              ).fadeIn(duration: 650.ms),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white24,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: 'Confirm Password',
                                  hintText: 'Confirm new password',
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  hintStyle: const TextStyle(color: Colors.white54),
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value!.trim().isEmpty) return 'Please confirm your password';
                                  if (value != _newPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ).animate().slideX(
                                begin: -0.5,
                                end: 0,
                                duration: 600.ms,
                                curve: Curves.easeOut,
                              ).fadeIn(duration: 700.ms),
                              const SizedBox(height: 24),
                              if (_errorMessage.isNotEmpty)
                                Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ).animate().fadeIn(duration: 500.ms),
                              const SizedBox(height: 16),
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
                                  onPressed: _isLoading ? null : _resetPassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                    "Reset Password",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn(duration: 800.ms).scaleXY(
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
                        "Back to ",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
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
      ),
    );
  }
}
