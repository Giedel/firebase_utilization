import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_utilization/auth_service.dart';
import 'package:firebase_utilization/firebase_options.dart';
import 'package:firebase_utilization/home_page.dart';
import 'package:firebase_utilization/login.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase CRUD',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.greenAccent.shade200),
      ),
      home: StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        }
      )
    );
  }
}