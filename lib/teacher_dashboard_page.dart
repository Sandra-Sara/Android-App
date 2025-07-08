import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'teacher_profile-page.dart';

import 'student_attendance_page.dart';
import 'student_cgpa_page.dart';
import 'class_routine_page.dart';
import 'drop_update_page.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/dulogo.png',
                    height: 150,
                    width: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100, color: Colors.white70),
                  ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.8, end: 1.0),
                  const SizedBox(height: 20),
                  const Text(
                    'University Of Dhaka',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Teacher Dashboard',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      OptionBox(
                        option: 'Profile',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TeacherProfilePage()),
                          );
                        },
                      ),
                      OptionBox(
                        option: 'Student Attendance',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StudentAttendancePage()),
                          );
                        },
                      ),
                      OptionBox(
                        option: 'Student CGPA',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StudentCGPAPage()),
                          );
                        },
                      ),
                      OptionBox(
                        option: 'Class Routine',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ClassRoutinePage()),
                          );
                        },
                      ),
                      OptionBox(
                        option: 'Drop Update',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DropUpdatePage()),
                          );
                        },
                      ),
                    ],
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      await prefs.remove('email');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionBox extends StatefulWidget {
  final String option;
  final Color textColor;
  final VoidCallback? onTap;

  const OptionBox({super.key, required this.option, this.textColor = Colors.blue, this.onTap});

  @override
  State<OptionBox> createState() => _OptionBoxState();
}

class _OptionBoxState extends State<OptionBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isTapped = true;
    });
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _isTapped = false;
        });
        if (widget.onTap != null) {
          widget.onTap!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: _isTapped ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                widget.option,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isTapped ? Colors.white : widget.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}