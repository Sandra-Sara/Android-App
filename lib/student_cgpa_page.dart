import 'package:flutter/material.dart';

class StudentCGPAPage extends StatefulWidget {
  const StudentCGPAPage({super.key});

  @override
  State<StudentCGPAPage> createState() => _StudentCGPAPageState();
}

class _StudentCGPAPageState extends State<StudentCGPAPage> {
  final List<Map<String, dynamic>> grades = [];
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  double calculateCGPA() {
    if (grades.isEmpty) return 0;
    double total = 0;
    for (var g in grades) {
      total += _gradeToPoint(g['grade']);
    }
    return total / grades.length;
  }

  double _gradeToPoint(String grade) {
    switch (grade.toUpperCase()) {
      case 'A+':
        return 4.0;
      case 'A':
        return 3.75;
      case 'A-':
        return 3.5;
      case 'B+':
        return 3.25;
      case 'B':
        return 3.0;
      case 'C':
        return 2.5;
      case 'D':
        return 2.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student CGPA'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Grade (e.g., A, B+, etc)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  grades.add({
                    'subject': subjectController.text,
                    'grade': gradeController.text
                  });
                  subjectController.clear();
                  gradeController.clear();
                });
              },
              child: const Text('Add Grade'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: grades.map((g) => ListTile(
                  title: Text(g['subject']),
                  subtitle: Text('Grade: ${g['grade']}'),
                )).toList(),
              ),
            ),
            Text('CGPA: ${calculateCGPA().toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
