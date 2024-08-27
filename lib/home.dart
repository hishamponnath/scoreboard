import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _filteredStudents = [];
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterStudents);
  }

  void _filterStudents() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = [];
      students.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc['studentname'].toString().toLowerCase().contains(query)) {
            _filteredStudents.add(doc);
          }
        }

        // Sort filtered students by score in descending order
        _filteredStudents.sort((a, b) {
          int scoreA = a['score'] is int
              ? a['score']
              : int.tryParse(a['score'].toString()) ?? 0;
          int scoreB = b['score'] is int
              ? b['score']
              : int.tryParse(b['score'].toString()) ?? 0;
          return scoreB.compareTo(scoreA);
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getProgressBarColor(int score) {
    if (score <= 33) {
      return Colors.red;
    } else if (score <= 66) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearchVisible
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by name...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
              )
            : const Text(
                "AITRICH ACADEMY",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
        backgroundColor: Colors.blue[900],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                  _filteredStudents.clear();
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 5, 47, 111)),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('image/AitrichLogo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            _buildDrawerButton(context, "Mentor", '/login'),
            _buildDrawerButton(context, "Events", '/events'),
            _buildDrawerButton(context, "About Us", '/about'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: students.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final data = _filteredStudents.isNotEmpty
                ? _filteredStudents
                : snapshot.data!.docs;

            // Sort the data by score in descending order
            data.sort((a, b) {
              int scoreA = a['score'] is int
                  ? a['score']
                  : int.tryParse(a['score'].toString()) ?? 0;
              int scoreB = b['score'] is int
                  ? b['score']
                  : int.tryParse(b['score'].toString()) ?? 0;
              return scoreB.compareTo(scoreA);
            });

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot studentsSnap = data[index];

                var scoreString = studentsSnap['score'].toString();
                double progressValue = 0.0;
                try {
                  progressValue = double.parse(scoreString) / 100;
                } catch (e) {
                  print("Error converting score to double: $e");
                }
                int percentageValue = (progressValue * 100).toInt();
                Color progressBarColor = _getProgressBarColor(percentageValue);

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    color: const Color.fromARGB(255, 229, 223, 255),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 85,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    value: progressValue,
                                    strokeWidth: 8.0,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        progressBarColor),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildDrawerButton(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 147, 192, 229),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
