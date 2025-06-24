import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // For file picking
import 'dart:io'; // For File class (though not used on web)
import 'dart:typed_data'; // For Uint8List

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher Student App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TeacherDashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DashboardTile(
            title: 'See Student Attendance',
            icon: Icons.check_circle_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentAttendancePage()),
              );
            },
          ),
          DashboardTile(
            title: 'See Student CGPA',
            icon: Icons.school,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentCGPAPage()),
              );
            },
          ),
          DashboardTile(
            title: 'See Class Routine',
            icon: Icons.calendar_today,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentClassRoutinePage()),
              );
            },
          ),
          DashboardTile(
            title: 'Drop Update',
            icon: Icons.delete_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DropUpdatePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  final List<Map<String, dynamic>> students = [
    {'name': 'Anisha Tabassum', 'attendance': 85},
    {'name': 'Atiya Fahmida', 'attendance': 60},
    {'name': 'Biplop Pal', 'attendance': 45},
    {'name': 'Sara Faria', 'attendance': 92},
  ];

  void updateAttendance(int index, bool increase) {
    setState(() {
      if (increase) {
        students[index]['attendance'] = (students[index]['attendance'] + 5).clamp(0, 100);
      } else {
        students[index]['attendance'] = (students[index]['attendance'] - 5).clamp(0, 100);
      }
    });
  }

  void addStudent(String name, int attendance) {
    setState(() {
      students.add({'name': name, 'attendance': attendance});
    });
  }

  void showAddStudentDialog() {
    String newName = '';
    String attendanceText = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Student Name'), onChanged: (value) => newName = value),
            TextField(
              decoration: const InputDecoration(labelText: 'Attendance (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => attendanceText = value,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (newName.isNotEmpty && int.tryParse(attendanceText) != null) {
                final attendance = int.parse(attendanceText).clamp(0, 100);
                addStudent(newName, attendance);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Color getAttendanceColor(int percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Attendance - CSE 2201'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset('assets/dulogo1.png', height: 100), // Using the asset from pubspec.yaml
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final name = student['name'] as String;
                final attendance = student['attendance'] as int;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    leading: Text('${index + 1}', style: const TextStyle(fontSize: 18)),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$attendance%', style: TextStyle(fontSize: 16, color: getAttendanceColor(attendance))),
                        const SizedBox(width: 10),
                        IconButton(icon: const Icon(Icons.remove), onPressed: () => updateAttendance(index, false)),
                        IconButton(icon: const Icon(Icons.add), onPressed: () => updateAttendance(index, true)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
            child: const Text('Back', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddStudentDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        tooltip: 'Add Student',
      ),
    );
  }
}

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
    if (grades.isEmpty) return 0.0;
    double total = 0;
    for (var g in grades) {
      total += _gradeToPoint(g['grade']);
    }
    return total / grades.length;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student CGPA'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject')),
            TextField(controller: gradeController, decoration: const InputDecoration(labelText: 'Grade (e.g., A, B+, etc)')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  grades.add({'subject': subjectController.text, 'grade': gradeController.text});
                  subjectController.clear();
                  gradeController.clear();
                });
              },
              child: const Text('Add Grade'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: grades.map((g) => ListTile(title: Text(g['subject']), subtitle: Text('Grade: ${g['grade']}'))).toList(),
              ),
            ),
            Text('CGPA: ${calculateCGPA().toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class StudentClassRoutinePage extends StatefulWidget {
  const StudentClassRoutinePage({super.key});

  @override
  State<StudentClassRoutinePage> createState() => _StudentClassRoutinePageState();
}

class _StudentClassRoutinePageState extends State<StudentClassRoutinePage> {
  final List<Map<String, String>> routines = [
    {'subject': 'CSE 2201', 'day': 'Monday', 'time': '9:00 AM - 11:00 AM', 'date': '2025-06-02'},
    {'subject': 'CSE 2105', 'day': 'Tuesday', 'time': '1:00 PM - 3:00 PM', 'date': '2025-06-03'},
    {'subject': 'CSE 2203', 'day': 'Wednesday', 'time': '10:00 AM - 12:00 PM', 'date': '2025-06-04'},
    {'subject': 'CSE 3104', 'day': 'Thursday', 'time': '2:00 PM - 4:00 PM', 'date': '2025-06-05'},
    {'subject': 'CSE 4205', 'day': 'Sunday', 'time': '11:00 AM - 1:00 PM', 'date': '2025-06-06'},
    {'subject': 'CSE 2203', 'day': 'Monday', 'time': '9:00 AM - 11:00 AM', 'date': '2025-06-09'},
    {'subject': 'CSE 2201', 'day': 'Tuesday', 'time': '1:00 PM - 3:00 PM', 'date': '2025-06-10'},
    {'subject': 'CSE 3104', 'day': 'Wednesday', 'time': '10:00 AM - 12:00 PM', 'date': '2025-06-11'},
    {'subject': 'CSE 2105', 'day': 'Thursday', 'time': '2:00 PM - 4:00 PM', 'date': '2025-06-12'},
    {'subject': 'CSE 4205', 'day': 'Sunday', 'time': '11:00 AM - 1:00 PM', 'date': '2025-06-13'},
    {'subject': 'CSE 2105', 'day': 'Monday', 'time': '9:00 AM - 11:00 AM', 'date': '2025-06-16'},
    {'subject': 'CSE 4205', 'day': 'Tuesday', 'time': '1:00 PM - 3:00 PM', 'date': '2025-06-17'},
    {'subject': 'CSE 2203', 'day': 'Wednesday', 'time': '10:00 AM - 12:00 PM', 'date': '2025-06-18'},
    {'subject': 'CSE 3104', 'day': 'Thursday', 'time': '2:00 PM - 4:00 PM', 'date': '2025-06-19'},
    {'subject': 'CSE 2201', 'day': 'Sunday', 'time': '11:00 AM - 1:00 PM', 'date': '2025-06-20'},
    {'subject': 'CSE 3104', 'day': 'Monday', 'time': '9:00 AM - 11:00 AM', 'date': '2025-06-23'},
    {'subject': 'CSE 4205', 'day': 'Tuesday', 'time': '1:00 PM - 3:00 PM', 'date': '2025-06-24'},
    {'subject': 'CSE 2203', 'day': 'Wednesday', 'time': '10:00 AM - 12:00 PM', 'date': '2025-06-25'},
    {'subject': 'CSE 2201', 'day': 'Thursday', 'time': '2:00 PM - 4:00 PM', 'date': '2025-06-26'},
    {'subject': 'CSE 2105', 'day': 'Sunday', 'time': '11:00 AM - 1:00 PM', 'date': '2025-06-27'},
    {'subject': 'CSE 2201', 'day': 'Monday', 'time': '9:00 AM - 11:00 PM', 'date': '2025-06-30'},
  ];
  final TextEditingController searchController = TextEditingController();

  List<Map<String, String>> get filteredRoutines {
    String query = searchController.text.trim().toLowerCase();
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(query)) {
      return routines.where((routine) => routine['date'] == query).toList();
    } else {
      return routines.where((routine) => routine['subject']!.toLowerCase().contains(query)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Routine'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search by Subject or Date (YYYY-MM-DD)'),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            if (searchController.text.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(searchController.text.trim())
                        ? 'Subjects on ${searchController.text}:'
                        : 'Schedule for ${searchController.text}:',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  if (filteredRoutines.isEmpty)
                    const Text(
                      'No class found',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  else
                    ...filteredRoutines.map((routine) => Text(
                      RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(searchController.text.trim())
                          ? '${routine['subject']} at ${routine['time']}'
                          : '${routine['subject']} on ${routine['day']} (${routine['date']}) at ${routine['time']}',
                    )).toList(),
                ],
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRoutines.length,
                itemBuilder: (context, index) {
                  final routine = filteredRoutines[index];
                  return Card(
                    child: ListTile(
                      title: Text('${routine['subject']} (${routine['time']})'),
                      subtitle: Text('${routine['day']} - ${routine['date']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropUpdatePage extends StatefulWidget {
  const DropUpdatePage({super.key});

  @override
  State<DropUpdatePage> createState() => _DropUpdatePageState();
}

class _DropUpdatePageState extends State<DropUpdatePage> {
  final TextEditingController _announcementController = TextEditingController();
  Uint8List? _selectedFileBytes; // Use Uint8List to store file bytes
  String? _fileName; // Store file name for display

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFileBytes = result.files.single.bytes; // Use bytes instead of path
          _fileName = result.files.single.name; // Store the file name
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected or operation canceled')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  void _saveUpdate() {
    if (_announcementController.text.isNotEmpty || _selectedFileBytes != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update saved successfully! (File upload requires backend integration)')),
      );
      _announcementController.clear();
      setState(() {
        _selectedFileBytes = null;
        _fileName = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an announcement or select a file')),
      );
    }
  }

  @override
  void dispose() {
    _announcementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drop Update'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Announcement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _announcementController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter class announcement here...',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload File',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Select File'),
              ),
              if (_fileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('Selected File: $_fileName'),
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveUpdate,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
                  child: const Text('Save Update', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
                  child: const Text('Back', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}