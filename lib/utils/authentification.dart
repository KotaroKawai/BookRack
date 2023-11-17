import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Google ログイン関数
Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // ログイン成功時の処理
    print("success");
    // ログイン成功後、ユーザー情報を取得する例
    final User user = userCredential.user!;
    print(user);
    
    // ユーザー UID を返す
    return user;
  } catch (e) {
    print("Google ログインエラー: $e");
    return null;
  }
}
    // print("User ID: ${user.uid}");
    // print("Display Name: ${user.displayName}");
    // print("Email: ${user.email}");