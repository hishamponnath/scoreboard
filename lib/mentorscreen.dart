import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoreboardapp/addstudents.dart';
import 'package:scoreboardapp/updatestd.dart';
import 'package:lottie/lottie.dart';

class Mentor_View extends StatefulWidget {
  const Mentor_View({super.key});

  @override
  State<Mentor_View> createState() => _Mentor_ViewState();
}

class _Mentor_ViewState extends State<Mentor_View> {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  void deletestudent(docId) {
    students.doc(docId).delete();
  }

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
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: StreamBuilder(
          stream: students.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot studentsSnap =
                      snapshot.data.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 4,
                      color: const Color.fromARGB(255, 204, 209, 213),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: const Color.fromARGB(255, 206, 205, 205),
                      child: Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40,
                                child: Text(studentsSnap['score'].toString()),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  studentsSnap['studentname'],
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  studentsSnap['course'],
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/update',
                                      arguments: {
                                        'studentname':
                                            studentsSnap['studentname'],
                                        'course': studentsSnap['course'],
                                        'score': studentsSnap['score'],
                                        'id': studentsSnap.id,
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                  iconSize: 30,
                                  color: Colors.blue,
                                ),
                                IconButton(
                                  onPressed: () {
                                    deletestudent(studentsSnap.id);
                                  },
                                  icon: Icon(Icons.delete),
                                  iconSize: 30,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: Container(),
            ); //set a lotti for no data
          }),
    );
  }
}
