import 'package:flutter/material.dart';
import 'dart:async'; // For periodic updates
import 'package:file_picker/file_picker.dart'; // For file picking functionality

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // Off-white background
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/dulogo1.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Student Dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              // Grid of Square Boxes
              GridView.count(
                crossAxisCount: 2, // 2 boxes per row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  OptionBox(
                    option: 'Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Attendance',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AttendancePage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Exam Schedule',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExamSchedulePage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Leave',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeavePage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Notification',
                    textColor: Colors.blue[700]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationPage()),
                      );
                    },
                  ),
                  OptionBox(
                    option: 'Classwork',
                    textColor: Colors.blue[700]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ClassworkPage()),
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

// Classwork Page
class ClassworkPage extends StatefulWidget {
  @override
  _ClassworkPageState createState() => _ClassworkPageState();
}

class _ClassworkPageState extends State<ClassworkPage> {
  String? _selectedFileName;
  String? _selectedCourse;
  final List<String> _courses = [
    'CSE 2201',
    'CSE 2202',
    'CSE 2203',
    'CSE 2204',
    'CSE 2205',
  ];

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.single.name != null) {
        setState(() {
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  void _submitFile() {
    if (_selectedFileName != null && _selectedCourse != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File $_selectedFileName submitted for $_selectedCourse!')),
      );
      setState(() {
        _selectedFileName = null;
        _selectedCourse = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a file and a course')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                'assets/dulogo1.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Classwork Submission',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              // File Submission Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Course:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedCourse,
                        hint: Text('Choose a course'),
                        isExpanded: true,
                        items: _courses.map((String course) {
                          return DropdownMenuItem<String>(
                            value: course,
                            child: Text(course),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCourse = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Select File:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedFileName ?? 'No file selected',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _pickFile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Browse',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Back Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
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

// Notification Page
class NotificationPage extends StatelessWidget {
  // Sample notification data
  final List<Map<String, String>> notifications = [
    {
      'date': '20/06/2025',
      'title': 'Class Cancellation',
      'message': 'CSE-2201 class scheduled for 21/06/2025 has been cancelled.'
    },
    {
      'date': '18/06/2025',
      'title': 'Exam Schedule Update',
      'message': 'New exam schedule for 2nd Year 2nd Semester has been published.'
    },
    {
      'date': '15/06/2025',
      'title': 'Hall Payment Reminder',
      'message': 'Please complete your hall payment by 30/06/2025.'
    },
    {
      'date': '10/06/2025',
      'title': 'Seminar Announcement',
      'message': 'AI in Education seminar on 12/06/2025 at 3 PM in CSE Dept.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                'assets/dulogo1.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              // Notifications Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: notifications.map((notification) {
                      return NotificationRow(
                        date: notification['date']!,
                        title: notification['title']!,
                        message: notification['message']!,
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Back Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
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

// Widget to display notification info in a row
class NotificationRow extends StatelessWidget {
  final String date;
  final String title;
  final String message;

  NotificationRow({required this.date, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Divider(height: 20, thickness: 1),
        ],
      ),
    );
  }
}

// Leave Page
class LeavePage extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final _toController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill "To" and "Subject" fields, leave "Body" empty
    _toController.text = 'registrar@du.ac.bd'; // Example recipient
    _subjectController.text = 'Application for Leave of Absence';
    _bodyController.text = ''; // Leave body empty for user to fill
  }

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _sendEmail() {
    // Simulate sending email (actual implementation requires backend integration)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email sent successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                'assets/dulogo1.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Leave Application',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              // Email Form Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _toController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter recipient email',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Subject:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter subject',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Body:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _bodyController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter email body',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        ),
                        maxLines: 15,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Send Button
              Center(
                child: ElevatedButton(
                  onPressed: _sendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Back Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
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

// Exam Schedule Page
class ExamSchedulePage extends StatelessWidget {
  // Sample exam schedule data
  final List<Map<String, String>> examSchedule = [
    {'date': '10/05/2025', 'subject': 'CSE-2201: Database Management Systems'},
    {'date': '12/05/2025', 'subject': 'CSE-2202: Design and Analysis of Algorithms'},
    {'date': '13/05/2025', 'subject': 'CSE-2203: Data and Telecommunication'},
    {'date': '14/05/2025', 'subject': 'CSE-2204: Computer Architecture and Organization'},
    {'date': '15/05/2025', 'subject': 'CSE-2205: Introduction Of Mechatronics'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                'assets/dulogo1.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Exam Schedule',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              // Exam Schedule Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: examSchedule.map((exam) {
                      return ExamScheduleRow(
                        date: exam['date']!,
                        subject: exam['subject']!,
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Back Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
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

// Widget to display exam schedule info in a row
class ExamScheduleRow extends StatelessWidget {
  final String date;
  final String subject;

  ExamScheduleRow({required this.date, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              subject,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// Attendance Page
class AttendancePage extends StatelessWidget {
  // Sample attendance data with courses
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
        title: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                'assets/dulogo1.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Attendance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              // Attendance Information Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
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
              SizedBox(height: 30),
              // Back Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
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

// Widget to display attendance info with View button
class AttendanceRow extends StatelessWidget {
  final String subject;
  final String courseId;

  AttendanceRow({required this.subject, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: TextStyle(
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
            child: Text(
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

// Class Attendance Page
class ClassAttendancePage extends StatelessWidget {
  final String courseId;

  ClassAttendancePage({required this.courseId});

  // Sample student data for each course with attendance percentage
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
        title: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                'assets/dulogo1.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Class Attendance - $courseName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              // Class Attendance Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
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
              SizedBox(height: 30),
              // Back Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to attendance page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
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

// Widget to display class attendance info in a row
class ClassAttendanceRow extends StatelessWidget {
  final String name;
  final String roll;
  final String percentage;

  ClassAttendanceRow({required this.name, required this.roll, required this.percentage});

  @override
  Widget build(BuildContext context) {
    // Parse percentage value (remove '%' and convert to double)
    final double percentageValue = double.tryParse(percentage.replaceAll('%', '')) ?? 0.0;

    // Determine color based on percentage
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
              style: TextStyle(
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
              style: TextStyle(fontSize: 16, color: Colors.black87),
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

// Profile Page
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false; // Toggle between view and edit modes

  // Initial profile data
  Map<String, String> _profileData = {
    'Name': 'Sara Faria Sundra',
    'Registration Number': '2022315933',
    'Department': 'Computer Science And Engineering',
    'Email': 'sarafaria924@gmail.com',
    'Phone': '+8801612345678',
    'Current Semester': '2nd Year 2nd Semester',
    'Attached Hall': 'Samsunnahar Hall',
    'Percentage': '92%',
  };

  // Text controllers for editable fields
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial profile data
    _controllers = {
      'Name': TextEditingController(text: _profileData['Name'] ?? ''),
      'Registration Number': TextEditingController(text: _profileData['Registration Number'] ?? ''),
      'Department': TextEditingController(text: _profileData['Department'] ?? ''),
      'Email': TextEditingController(text: _profileData['Email'] ?? ''),
      'Phone': TextEditingController(text: _profileData['Phone'] ?? ''),
      'Current Semester': TextEditingController(text: _profileData['Current Semester'] ?? ''),
      'Attached Hall': TextEditingController(text: _profileData['Attached Hall'] ?? ''),
      'Percentage': TextEditingController(text: _profileData['Percentage'] ?? ''),
    };
  }

  @override
  void dispose() {
    // Dispose of all controllers
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Save the updated data
        _controllers.forEach((key, controller) {
          _profileData[key] = controller.text.isNotEmpty ? controller.text : _profileData[key] ?? '';
        });
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Profile Picture
              ClipOval(
                child: Image.asset(
                  'assets/profile.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: 150,
                      color: Colors.grey,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Student Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              // Profile Information Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileInfoRow(
                        label: 'Name',
                        value: _profileData['Name'] ?? 'N/A',
                        isEditing: _isEditing,
                        controller: _controllers['Name']!,
                      ),
                      ProfileInfoRow(
                        label: 'Registration Number',
                        value: _profileData['Registration Number'] ?? 'N/A',
                        isEditing: _isEditing,
                        controller: _controllers['Registration Number']!,
                      ),
                      ProfileInfoRow(
                        label: 'Department',
                        value: _profileData['Department'] ?? 'N/A',
                        isEditing: _isEditing,
                        controller: _controllers['Department']!,
                      ),
                      ProfileInfoRow(
                        label: 'Email',
                        value: _profileData['Email'] ?? 'N/A',
                        isEditing: _isEditing,
                        controller: _controllers['Email']!,
                      ),
                      ProfileInfoRow(
                        label: 'Phone',
                        value: _profileData['Phone'] ?? 'N/A',
                        isEditing: _isEditing,
                        controller: _controllers['Phone']!,
                      ),
                      ProfileInfoRow(
                        label: 'Current Semester',
                        value: _profileData['Current Semester'] ?? 'N/A',
                        isEditing: _isEditing,
                        controller: _controllers['Current Semester']!,
                      ),
                      ProfileInfoRow(
                        label: 'Attached Hall',
                        value: _profileData['Attached Hall'] ?? 'N/A',
                        isEditing: _isEditing,
                        controller: _controllers['Attached Hall']!,
                      ),
                      ProfileInfoRow(
                        label: 'Percentage',
                        value: _profileData['Percentage'] ?? 'N/A',
                        isEditing: _isEditing,
                        controller: _controllers['Percentage']!,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Edit/Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _toggleEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Back Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Back to dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
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

// Widget to show profile information
class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditing;
  final TextEditingController controller;

  ProfileInfoRow({
    required this.label,
    required this.value,
    required this.isEditing,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: isEditing
                ? TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              ),
              style: TextStyle(fontSize: 16, color: Colors.black87),
            )
                : Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// Stateful Widget for each box with oscillation and instant color change
class OptionBox extends StatefulWidget {
  final String option;
  final Color textColor;
  final VoidCallback? onTap;

  OptionBox({required this.option, this.textColor = Colors.blue, this.onTap});

  @override
  _OptionBoxState createState() => _OptionBoxState();
}

class _OptionBoxState extends State<OptionBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    // Set up animation controller for oscillation
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // Scale animation for oscillation effect
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
      _isTapped = true; // Change color to blue on tap
    });
    // Instantly revert to white in the next frame
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _isTapped = false;
        });
        // Trigger the onTap callback if provided
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
            color: _isTapped ? Colors.blue : Colors.white, // Instant color change
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
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
                color: _isTapped ? Colors.white : widget.textColor, // Text color changes with background
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
