import 'package:flutter/material.dart';
import 'package:scoreboardapp/addstudents.dart';

class Mentor_View extends StatefulWidget {
  const Mentor_View({super.key});

  @override
  State<Mentor_View> createState() => _Mentor_ViewState();
}

class _Mentor_ViewState extends State<Mentor_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "STUDENTS SCORE",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const addstd()),
          );
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
