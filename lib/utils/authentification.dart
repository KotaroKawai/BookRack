import 'package:bookrack/screens/main_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

// Google ログイン関数
Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // ログイン成功時の処理
    print("success");
    
    const MainScreen();
    // ログイン成功後、ユーザー情報を取得する例
    // final User user = userCredential.user!;
    // print("User ID: ${user.uid}");
    // print("Display Name: ${user.displayName}");
    // print("Email: ${user.email}");
  } catch (e) {
    print("Google ログインエラー: $e");
  }
}