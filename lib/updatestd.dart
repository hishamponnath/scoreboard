import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class updatestd extends StatefulWidget {
  const updatestd({super.key});

  @override
  State<updatestd> createState() => _updatestdState();
}

class _updatestdState extends State<updatestd> {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  TextEditingController stdname = TextEditingController();
  TextEditingController stdcourse = TextEditingController();
  TextEditingController stdscore = TextEditingController();

  void updatedstudents(docId) {
    final data = {
      'studentname': stdname.text,
      'course': stdcourse.text,
      'score': stdscore.text,
    };

    // Ensure score is below 100 before updating
    int scoreValue = int.tryParse(stdscore.text) ?? 0;
    if (scoreValue <= 100) {
      students.doc(docId).update(data).then((value) => Navigator.pop(context));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Score cannot be above 100.'),
        ),
      );
    }
  }

  // Function to capitalize the first letter and prevent lowering it
  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    stdname.text = args['studentname'];
    stdcourse.text = args['course'];
    stdscore.text = args['score'].toString();
    final docId = args['id'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: const Text(
          "UPDATE STUDENTS",
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
                  stdname.value = stdname.value.copyWith(
                    text: capitalizeFirstLetter(value),
                    selection: TextSelection.collapsed(
                        offset: capitalizeFirstLetter(value).length),
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
                  stdcourse.value = stdcourse.value.copyWith(
                    text: capitalizeFirstLetter(value),
                    selection: TextSelection.collapsed(
                        offset: capitalizeFirstLetter(value).length),
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
                updatedstudents(docId);
              },
              child: const Text(
                "Update",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
