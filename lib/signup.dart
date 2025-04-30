import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'main.dart'; // Import main.dart for StudentHomePage, TeacherHomePage, and LoginType

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController teacherIdController = TextEditingController();
  LoginType _signUpType = LoginType.student;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _handleSignUp() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String dob = dobController.text.trim();
    String regNo = regNoController.text.trim();
    String teacherId = teacherIdController.text.trim();

    // Common validations
    if (email.isEmpty || !email.contains("@") || !email.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid email"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password must be at least 6 characters"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_signUpType == LoginType.teacher) {
      // Teacher sign-up: Validate Teacher ID
      if (teacherId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter a Teacher ID"),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      // Mock sign-up success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TeacherHomePage(teacherId: teacherId),
        ),
      );
    } else {
      // Student sign-up: Validate DOB and Registration Number
      if (dob.isEmpty || _selectedDate == null || _selectedDate!.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter a valid Date of Birth"),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      if (regNo.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter a Registration Number"),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      // Mock sign-up success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentHomePage(
            username: email,
            dob: dob,
            regNo: regNo,
          ),
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade300, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/Instagram.png',
                    width: 220,
                    height: 110,
                    color: Colors.white.withOpacity(0.9),
                    colorBlendMode: BlendMode.modulate,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 220,
                        height: 110,
                        child: Icon(
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
                SizedBox(height: 48),
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
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SegmentedButton<LoginType>(
                              segments: [
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
                              selected: {_signUpType},
                              onSelectionChanged: (newSelection) {
                                setState(() {
                                  _signUpType = newSelection.first;
                                  emailController.clear();
                                  passwordController.clear();
                                  confirmPasswordController.clear();
                                  dobController.clear();
                                  regNoController.clear();
                                  teacherIdController.clear();
                                  _selectedDate = null;
                                });
                              },
                            ).animate().fadeIn(duration: 600.ms),
                            SizedBox(height: 16),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Email',
                                hintText: 'e.g. user@example.com',
                                prefixIcon: Icon(Icons.email, color: Colors.white70),
                                labelStyle: TextStyle(color: Colors.white70),
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              style: TextStyle(color: Colors.white),
                            )
                                .animate()
                                .slideX(
                              begin: -0.5,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            )
                                .fadeIn(duration: 600.ms),
                            SizedBox(height: 16),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Password',
                                hintText: 'At least 6 characters',
                                prefixIcon: Icon(Icons.lock, color: Colors.white70),
                                labelStyle: TextStyle(color: Colors.white70),
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              style: TextStyle(color: Colors.white),
                            )
                                .animate()
                                .slideX(
                              begin: 0.5,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            )
                                .fadeIn(duration: 600.ms),
                            SizedBox(height: 16),
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Confirm Password',
                                hintText: 'Re-enter your password',
                                prefixIcon: Icon(Icons.lock, color: Colors.white70),
                                labelStyle: TextStyle(color: Colors.white70),
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              style: TextStyle(color: Colors.white),
                            )
                                .animate()
                                .slideX(
                              begin: -0.5,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            )
                                .fadeIn(duration: 600.ms),
                            if (_signUpType == LoginType.student) ...[
                              SizedBox(height: 16),
                              TextField(
                                controller: dobController,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: 'Date of Birth',
                                  hintText: 'YYYY-MM-DD',
                                  prefixIcon: Icon(Icons.calendar_today, color: Colors.white70),
                                  labelStyle: TextStyle(color: Colors.white70),
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                style: TextStyle(color: Colors.white),
                              )
                                  .animate()
                                  .slideX(
                                begin: 0.5,
                                end: 0,
                                duration: 600.ms,
                                curve: Curves.easeOut,
                              )
                                  .fadeIn(duration: 600.ms),
                              SizedBox(height: 16),
                              TextField(
                                controller: regNoController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: 'Registration Number',
                                  hintText: 'e.g. REG12345',
                                  prefixIcon: Icon(Icons.badge, color: Colors.white70),
                                  labelStyle: TextStyle(color: Colors.white70),
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                style: TextStyle(color: Colors.white),
                              )
                                  .animate()
                                  .slideX(
                                begin: -0.5,
                                end: 0,
                                duration: 600.ms,
                                curve: Curves.easeOut,
                              )
                                  .fadeIn(duration: 600.ms),
                            ],
                            if (_signUpType == LoginType.teacher) ...[
                              SizedBox(height: 16),
                              TextField(
                                controller: teacherIdController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: 'Teacher ID',
                                  hintText: 'e.g. TID789',
                                  prefixIcon: Icon(Icons.perm_identity, color: Colors.white70),
                                  labelStyle: TextStyle(color: Colors.white70),
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                style: TextStyle(color: Colors.white),
                              )
                                  .animate()
                                  .slideX(
                                begin: 0.5,
                                end: 0,
                                duration: 600.ms,
                                curve: Curves.easeOut,
                              )
                                  .fadeIn(duration: 600.ms),
                            ],
                            SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.deepPurple, Colors.blueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
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
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
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
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.white70,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
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