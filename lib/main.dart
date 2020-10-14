import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF093145),
        scaffoldBackgroundColor: Color(0xFF093145),
        fontFamily: "ArchitectsDaughter",
      ),
      home: HomeScreen(),
    );
  }
}

