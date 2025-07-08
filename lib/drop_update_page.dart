import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class DropUpdatePage extends StatefulWidget {
  const DropUpdatePage({super.key});

  @override
  State<DropUpdatePage> createState() => _DropUpdatePageState();
}

class _DropUpdatePageState extends State<DropUpdatePage> {
  final TextEditingController _announcementController = TextEditingController();
  List<Map<String, dynamic>> announcements = [];
  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        announcements = (prefs.getStringList('announcements') ?? []).map((data) {
          final parts = data.split('|');
          return {
            'text': parts[0],
            'fileName': parts.length > 1 ? parts[1] : '',
            'fileType': parts.length > 2 ? parts[2] : '',
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading announcements: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _saveAnnouncements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final announcementData = announcements
          .map((a) => '${a['text']}|${a['fileName']}|${a['fileType']}')
          .toList();
      await prefs.setStringList('announcements', announcementData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving announcements: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _clearAnnouncements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('announcements');
      setState(() {
        announcements = [];
        _selectedFile = null;
        _announcementController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All announcements cleared'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error clearing announcements: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file selected'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _saveUpdate() {
    if (_announcementController.text.isEmpty && _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an announcement or select a file'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      announcements.add({
        'text': _announcementController.text,
        'fileName': _selectedFile?.name ?? '',
        'fileType': _selectedFile?.extension ?? '',
      });
      _saveAnnouncements();
      _announcementController.clear();
      _selectedFile = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Announcement saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _announcementController.dispose();
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
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.white70,
                    ),
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 20),
                  const Text(
                    'University Of Dhaka',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Drop Update',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Announcement',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _announcementController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Enter announcement here...',
                              hintStyle: const TextStyle(color: Colors.white54),
                              labelStyle: const TextStyle(color: Colors.white70),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ).animate().fadeIn(duration: 600.ms).slideX(
                            begin: -0.5,
                            end: 0,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedFile != null
                                      ? 'Selected: ${_selectedFile!.name}'
                                      : 'No file selected',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
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
                                  onPressed: _pickFile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Pick File',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 600.ms).slideX(
                            begin: 0.5,
                            end: 0,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Announcements',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: announcements.length,
                            itemBuilder: (context, index) {
                              final announcement = announcements[index];
                              return ListTile(
                                leading: announcement['fileName'].isNotEmpty
                                    ? const Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.white70,
                                )
                                    : null,
                                title: Text(
                                  announcement['text'].isNotEmpty
                                      ? announcement['text']
                                      : '(No text)',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: announcement['fileName'].isNotEmpty
                                    ? Text(
                                  'File: ${announcement['fileName']}',
                                  style: const TextStyle(
                                      color: Colors.white70),
                                )
                                    : null,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
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
                        onPressed: _saveUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 800.ms).scaleXY(
                      begin: 0.9,
                      end: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.redAccent, Colors.red],
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
                        onPressed: _clearAnnouncements,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Clear All Announcements',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 800.ms).scaleXY(
                      begin: 0.9,
                      end: 1.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
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
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 800.ms).scaleXY(
                      begin: 0.9,
                      end: 1.0,
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