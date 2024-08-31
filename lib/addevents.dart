import 'package:flutter/material.dart';

class addeventscreen extends StatefulWidget {
  const addeventscreen({super.key});

  @override
  State<addeventscreen> createState() => _addeventscreenState();
}

class _addeventscreenState extends State<addeventscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],
        title: const Text(
          "Add Events",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
    );
  }
}
