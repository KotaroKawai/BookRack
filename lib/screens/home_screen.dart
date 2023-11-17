import 'package:bookrack/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';
import '../components/api/bookdata_get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Content {
  final String id; //ID
  final String title; //タイトル
  final String text; //あらすじ
  final String? imageUrl; // 表紙の画像
  final String? url; // アマゾン等の販売先リンクの予定

  Content({required this.id,required this.title, required this.text, this.imageUrl, this.url});
}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //　最初の一つを仮置き中
  final List<Content> _contentOptions = [
    Content(
        id: 'tteesstt01',
        title: 'Title 1',
        text: 'あいうえお string.\n\nIt has multiple paragraphs for demonstration.',
        imageUrl: 'https://picsum.photos/id/1/400/300'),
  ];

  // 次の本をランダムに呼び出し
  Content getRandomContent() {
    final randomIndex = Random().nextInt(_contentOptions.length);
    return _contentOptions[randomIndex];
  }

  late Content _selectedContent = _contentOptions[0];
  Timer? _timer;
  int _currentIndex = 0;
  double _startVerticalDrag = 0.0;
  bool _isSwipingUp = false;

  void _onVerticalDragStart(DragStartDetails details) {
    _startVerticalDrag = details.globalPosition.dy;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final dragDistance = _startVerticalDrag - details.primaryVelocity!;

    if (dragDistance < screenHeight * 0.25) {
      _onSwipeDown();
    }

    if (dragDistance > screenHeight * 0.25) {
      _onSwipeUp();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _selectedContent = _contentOptions[_currentIndex];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onSwipeUp() {
    setState(() {
      _isSwipingUp = true;
      _currentIndex =
          _currentIndex == 0 ? _contentOptions.length - 1 : _currentIndex - 1;
      _selectedContent = _contentOptions[_currentIndex];
    });
    addToHistoryToFirebase();
  }

  void _onSwipeDown() {
    setState(() {
      _isSwipingUp = false;
      _currentIndex = (_currentIndex + 1) % _contentOptions.length;
      _selectedContent = _contentOptions[_currentIndex];

      addRandomBookToContentOptions();
      //_contentOptions.add(Content(title: '新しいタイトル', text: '新しいテキスト', imageUrl: 'https://picsum.photos/id/6/400/300'));
    });
    addToHistoryToFirebase();
  }

  void addToHistoryToFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedContent.imageUrl != null) {
      await addToHistory(user.uid, _selectedContent.id, _selectedContent.imageUrl!);
    }
  }
  
  Future<void> addToHistory(String userId, String bookId, String bookImageUrl) async {
    final DocumentReference docRef = FirebaseFirestore.instance.collection('test').doc(userId);

    return FirebaseFirestore.instance.runTransaction<void>((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        // ドキュメントが存在しない場合、新しいドキュメントを作成して履歴を初期化
        transaction.set(docRef, {
          'history': [
            {'bookId': bookId, 'bookImageUrl': bookImageUrl}
          ],
          'historyCount': 1
        });
      } else {
        // ドキュメントが存在する場合、履歴に新しい本のペアを追加
        transaction.update(docRef, {
          'history': FieldValue.arrayUnion([
            {'bookId': bookId, 'bookImageUrl': bookImageUrl}
          ]),
          'historyCount': FieldValue.increment(1)
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> addToBookmark(String userId, String bookId, String bookImageUrl) async {
    final DocumentReference docRef = FirebaseFirestore.instance.collection('test').doc(userId);

    return FirebaseFirestore.instance.runTransaction<void>((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      // ドキュメントが存在するかどうか、および特定のフィールドが存在するかどうかをチェック
      int currentCount = data != null && data.containsKey('bookmarkCount') 
                        ? data['bookmarkCount'] as int 
                        : 0;

      if (!snapshot.exists || data == null || !data.containsKey('bookmark')) {
        // 新しいドキュメントを作成するか、またはbookmarkフィールドが存在しない場合
        transaction.set(docRef, {
          'bookmark': [{'bookId': bookId, 'bookImageUrl': bookImageUrl}],
          // 'bookmarkOrder': [{'bookId': bookId, 'order': currentCount + 1}],
          'bookmarkCount': currentCount + 1,
        }, SetOptions(merge: true));
      } else {
        // ドキュメントが存在し、bookmarkフィールドも存在する場合、配列とカウントを更新
        transaction.update(docRef, {
          'bookmark': FieldValue.arrayUnion([{'bookId': bookId, 'bookImageUrl': bookImageUrl}]),
          // 'bookmarkOrder': FieldValue.arrayUnion([{'bookId': bookId, 'order': currentCount + 1}]),
          'bookmarkCount': FieldValue.increment(1)
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  void addRandomBookToContentOptions() async {
    var bookData = (await BookData().randomBookSearch())![0];

    var newContent = Content(
        id: bookData.id,              //本のID
        title: bookData.title,        // 本のタイトル
        text: bookData.description,   // 本の紹介文
        imageUrl: bookData.imageLink  // 画像リンク
        );
    _contentOptions.add(newContent);
  }

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Scaffold(
      body: GestureDetector(
        // スワイプ検出のためのGestureDetectorを追加
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: AnimatedSwitcher(
          duration:
              const Duration(seconds: 1), // Set a duration for the transition
          transitionBuilder: (Widget child, Animation<double> animation) {
            final inAnimation = Tween<Offset>(
                    begin: Offset(0, _isSwipingUp ? 1 : -1), end: Offset.zero)
                .animate(animation);

            final outAnimation = Tween<Offset>(
                    begin: Offset(0, _isSwipingUp ? -1 : 1), end: Offset.zero)
                .animate(animation);

            return SlideTransition(
              position: (child.key == ValueKey(_currentIndex))
                  ? inAnimation
                  : outAnimation,
              child: child,
            );
          },
          child: Stack(
            key: ValueKey<int>(_currentIndex),
            fit: StackFit.expand,
            children: [
              Image.network(
                //background image
                _selectedContent.imageUrl ??
                    'https://dummyimage.com/600x400/000/fff',
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.white.withOpacity(0.25),
              ),
              Container(
                //semi-transparent overlay
                key: ValueKey(_currentIndex),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedContent.title,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MPLUSRounded1c',
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        // Display the text in a scrollable view to handle long texts
                        child: SingleChildScrollView(
                          child: _selectedContent.text.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(
                                      8.0), // テキストの周りにパディングを追加
                                  decoration: BoxDecoration(
                                    color: Colors.grey, // 背景色
                                    borderRadius:
                                        BorderRadius.circular(10.0), // 角を丸くする
                                  ),
                                  child: Text(
                                    _selectedContent.text,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'MPLUSRounded1c',
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                //the buttons for bookmark, like, and share
                bottom: 16.0,
                right: 16.0,
                child: Column(
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(
                        // Bookmark button
                        icon: const Icon(Icons.bookmark),
                        //color: Colors.black,
                        color: Colors.black.withOpacity(0.7),
                        onPressed: () async{
                          // TODO: Bookmark action
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await addToBookmark(user.uid, _selectedContent.id, _selectedContent.imageUrl! );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(
                        // Like button
                        icon: const Icon(Icons.favorite),
                        //color: Colors.black,
                        color: Colors.black.withOpacity(0.7),
                        onPressed: () async {
                          // TODO: Like action
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(
                        // Share button
                        icon: const Icon(Icons.share),
                        //color: Colors.black,
                        color: Colors.black.withOpacity(0.7),
                        onPressed: () {
                          // TODO: Share action
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
