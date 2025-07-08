import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentCGPAPage extends StatefulWidget {
  const StudentCGPAPage({super.key});

  @override
  State<StudentCGPAPage> createState() => _StudentCGPAPageState();
}

class _StudentCGPAPageState extends State<StudentCGPAPage> {
  List<Map<String, dynamic>> grades = [];
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  String? currentStudentName;
  List<String> registeredStudents = [];

  @override
  void initState() {
    super.initState();
    _loadRegisteredStudents();
  }

  Future<void> _loadRegisteredStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('users') ?? [];
    setState(() {
      registeredStudents = users
          .map((user) => user.split(':')[0]) // Assuming user format: name:email:password:regNo
          .where((name) => name.isNotEmpty)
          .toList();
    });
  }

  Future<void> _loadGrades(String studentName) async {
    final prefs = await SharedPreferences.getInstance();
    final gradeData = prefs.getStringList('grades_$studentName') ?? [];
    setState(() {
      grades = [];
      for (var data in gradeData) {
        try {
          final parts = data.split(':');
          if (parts.length != 3) continue;
          final credit = double.tryParse(parts[2]);
          if (credit == null || credit <= 0 || !_isValidGrade(parts[1])) continue;
          grades.add({
            'subject': parts[0],
            'grade': parts[1],
            'credit': credit,
          });
        } catch (e) {
          debugPrint('Error parsing grade data for $studentName: $data, error: $e');
        }
      }
      currentStudentName = studentName;
    });
  }

  Future<void> _saveGrades(String studentName) async {
    final prefs = await SharedPreferences.getInstance();
    final gradeData = grades.map((grade) => '${grade['subject']}:${grade['grade']}:${grade['credit']}').toList();
    await prefs.setStringList('grades_$studentName', gradeData);
  }

  Future<void> _clearGrades(String studentName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('grades_$studentName');
    setState(() {
      grades = [];
      currentStudentName = studentName;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All grades cleared for $studentName'),
        backgroundColor: Colors.green,
      ),
    );
  }

  double calculateCGPA() {
    if (grades.isEmpty) return 0.0;
    double totalPoints = 0.0;
    double totalCredits = 0.0;
    for (var g in grades) {
      double gradePoint = _gradeToPoint(g['grade']);
      if (gradePoint == 0.0) continue;
      double credit = g['credit'];
      if (credit <= 0) continue;
      totalPoints += gradePoint * credit;
      totalCredits += credit;
    }
    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  double _gradeToPoint(String grade) {
    switch (grade.toUpperCase()) {
      case 'A+': return 4.0;
      case 'A': return 3.75;
      case 'A-': return 3.5;
      case 'B+': return 3.25;
      case 'B': return 3.0;
      case 'C': return 2.5;
      case 'D': return 2.0;
      default: return 0.0;
    }
  }

  bool _isValidGrade(String grade) {
    final validGrades = ['A+', 'A', 'A-', 'B+', 'B', 'C', 'D'];
    return validGrades.contains(grade.toUpperCase());
  }

  void _showInputDialog() {
    if (currentStudentName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a student first'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    subjectController.clear();
    gradeController.clear();
    creditController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text('Enter Grade for $currentStudentName', style: const TextStyle(color: Colors.black87)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        labelStyle: const TextStyle(color: Colors.black87),
                        hintStyle: const TextStyle(color: Colors.black54),
                      ),
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: gradeController,
                      decoration: InputDecoration(
                        labelText: 'Grade (e.g., A+, A, B+, etc.)',
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        labelStyle: const TextStyle(color: Colors.black87),
                        hintStyle: const TextStyle(color: Colors.black54),
                      ),
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: creditController,
                      decoration: InputDecoration(
                        labelText: 'Credits (e.g., 3.0)',
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        labelStyle: const TextStyle(color: Colors.black87),
                        hintStyle: const TextStyle(color: Colors.black54),
                      ),
                      style: const TextStyle(color: Colors.black87),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
                ),
                TextButton(
                  onPressed: () {
                    final subject = subjectController.text.trim();
                    final grade = gradeController.text.trim();
                    final creditText = creditController.text.trim();
                    double? credit = double.tryParse(creditText);

                    if (subject.isEmpty || grade.isEmpty || creditText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter subject, grade, and credits'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    if (!_isValidGrade(grade)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid grade. Use A+, A, A-, B+, B, C, or D'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    if (credit == null || credit <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Credits must be a positive number'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      grades.add({
                        'subject': subject,
                        'grade': grade,
                        'credit': credit,
                      });
                      _saveGrades(currentStudentName!);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Grade added successfully for $currentStudentName'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Add', style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    studentNameController.dispose();
    subjectController.dispose();
    gradeController.dispose();
    creditController.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/dulogo.png',
                    height: 150,
                    width: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100, color: Colors.white70),
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 20),
                  const Text(
                    'University Of Dhaka',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentStudentName != null ? 'CGPA for $currentStudentName' : 'Student CGPA',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: studentNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Student Name',
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintStyle: const TextStyle(color: Colors.white54),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white70),
                        onPressed: () {
                          final studentName = studentNameController.text.trim();
                          if (studentName.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a student name'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          _loadGrades(studentName);
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) {
                      if (value.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a student name'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      _loadGrades(value.trim());
                    },
                  ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.5, end: 0),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
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
                              onPressed: _showInputDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Add Grade',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.9, end: 1.0),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.redAccent, Colors.red],
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
                              onPressed: currentStudentName != null
                                  ? () => _clearGrades(currentStudentName!)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Clear All Grades',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.9, end: 1.0),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: grades.length,
                            itemBuilder: (context, index) {
                              final g = grades[index];
                              return ListTile(
                                title: Text(
                                  g['subject'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Grade: ${g['grade']} | Credits: ${g['credit']}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'CGPA: ${calculateCGPA().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
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
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.9, end: 1.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}