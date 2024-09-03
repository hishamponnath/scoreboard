import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: iconsdemo(),
  ));
}

class iconsdemo extends StatelessWidget {
  const iconsdemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              size: 100,
              Icons.shield,
              color: Color.fromARGB(255, 249, 212, 5),
            ),
            Icon(
              size: 100,
              Icons.shield,
              color: Color.fromARGB(255, 171, 170, 168),
            ),
            Icon(
              size: 100,
              Icons.shield,
              color: Color.fromARGB(255, 134, 62, 4),
            ),
            Row(
              children: [
                Text(
                  "Hisham",
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                Icon(
                  Icons.macro_off,
                  color: Colors.white,
                  size: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
