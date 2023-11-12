// screens/home_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String title;

  const ProfileScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Your ProfileScreen layout goes here
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
