import 'package:fast_turtle_v2/screens/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire:
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {

        // if (snapshot.connectionState == ConnectionState.done) {
        //   return StreamProvider<Guest>.value(
        //     value: AuthService().user,
        //     child: MaterialApp(
        //       debugShowCheckedModeBanner: false,
        //       home: WelcomePage(),
        //     ),
        //   );
        // }

        return MaterialApp(
        title: 'Fast-Anadolu Project.ss',
        theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
        home: WelcomePage(),
        );
        }
    );
  }
}
