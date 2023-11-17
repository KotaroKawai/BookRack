import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'utils/authentification.dart';
import 'package:bookrack/screens/main_screen.dart';

//firebase認証
final configurations = Configurations();
void main() async {
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

//Userのログイン状態を管理
class UserState extends ChangeNotifier {
  User? user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final UserState userState = UserState();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
      create:(context) => UserState(),
       child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
       ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          //ログインボタン
          child: ElevatedButton(
            onPressed: () async{
             final user = await signInWithGoogle();
             userState.setUser(user as User);
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context){
                return const MainScreen();
              }),
            );
                       },
            child: const Text('Sign in with Google'),
          ),
        ),
      ),
    );
  }
}
