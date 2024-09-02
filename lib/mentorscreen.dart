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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  void deletestudent(docId) {
    students.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search by name...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
              )
            : const Text(
                'STUDENTS SCORE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        backgroundColor: Colors.blue[900],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: !_isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addevent');
            },
            icon: const Icon(Icons.camera_alt),
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: students.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final filteredDocs = snapshot.data!.docs.where((doc) {
              final studentName = doc['studentname'].toLowerCase();
              return studentName.contains(_searchQuery);
            }).toList();

            if (filteredDocs.isEmpty) {
              return Center(
                child: Text(
                  'No data found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot studentsSnap = filteredDocs[index];
                var scoreString = studentsSnap['score'].toString();
                double progressValue = 0.0;
                try {
                  progressValue = double.parse(scoreString) / 100;
                } catch (e) {
                  print("Error converting score to double: $e");
                }
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
                                      Color.fromARGB(255, 10, 29, 151),
                                    ),
                                  ),
                                ),
                                Text(
                                  '$percentageValue%',
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
