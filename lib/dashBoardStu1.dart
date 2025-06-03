import 'package:flutter/material.dart';

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
                  OptionBox(option: 'Profile'),
                  OptionBox(option: 'Attendance'),
                  OptionBox(option: 'Exam Schedule'),
                  OptionBox(option: 'Leave'),
                  OptionBox(option: 'Track Bus', textColor: Colors.blue[700]!), // Darker blue for distinction
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stateful Widget for each box with oscillation and instant color change
class OptionBox extends StatefulWidget {
  final String option;
  final Color textColor;

  OptionBox({required this.option, this.textColor = Colors.blue});

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