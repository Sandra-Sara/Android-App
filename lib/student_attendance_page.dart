import 'package:flutter/material.dart';

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
        students[index]['attendance'] =
            (students[index]['attendance'] + 5).clamp(0, 100);
      } else {
        students[index]['attendance'] =
            (students[index]['attendance'] - 5).clamp(0, 100);
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
            TextField(
              decoration: const InputDecoration(labelText: 'Student Name'),
              onChanged: (value) {
                newName = value;
              },
            ),
            TextField(
              decoration:
              const InputDecoration(labelText: 'Attendance (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                attendanceText = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newName.isNotEmpty &&
                  int.tryParse(attendanceText) != null) {
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
          const Text(
            'University Of Dhaka',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final name = student['name'] as String;
                final attendance = student['attendance'] as int;

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$attendance%',
                          style: TextStyle(
                            fontSize: 16,
                            color: getAttendanceColor(attendance),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => updateAttendance(index, false),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => updateAttendance(index, true),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text(
              'Back',
              style: TextStyle(fontSize: 18),
            ),
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
