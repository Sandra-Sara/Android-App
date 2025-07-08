import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
   AttendancePage({super.key});

  final List<Map<String, String>> attendanceData = [
    {'subject': 'CSE 2201', 'id': 'cse2201'},
    {'subject': 'CSE 2202', 'id': 'cse2202'},
    {'subject': 'CSE 2203', 'id': 'cse2203'},
    {'subject': 'CSE 2204', 'id': 'cse2204'},
    {'subject': 'CSE 2205', 'id': 'cse2205'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Attendance'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/dulogo1.png',
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
                'Attendance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: attendanceData.map((data) {
                      return AttendanceRow(
                        subject: data['subject']!,
                        courseId: data['id']!,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceRow extends StatelessWidget {
  final String subject;
  final String courseId;

  const AttendanceRow({super.key, required this.subject, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassAttendancePage(courseId: courseId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: const Text(
              'View',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClassAttendancePage extends StatelessWidget {
  final String courseId;

   ClassAttendancePage({super.key, required this.courseId});

  final Map<String, List<Map<String, String>>> classData = {
    'cse2201': [
      {'name': 'Anisha Tabassum', 'roll': '1', 'percentage': '85%'},
      {'name': 'Atiya Fahmida Nousin', 'roll': '2', 'percentage': '92%'},
      {'name': 'Biplop Pal', 'roll': '3', 'percentage': '75%'},
      {'name': 'Sara Faria Sundra', 'roll': '4', 'percentage': '90%'},
    ],
    'cse2202': [
      {'name': 'Anisha Tabassum', 'roll': '1', 'percentage': '80%'},
      {'name': 'Atiya Fahmida', 'roll': '2', 'percentage': '88%'},
      {'name': 'Biplop Pal', 'roll': '3', 'percentage': '70%'},
      {'name': 'Sara Faria Sundra', 'roll': '4', 'percentage': '95%'},
    ],
    'cse2203': [
      {'name': 'Anisha Tabassum', 'roll': '1', 'percentage': '82%'},
      {'name': 'Atiya Fahmida Nousin', 'roll': '2', 'percentage': '90%'},
      {'name': 'Biplop Pal', 'roll': '3', 'percentage': '78%'},
      {'name': 'Sara Faria Sundra', 'roll': '4', 'percentage': '93%'},
    ],
    'cse2204': [
      {'name': 'Anisha Tabassum', 'roll': '1', 'percentage': '85%'},
      {'name': 'Atiya Fahmida Nousin', 'roll': '2', 'percentage': '91%'},
      {'name': 'Biplop Pal', 'roll': '3', 'percentage': '76%'},
      {'name': 'Sara Faria Sundra', 'roll': '4', 'percentage': '88%'},
    ],
    'cse2205': [
      {'name': 'Anisha Tabassum', 'roll': '1', 'percentage': '87%'},
      {'name': 'Atiya Fahmida Nousin', 'roll': '2', 'percentage': '94%'},
      {'name': 'Biplop Pal', 'roll': '3', 'percentage': '80%'},
      {'name': 'Sara Faria Sundra', 'roll': '4', 'percentage': '96%'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final courseData = classData[courseId] ?? [];
    final String courseName = {
      'cse2201': 'CSE 2201',
      'cse2202': 'CSE 2202',
      'cse2203': 'CSE 2203',
      'cse2204': 'CSE 2204',
      'cse2205': 'CSE 2205',
    }[courseId] ?? 'Unknown Course';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Class Attendance - $courseName'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                'Class Attendance - $courseName',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: courseData.map((student) {
                      return ClassAttendanceRow(
                        name: student['name']!,
                        roll: student['roll']!,
                        percentage: student['percentage']!,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClassAttendanceRow extends StatelessWidget {
  final String name;
  final String roll;
  final String percentage;

  const ClassAttendanceRow({super.key, required this.name, required this.roll, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final double percentageValue = double.tryParse(percentage.replaceAll('%', '')) ?? 0.0;
    Color percentageColor;
    if (percentageValue >= 80) {
      percentageColor = Colors.green;
    } else if (percentageValue >= 50) {
      percentageColor = Colors.orange;
    } else {
      percentageColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              roll,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              percentage,
              style: TextStyle(
                fontSize: 16,
                color: percentageColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
