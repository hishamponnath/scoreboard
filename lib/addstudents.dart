import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addstd extends StatefulWidget {
  const addstd({super.key});

  @override
  State<addstd> createState() => _addstdState();
}

class _addstdState extends State<addstd> {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  TextEditingController stdname = TextEditingController();
  TextEditingController stdcourse = TextEditingController();
  TextEditingController stdscore = TextEditingController();

  void addstudent() {
    final data = {
      'studentname': stdname.text,
      'course': stdcourse.text,
      'score': stdscore.text,
    };
    students.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: const Text(
          "ADD STUDENTS",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: stdname,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Student Name")),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: stdcourse,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Course")),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: stdscore,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Score")),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                addstudent();
                Navigator.pop(context);
              },
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
