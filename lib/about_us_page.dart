import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  final List<Map<String, String>> teamMembers = [
    {
      'name': 'John Doe',
      'roll': 'CSE12345',
      'email': 'john.doe@example.com',

    },
    {
      'name': 'Jane Smith',
      'roll': 'CSE67890',
      'email': 'jane.smith@example.com',

    },
    // Add more team members as needed
  ];

  _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch email app';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Name: Flutter App', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            ...teamMembers.map((teamMember) {
              return ListTile(
                leading: CircleAvatar(backgroundImage: AssetImage(teamMember['photo']!)),
                title: Text(teamMember['name']!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Roll: ${teamMember['roll']}'),
                    Text('Email: ${teamMember['email']}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.email),
                  onPressed: () => _launchEmail(teamMember['email']!),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
