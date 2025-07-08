import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'examschedule_page.dart';
import 'profile_page.dart';
import 'attendance_page.dart';
import 'examschedule_page.dart';
import 'leave_page.dart';
import 'notification_page.dart';
import 'classwork_page.dart';
import 'login.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              var SharedPreferences;
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await prefs.remove('email');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/dulogo.png',
                height: 150,
                width: 300,
              ),
              const SizedBox(height: 20),
              const Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Student Dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
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
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Attendance',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AttendancePage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Exam Schedule',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ExamSchedulePage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Leave',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LeavePage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Notification',
                    textColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  NotificationPage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Classwork',
                    textColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ClassworkPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
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
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: _isTapped ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
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
    );
  }
}
