import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  List<Map<String, String>> _aboutUsData = [];
  bool _showAnswer1 = false;
  bool _showAnswer2 = false;
  bool _showAnswer3 = false;
  bool _showAnswer4 = false;

  @override
  void initState() {
    super.initState();
    _loadAboutUsData();
  }

  Future<void> _loadAboutUsData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _aboutUsData = List.generate(4, (index) {
        return {
          'name': prefs.getString('about_member${index + 1}_name') ?? 'Member ${index + 1}',
          'email': prefs.getString('about_member${index + 1}_email') ?? 'member${index + 1}@example.com',
          'image': 'assets/profile.png',
        };
      });
      _aboutUsData[0] = {'name': 'Member 1', 'email': 'paulbiplop100@gmail.com', 'image': 'assets/biplop.png'};
      _aboutUsData[1] = {'name': 'Member 2', 'email': 'sarafaria924@gmail.com', 'image': 'assets/sara.png'};
      _aboutUsData[2] = {'name': 'Member 3', 'email': 'tabassumanisha09@gmail.com', 'image': 'assets/anisha.png'};
      _aboutUsData[3] = {'name': 'Member 4', 'email': 'atiyafahmida42@gmail.com', 'image': 'assets/atiya.png'};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.deepPurple],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Welcome to Our Student-Teacher App!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Make it easy to interact classroom system vertually both the teaching and learning journey with our innovative app designed to connect students and teachers seamlessly. Enjoy personalized lessons, interactive tools, and a supportive community to enhance education at every step.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: _aboutUsData.asMap().entries.map((entry) {
                            final index = entry.key;
                            final member = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      member['image']!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey,
                                          child: const Icon(Icons.person, color: Colors.white70),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          member['name']!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          member['email']!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(
                  begin: 0.5,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ExpansionTile(
                              title: const Text('What is this app about?', style: TextStyle(color: Colors.white)),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('This app connects students and teachers for personalized learning experiences.', style: TextStyle(color: Colors.white70)),
                                ),
                              ],
                              onExpansionChanged: (expanded) => setState(() => _showAnswer1 = expanded),
                            ),
                            ExpansionTile(
                              title: const Text('How do I sign up?', style: TextStyle(color: Colors.white)),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Download the app and follow the registration steps with your email.', style: TextStyle(color: Colors.white70)),
                                ),
                              ],
                              onExpansionChanged: (expanded) => setState(() => _showAnswer2 = expanded),
                            ),
                            ExpansionTile(
                              title: const Text('Is it free to use?', style: TextStyle(color: Colors.white)),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Yes it is tatally free!', style: TextStyle(color: Colors.white70)),
                                ),
                              ],
                              onExpansionChanged: (expanded) => setState(() => _showAnswer3 = expanded),
                            ),
                            ExpansionTile(
                              title: const Text('How can I contact support?', style: TextStyle(color: Colors.white)),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Reach out via the support email listed in the app settings.', style: TextStyle(color: Colors.white70)),
                                ),
                              ],
                              onExpansionChanged: (expanded) => setState(() => _showAnswer4 = expanded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(
                  begin: 0.5,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.deepPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scaleXY(
                  begin: 0.9,
                  end: 1.0,
                  duration: 600.ms,
                  curve: Curves.bounceOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
