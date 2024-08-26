import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

                  // Get the score from Firestore as a string
                  var scoreString = studentsSnap['score'].toString();

                  // Convert the string to double for progress bar
                  double progressValue = 0.0;
                  try {
                    // Convert the string to a double and divide by 100 to get the progress value
                    progressValue = double.parse(scoreString) / 100;
                  } catch (e) {
                    // Handle conversion error
                    print("Error converting score to double: $e");
                  }

                  // Calculate percentage value for display
                  int percentageValue = (progressValue * 100).toInt();

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 4,
                      color: const Color.fromARGB(255, 204, 209, 213),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: const Color.fromARGB(255, 206, 205, 205),
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(
                                      value: progressValue,
                                      strokeWidth: 8.0,
                                      backgroundColor: Colors.grey.shade300,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color.fromARGB(255, 10, 29, 151)),
                                    ),
                                  ),
                                  Text(
                                    '$percentageValue%', // Display progress percentage
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      studentsSnap['studentname'],
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      studentsSnap['course'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
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
                                  icon: const Icon(Icons.edit),
                                  iconSize: 30,
                                  color: Colors.blue,
                                ),
                                IconButton(
                                  onPressed: () {
                                    deletestudent(studentsSnap.id);
                                  },
                                  icon: const Icon(Icons.delete),
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
            ); //set a lottie for no data
          }),
    );
  }
}
