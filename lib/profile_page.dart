import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  Map<String, String> _profileData = {
    'Name': 'unknown',
    'Registration Number': '2022315933',
    'Department': 'enter your dept name',
    'Email': 'your profile',
    'Phone': 'your phone number',
    'Current Semester': 'your year and symester',
    'Attached Hall': 'enter hall name',
    'Percentage': '0%',
  };
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      'Name': TextEditingController(text: _profileData['Name']),
      'Registration Number': TextEditingController(text: _profileData['Registration Number']),
      'Department': TextEditingController(text: _profileData['Department']),
      'Email': TextEditingController(text: _profileData['Email']),
      'Phone': TextEditingController(text: _profileData['Phone']),
      'Current Semester': TextEditingController(text: _profileData['Current Semester']),
      'Attached Hall': TextEditingController(text: _profileData['Attached Hall']),
      'Percentage': TextEditingController(text: _profileData['Percentage']),
    };
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileData = {
        'Name': prefs.getString('profile_name') ?? _profileData['Name']!,
        'Registration Number': prefs.getString('profile_reg') ?? _profileData['Registration Number']!,
        'Department': prefs.getString('profile_dept') ?? _profileData['Department']!,
        'Email': prefs.getString('profile_email') ?? _profileData['Email']!,
        'Phone': prefs.getString('profile_phone') ?? _profileData['Phone']!,
        'Current Semester': prefs.getString('profile_semester') ?? _profileData['Current Semester']!,
        'Attached Hall': prefs.getString('profile_hall') ?? _profileData['Attached Hall']!,
        'Percentage': prefs.getString('profile_percentage') ?? _profileData['Percentage']!,
      };
      _controllers.forEach((key, controller) {
        controller.text = _profileData[key]!;
      });
    });
  }

  Future<void> _saveProfile() async {
    var SharedPreferences;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _controllers['Name']!.text);
    await prefs.setString('profile_reg', _controllers['Registration Number']!.text);
    await prefs.setString('profile_dept', _controllers['Department']!.text);
    await prefs.setString('profile_email', _controllers['Email']!.text);
    await prefs.setString('profile_phone', _controllers['Phone']!.text);
    await prefs.setString('profile_semester', _controllers['Current Semester']!.text);
    await prefs.setString('profile_hall', _controllers['Attached Hall']!.text);
    await prefs.setString('profile_percentage', _controllers['Percentage']!.text);
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        _controllers.forEach((key, controller) {
          _profileData[key] = controller.text.isNotEmpty ? controller.text : _profileData[key]!;
        });
        _saveProfile();
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Student Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'University Of Dhaka',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Student Profile',
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
                    children: [
                      ProfileInfoRow(
                        label: 'Name',
                        value: _profileData['Name']!,
                        isEditing: _isEditing,
                        controller: _controllers['Name']!,
                      ),
                      ProfileInfoRow(
                        label: 'Registration Number',
                        value: _profileData['Registration Number']!,
                        isEditing: _isEditing,
                        controller: _controllers['Registration Number']!,
                      ),
                      ProfileInfoRow(
                        label: 'Department',
                        value: _profileData['Department']!,
                        isEditing: _isEditing,
                        controller: _controllers['Department']!,
                      ),
                      ProfileInfoRow(
                        label: 'Email',
                        value: _profileData['Email']!,
                        isEditing: _isEditing,
                        controller: _controllers['Email']!,
                      ),
                      ProfileInfoRow(
                        label: 'Phone',
                        value: _profileData['Phone']!,
                        isEditing: _isEditing,
                        controller: _controllers['Phone']!,
                      ),
                      ProfileInfoRow(
                        label: 'Current Semester',
                        value: _profileData['Current Semester']!,
                        isEditing: _isEditing,
                        controller: _controllers['Current Semester']!,
                      ),
                      ProfileInfoRow(
                        label: 'Attached Hall',
                        value: _profileData['Attached Hall']!,
                        isEditing: _isEditing,
                        controller: _controllers['Attached Hall']!,
                      ),
                      ProfileInfoRow(
                        label: 'Percentage',
                        value: _profileData['Percentage']!,
                        isEditing: _isEditing,
                        controller: _controllers['Percentage']!,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _toggleEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditing;
  final TextEditingController controller;

  const ProfileInfoRow({
    super.key,
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: isEditing
                ? TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            )
                : Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}