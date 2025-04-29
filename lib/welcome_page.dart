import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text('Welcome Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${args['fullName']}!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Email: ${args['email']}'),
            Text('Gender: ${args['gender']}'),
            Text('Date of Birth: ${args['dob']?.toLocal()}'),
          ],
        ),
      ),
    );
  }
}
