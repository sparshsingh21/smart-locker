import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Someting went Worng"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: MyHomePage(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
