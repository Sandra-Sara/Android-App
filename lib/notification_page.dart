import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
   NotificationPage({super.key});

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
        title: const Text('Notifications'),
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
              const Text(
                'Notifications',
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

class NotificationRow extends StatelessWidget {
  final String date;
  final String title;
  final String message;

  const NotificationRow({super.key, required this.date, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Divider(height: 20, thickness: 1),
        ],
      ),
    );
  }
}