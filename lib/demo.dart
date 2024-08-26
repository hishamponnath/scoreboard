import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Progress Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CircularProgressScreen(),
    );
  }
}

class CircularProgressScreen extends StatefulWidget {
  const CircularProgressScreen({super.key});

  @override
  _CircularProgressScreenState createState() => _CircularProgressScreenState();
}

class _CircularProgressScreenState extends State<CircularProgressScreen> {
  @override
  Widget build(BuildContext context) {
 
    double progressValue = 0; // Initial progress value
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular Progress Bar Example'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: progressValue, // Dynamic progress value
              strokeWidth: 8.0,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          Text(
            '${(progressValue * 100).toInt()}%', // Display progress percentage
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
