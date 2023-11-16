// screens/home_screen.dart
import 'package:bookrack/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookshelfScreen extends StatelessWidget {
  final String title;

  const BookshelfScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Your BookshelfScreen layout goes here
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
