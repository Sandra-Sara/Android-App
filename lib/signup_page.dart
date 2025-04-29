import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _gender = 'Male';
  DateTime? _dob;
  bool _termsAccepted = false;

  final List<Map<String, String>> validCredentials = [
    {'email': 'user1@example.com', 'password': 'password1'},
    {'email': 'user2@example.com', 'password': 'password2'},
    {'email': 'user3@example.com', 'password': 'password3'},
  ];

  bool _validateCredentials(String email, String password) {
    for (var validCredential in validCredentials) {
      if (validCredential['email'] == email && validCredential['password'] == password) {
        return true;
      }
    }
    return false;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      if (_validateCredentials(_emailController.text, _passwordController.text)) {
        Navigator.pushReplacementNamed(
          context,
          '/welcome',
          arguments: {
            'fullName': _fullNameController.text,
            'email': _emailController.text,
            'gender': _gender,
            'dob': _dob,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      }
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You must accept the terms and conditions')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) => value != null && value.length >= 3 ? null : 'Full name must be at least 3 characters',
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value != null && value.contains('@') && value.contains('.') ? null : 'Enter a valid email',
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value != null && value.length >= 6 ? null : 'Password must be at least 6 characters',
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem<String>(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (value) => setState(() => _gender = value!),
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              ListTile(
                title: Text('Date of Birth'),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) setState(() => _dob = pickedDate);
                  },
                ),
              ),
              CheckboxListTile(
                title: Text('Accept Terms & Conditions'),
                value: _termsAccepted,
                onChanged: (value) => setState(() => _termsAccepted = value!),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
