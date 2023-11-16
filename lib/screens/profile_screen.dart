// screens/home_screen.dart
import 'package:bookrack/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final String title;

  const ProfileScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    // Your ProfileScreen layout goes here
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
