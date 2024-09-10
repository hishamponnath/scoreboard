import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  TextEditingController stdName = TextEditingController();
  TextEditingController stdCourse = TextEditingController();
  TextEditingController stdScore = TextEditingController();
  List<TextEditingController> descriptionControllers = [
    TextEditingController()
  ]; // List of controllers for descriptions

  // Function to capitalize the first letter
  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  // Function to add a new description field
  void addDescriptionField() {
    setState(() {
      descriptionControllers.add(TextEditingController());
    });
  }

  // Function to remove a description field
  void removeDescriptionField(int index) {
    setState(() {
      if (descriptionControllers.length > 1) {
        descriptionControllers.removeAt(index);
      }
    });
  }

  // Function to save data to Firestore
  void addStudent() {
    final descriptions =
        descriptionControllers.map((controller) => controller.text).toList();
    final data = {
      'studentname': stdName.text,
      'course': stdCourse.text,
      'score': stdScore.text,
      'descriptions': descriptions, // Save descriptions as a list
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: stdName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Student Name",
                  ),
                  onChanged: (value) {
                    stdName.value = stdName.value.copyWith(
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
                  controller: stdCourse,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Course",
                  ),
                  onChanged: (value) {
                    stdCourse.value = stdCourse.value.copyWith(
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
                  controller: stdScore,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Score",
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      int enteredValue = int.tryParse(value) ?? 0;
                      // Restrict value to below 100
                      if (enteredValue > 100) {
                        stdScore.text = '100';
                        stdScore.selection = TextSelection.fromPosition(
                            const TextPosition(offset: 3));
                      }
                    }
                  },
                ),
              ),
              // Dynamic description fields
              Column(
                children: List.generate(descriptionControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: descriptionControllers[index],
                            maxLines: 2,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Description",
                            ),
                            onChanged: (value) {
                              descriptionControllers[index].value =
                                  descriptionControllers[index].value.copyWith(
                                        text: capitalize(value),
                                        selection: TextSelection.collapsed(
                                            offset: capitalize(value).length),
                                      );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            removeDescriptionField(index);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
              // Button to add more description fields
              TextButton.icon(
                onPressed: addDescriptionField,
                icon: const Icon(Icons.add, color: Colors.blue),
                label: const Text("Add More Descriptions",
                    style: TextStyle(color: Colors.blue)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  int scoreValue = int.tryParse(stdScore.text) ?? 0;
                  if (scoreValue <= 100) {
                    addStudent();
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
      ),
    );
  }
}
