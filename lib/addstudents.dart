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

  // Function to capitalize the first letter
  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
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
                  border: OutlineInputBorder(),
                  label: Text("Student Name"),
                ),
                onChanged: (value) {
                  // Capitalize the first letter of the input
                  stdname.value = stdname.value.copyWith(
                    text: capitalize(value),
                    selection: TextSelection.collapsed(
                        offset: capitalize(value).length),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: stdcourse,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Course"),
                ),
                onChanged: (value) {
                  // Capitalize the first letter of the input
                  stdcourse.value = stdcourse.value.copyWith(
                    text: capitalize(value),
                    selection: TextSelection.collapsed(
                        offset: capitalize(value).length),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: stdscore,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Score"),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    int enteredValue = int.tryParse(value) ?? 0;

                    // Restrict value to below 100
                    if (enteredValue > 100) {
                      stdscore.text = '100';
                      stdscore.selection = TextSelection.fromPosition(
                        const TextPosition(offset: 3),
                      );
                    }
                  }
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                int scoreValue = int.tryParse(stdscore.text) ?? 0;

                if (scoreValue <= 100) {
                  addstudent();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Score cannot be above 100.'),
                    ),
                  );
                }
              },
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
