import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookrack/main.dart'; // ここに必要な他のページへの遷移機能があると仮定します

class ProfileScreen extends StatelessWidget {
  final String title;

  const ProfileScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login.jpg"), // アセットから画像を読み込む
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
                              '${user.displayName ?? '未設定'}',
                              style: const TextStyle(fontSize: 20)
                            ),
                            Text(
                              '${user.email ?? '未設定'}',
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
                      '閲覧数: [表示数]',
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
                  onPressed: () {
                    // サインアウト処理
                    FirebaseAuth.instance.signOut();
                    // ログインページなどに戻る処理をここに追加
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
