import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final dynamic studentName;
  final dynamic course;
  final dynamic score;
  final List<String> descriptions;

  const DetailScreen({
    super.key,
    required this.studentName,
    required this.course,
    required this.score,
    required this.descriptions,
  });

  // This method determines the progress bar color
  Color _getProgressBarColor(int score) {
    if (score <= 33) {
      return Colors.red;
    } else if (score <= 66) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  // This method determines the shield icon color
  Color _getIconColor(int score) {
    if (score >= 90) {
      return Colors.amber; // Gold
    } else if (score >= 70) {
      return const Color.fromARGB(255, 195, 192, 192); // Silver
    } else {
      return const Color.fromARGB(255, 161, 116, 100); // Bronze
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the progress value for the CircularProgressIndicator
    double progressValue = 0.0;
    try {
      progressValue = double.parse(score.toString()) / 100;
    } catch (e) {
      print("Error converting score to double: $e");
    }
    int percentageValue = (progressValue * 100).toInt();
    Color progressBarColor = _getProgressBarColor(percentageValue);
    Color iconColor = _getIconColor(percentageValue);

    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],
        title: Text(
          studentName,
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.shield,
              size: 30,
              color: iconColor, // Set icon color based on score
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Wrapping Text with Expanded to prevent overflow
                Expanded(
                  child: Text(
                    'Course: $course',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow
                        .ellipsis, // Adds ellipsis if text is too long
                  ),
                ),
                // Circular progress bar displaying the score
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: progressValue,
                            strokeWidth: 6.0,
                            backgroundColor: Colors.grey.shade300,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(progressBarColor),
                          ),
                        ),
                        Text(
                          '$percentageValue%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Total Score : $score',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: descriptions.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Colors.black, width: 1), // Black border
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        descriptions[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
