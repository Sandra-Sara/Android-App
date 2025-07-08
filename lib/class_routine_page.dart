import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassRoutinePage extends StatefulWidget {
  const ClassRoutinePage({super.key});

  @override
  State<ClassRoutinePage> createState() => _ClassRoutinePageState();
}

class _ClassRoutinePageState extends State<ClassRoutinePage> {
  List<Map<String, String>> routines = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final routineData = prefs.getStringList('routines') ?? [];
    setState(() {
      routines = routineData.map((data) {
        final parts = data.split(':');
        return {
          'subject': parts[0],
          'day': parts[1],
          'time': parts[2],
          'date': parts[3],
        };
      }).toList();
      if (routines.isEmpty) {
        routines = [
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
        _saveRoutines();
      }
    });
  }

  Future<void> _saveRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final routineData = routines.map((routine) => '${routine['subject']}:${routine['day']}:${routine['time']}:${routine['date']}').toList();
    await prefs.setStringList('routines', routineData);
  }

  List<Map<String, String>> get filteredRoutines {
    String query = searchController.text.trim().toLowerCase();
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(query)) {
      return routines.where((routine) => routine['date'] == query).toList();
    } else {
      return routines.where((routine) => routine['subject']!.toLowerCase().contains(query)).toList();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/dulogo.png',
                    height: 150,
                    width: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100, color: Colors.white70),
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 20),
                  const Text(
                    'University Of Dhaka',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Class Routine',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70),
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
                          TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              labelText: 'Search by Subject or Date (YYYY-MM-DD)',
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(color: Colors.black87),
                            ),
                            style: const TextStyle(color: Colors.black87),
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
                                  ...filteredRoutines.map((routine) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(searchController.text.trim())
                                          ? '${routine['subject']} at ${routine['time']}'
                                          : '${routine['subject']} on ${routine['day']} (${routine['date']}) at ${routine['time']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  )),
                              ],
                            ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredRoutines.length,
                            itemBuilder: (context, index) {
                              final routine = filteredRoutines[index];
                              return ListTile(
                                title: Text('${routine['subject']} (${routine['time']})'),
                                subtitle: Text('${routine['day']} - ${routine['date']}'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
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
        ),
      ),
    );
  }
}