import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookrack/main.dart'; // ここに必要な他のページへの遷移機能があると仮定します
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String title;
  const ProfileScreen({super.key, required this.title});
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int historyCount = 0;
  late DocumentReference docRef;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      docRef = FirebaseFirestore.instance.collection('test').doc(user.uid);
      fetchhistoryCount();
    }
  }

  void fetchhistoryCount() async {
      try {
        DocumentSnapshot snapshot = await docRef.get();
        if (snapshot.exists) {
          setState(() {
            historyCount = snapshot.get('historyCount') as int;
          });
        }
      } catch (e) {
        print('Error getting document: $e');
      }
  }

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    User? user = FirebaseAuth.instance.currentUser;
  
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("images/login.jpg"), // アセットから画像を読み込む
            fit: BoxFit.cover, // 画像を画面に合わせて調整
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // 透明度を調整
              BlendMode.dstATop, // これにより背景画像に色がオーバーレイされる
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                Card(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.person, size: 50), // ユーザーアイコン
                        const SizedBox(width: 10), // アイコンとテキストの間隔
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user?.displayName ?? '未設定',
                              style: const TextStyle(fontSize: 20)
                            ),
                            Text(
                              user?.email ?? '未設定',
                              style: const TextStyle(fontSize: 12)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // 履歴ページへの遷移
                  },
                  child: const Text('履歴を表示'),
                ),
                const SizedBox(height: 30),
                Card( // 閲覧数をCardウィジェットで囲む
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Text(
                      '閲覧数: $historyCount',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // いいねした本のページへの遷移
                  },
                  child: const Text('いいねした本を確認'),
                ),
                const SizedBox(height: 120),
                ElevatedButton(
                  onPressed: () async {
                    // サインアウト処理
                    FirebaseAuth.instance.signOut();
                    // ログインページなどに戻る処理をここに追加
                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (Route<dynamic> route) => false, // 以前のすべてのルートを削除
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('サインアウト'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
