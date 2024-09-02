import 'package:flutter/material.dart';
import 'package:scoreboardapp/addevents.dart';
import 'package:scoreboardapp/addstudents.dart';
import 'package:scoreboardapp/event.dart';
import 'package:scoreboardapp/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoreboardapp/mentor_login.dart';
import 'package:scoreboardapp/mentorscreen.dart';
import 'package:scoreboardapp/splashscreen.dart';
import 'package:scoreboardapp/updatestd.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const scoreapp());
}

class scoreapp extends StatelessWidget {
  const scoreapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomeScreen(),
        '/splash': (context) => SplashScreen(
              onThemeModeChanged: (ThemeMode mode) {},
            ),
        '/add': (context) => const addstd(),
        '/login': (context) => const LoginScreen(),
        '/mentorview': (context) => const Mentor_View(),
        '/update': (context) => const updatestd(),
        '/events': (context) => const Events_Screen(),
        '/addevent': (context) => const AddEventScreen(),
      },
      initialRoute: '/splash',
    );
  }
}
