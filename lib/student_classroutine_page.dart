import 'package:flutter/material.dart';

class StudentClassRoutinePage extends StatefulWidget {
  const StudentClassRoutinePage({super.key});

  @override
  State<StudentClassRoutinePage> createState() => _StudentClassRoutinePageState();
}

class _StudentClassRoutinePageState extends State<StudentClassRoutinePage> {
  final List<Map<String, String>> routines = [];
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, String>> get filteredRoutines {
    String query = searchController.text.toLowerCase();
    return routines.where((routine) {
      return routine['subject']!.toLowerCase().contains(query) ||
          routine['day']!.toLowerCase().contains(query);
    }).toList();
  }

  void _addRoutine() {
    if (subjectController.text.isNotEmpty &&
        dayController.text.isNotEmpty &&
        timeController.text.isNotEmpty) {
      setState(() {
        routines.add({
          'subject': subjectController.text,
          'day': dayController.text,
          'time': timeController.text,
        });
        subjectController.clear();
        dayController.clear();
        timeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Routine'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: searchController, decoration: const InputDecoration(labelText: 'Search by Subject or Day'), onChanged: (_) => setState(() {})),
            const SizedBox(height: 10),
            TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject')),
            TextField(controller: dayController, decoration: const InputDecoration(labelText: 'Day')),
            TextField(controller: timeController, decoration: const InputDecoration(labelText: 'Time')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addRoutine, child: const Text('Add Class')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRoutines.length,
                itemBuilder: (context, index) {
                  final routine = filteredRoutines[index];
                  return Card(
                    child: ListTile(
                      title: Text('${routine['subject']} (${routine['time']})'),
                      subtitle: Text(routine['day']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
