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
    students.doc(docId).update(data).then((Value) => Navigator.pop(context));
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
                updatedstudents(docId);
              },
              child: const Text(
                "Update",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
