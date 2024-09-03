import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _noDataFound = false; // Track if no data is found

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterStudents);
  }

  void _filterStudents() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = [];
      _noDataFound = false;
      students.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc['studentname'].toString().toLowerCase().contains(query)) {
            _filteredStudents.add(doc);
          }
        }

        if (_filteredStudents.isEmpty && query.isNotEmpty) {
          _noDataFound = true;
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

  Color _getIconColor(int score) {
    if (score >= 90) {
      return Colors.amber; // Gold
    } else if (score >= 70) {
      return const Color.fromARGB(255, 225, 225, 225); // Silver
    } else {
      return const Color.fromARGB(255, 161, 116, 100); // Bronze
    }
  }

  _launchUrl() async {
    const url = "https://aitrichacademy.com"; // Use lowercase for variable name
    final Uri uri = Uri.parse(url); // Convert the URL string to a Uri object

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
        flexibleSpace: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "image/appbar4.jpg"), // Replace with your image asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.blue[900]!
                  .withOpacity(0.7), // Background color with transparency
            ),
          ],
        ),
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
                  _noDataFound = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[300],
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 1, 28, 69),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('image/AitrichLogo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            _buildDrawerButton(context, "Mentor", '/login', Icons.person),
            _buildDrawerButton(context, "Events", '/events', Icons.event),
            // _buildDrawerButton(context, "About Us", '/aboutscreen', Icons.info),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _launchUrl,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.black),
                      SizedBox(width: 30),
                      Text(
                        "About Us",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

            if (_noDataFound) {
              return const Center(
                child: Text(
                  'No data found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            }

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
                Color iconColor = _getIconColor(percentageValue);

                return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                              'image/blue.jpg'), // Replace with your image path
                          fit: BoxFit.cover, // Adjust image fit
                        ),
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                        color: Colors.white.withOpacity(
                            0.8), // Optional background color with transparency
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        studentsSnap['studentname'],
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .white, // Adjust text color if necessary
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        studentsSnap['course'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors
                                              .white, // Adjust text color if necessary
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.shield,
                                size: 30,
                                color:
                                    iconColor, // Set icon color based on score
                              ),
                              const SizedBox(
                                width: 20,
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                progressBarColor),
                                      ),
                                    ),
                                    Text(
                                      '$percentageValue%',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Adjust text color if necessary
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildDrawerButton(
      BuildContext context, String title, String route, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 30),
              Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
