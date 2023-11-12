// screens/home_screen.dart
import 'package:flutter/material.dart';

class BookshelfScreen extends StatelessWidget {
  final String title;

  const BookshelfScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Your BookshelfScreen layout goes here
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
