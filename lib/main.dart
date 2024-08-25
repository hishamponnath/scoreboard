import 'package:flutter/material.dart';
import 'package:scoreboardapp/addstudents.dart';
import 'package:scoreboardapp/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoreboardapp/mentor_login.dart';
import 'package:scoreboardapp/mentorscreen.dart';
import 'package:scoreboardapp/updatestd.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(scoreapp());
}

class scoreapp extends StatelessWidget {
  const scoreapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        '/add':(context) => addstd(),
        '/login':(context)=> LoginScreen(),
        '/mentorview':(context)=> Mentor_View(),
        '/update':(context)=> updatestd(),
        
        },
      initialRoute: '/',
    );
  }
}
