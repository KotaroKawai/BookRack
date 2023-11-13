import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  
import 'config/config.dart';
import 'utils/auth.dart';


//firebaseの認証
final configurations = Configurations();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: configurations.apiKey,
      appId: configurations.appId,
      messagingSenderId: configurations.messagingSenderId,
      projectId: configurations.projectId
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Login Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Login Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            signInWithGoogle();
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}

