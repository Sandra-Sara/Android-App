import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'signup.dart'; // Import signup.dart for SignUpPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      home: LoginPage(),
    );
  }
}

enum LoginType { student, teacher }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController teacherIdController = TextEditingController();
  LoginType _loginType = LoginType.student;
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

  void _handleLogin() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String dob = dobController.text.trim();
    String regNo = regNoController.text.trim();
    String teacherId = teacherIdController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_loginType == LoginType.teacher) {
      // Teacher login: Check specific credentials and teacher ID
      if (email == "teacher@example.com" &&
          password == "teacher123" &&
          teacherId.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherHomePage(teacherId: teacherId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid teacher credentials or Teacher ID"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      // Student login: Validate email, password, DOB, and registration number
      if (email.contains("@") &&
          email.contains(".") &&
          dob.isNotEmpty &&
          regNo.isNotEmpty &&
          _selectedDate != null &&
          _selectedDate!.isBefore(DateTime.now())) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHomePage(
              username: email,
              dob: dob,
              regNo: regNo,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Please enter valid email, DOB, and Registration Number"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Password recovery not implemented"),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  void _handleSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
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
                              selected: {_loginType},
                              onSelectionChanged: (newSelection) {
                                setState(() {
                                  _loginType = newSelection.first;
                                  // Clear fields when switching
                                  emailController.clear();
                                  passwordController.clear();
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
                                hintText: 'Enter your password',
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
                            if (_loginType == LoginType.student) ...[
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
                                begin: -0.5,
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
                                begin: 0.5,
                                end: 0,
                                duration: 600.ms,
                                curve: Curves.easeOut,
                              )
                                  .fadeIn(duration: 600.ms),
                            ],
                            if (_loginType == LoginType.teacher) ...[
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
                                begin: -0.5,
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
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Log In",
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
                      "Forgot your password? ",
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
                      onTap: _handleForgotPassword,
                      child: Text(
                        "Get help",
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
                SizedBox(height: 32),
                Divider(color: Colors.white54),
                SizedBox(height: 16),
                Text(
                  "Don’t have an account?",
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
                TextButton(
                  onPressed: _handleSignUp,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 1200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentHomePage extends StatelessWidget {
  final String username;
  final String dob;
  final String regNo;

  const StudentHomePage({
    required this.username,
    required this.dob,
    required this.regNo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.deepPurple.shade300],
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(32),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome, Student!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .scaleXY(
                      begin: 0.8,
                      end: 1.0,
                      curve: Curves.easeOut,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Email: $username',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 1000.ms),
                    SizedBox(height: 8),
                    Text(
                      'DOB: $dob',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 1100.ms),
                    SizedBox(height: 8),
                    Text(
                      'Reg No: $regNo',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 1200.ms),
                    SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.yellowAccent, Colors.orangeAccent],
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
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 1300.ms)
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
      ),
    );
  }
}

class TeacherHomePage extends StatelessWidget {
  final String teacherId;

  // Mock student data for teacher dashboard
  final List<Map<String, String>> mockStudents = [
    {'email': 'student1@example.com', 'regNo': 'REG001'},
    {'email': 'student2@example.com', 'regNo': 'REG002'},
    {'email': 'student3@example.com', 'regNo': 'REG003'},
    {'email': 'student4@example.com', 'regNo': 'REG004'},
  ];

  TeacherHomePage({required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade200, Colors.teal.shade300],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Teacher Dashboard',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scaleXY(
                  begin: 0.8,
                  end: 1.0,
                  curve: Curves.easeOut,
                ),
                SizedBox(height: 16),
                Text(
                  'Teacher ID: $teacherId',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 1000.ms),
                SizedBox(height: 24),
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
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student List',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ).animate().fadeIn(duration: 1000.ms),
                            SizedBox(height: 16),
                            ...mockStudents.map((student) => ListTile(
                              title: Text(
                                student['email']!,
                                style: TextStyle(color: Colors.white70),
                              ),
                              subtitle: Text(
                                'Reg No: ${student['regNo']}',
                                style: TextStyle(color: Colors.white54),
                              ),
                              trailing: Icon(
                                Icons.school,
                                color: Colors.white54,
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().slideY(
                  begin: 0.5,
                  end: 0,
                  duration: 800.ms,
                  curve: Curves.easeOut,
                ),
                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.yellowAccent, Colors.orangeAccent],
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Manage students feature not implemented"),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Manage Students',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 1200.ms)
                    .scaleXY(
                  begin: 0.9,
                  end: 1.0,
                  duration: 600.ms,
                  curve: Curves.bounceOut,
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.orangeAccent],
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
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 1400.ms)
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
    );
  }
}
