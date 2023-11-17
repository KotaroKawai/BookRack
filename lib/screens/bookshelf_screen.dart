// screens/home_screen.dart
import 'package:bookrack/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookshelfScreen extends StatefulWidget {
  final String title;
  //final List<String> bookCoverUrls; // 本の表紙のURLのリスト
  const BookshelfScreen({super.key, required this.title});

  @override
  BookshelfScreenState createState() => BookshelfScreenState();

}

class BookshelfScreenState extends State<BookshelfScreen> {
  late List<int> bookOrder; // 表示順を管理するリスト
  late List<int> bookIds;    // 本のIDリスト
  late List<dynamic> bookmarks = []; // ブックマークデータのリスト

  @override
  void initState() {
    super.initState();
    // bookIds = List.generate(widget.bookCoverUrls.length, (index) => index);
    // //bookOrder = List.from(bookIds);
    // bookOrder = List.generate(widget.bookCoverUrls.length, (index) => index);
    bookOrder = [];
    fetchBookmarks();
  }

  // Firestoreからブックマークデータを取得する関数
  void fetchBookmarks() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('test').doc(user.uid).get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (snapshot.exists && data != null && data.containsKey('bookmark')) {
        List<dynamic> newBookmarks = data['bookmark'];
        setState(() {
          bookmarks = newBookmarks;
          // bookmarksの長さに基づいてbookOrderを初期化
          bookOrder = List.generate(bookmarks.length, (index) => index);
        });
      }
    }
  }

  // 表示順を更新する関数
  void reorderData(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final int item = bookOrder.removeAt(oldIndex);
      bookOrder.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your BookshelfScreen layout goes here
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Scaffold(
      body: Container(
        decoration : BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/bookshelf.jpg'), // 本棚の背景画像
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // 透明度を調整
              BlendMode.dstATop, // これにより背景画像に色がオーバーレイされる
          ),
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2 / 3, // 本のサイズ比を縦長に設定
          ),
          // itemCount: widget.bookCoverUrls.length,
          // GridView.builderのitemCountをbookmarksの長さにする
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            double offsetValue = MediaQuery.of(context).size.width / 3 * 0.5;     
             int bookId = bookOrder[index];
            var book = bookmarks[index];
            List<String> urls = bookmarks.map((b) => b['bookImageUrl'] as String).toList();
            // bookmarkOrder 配列から order 値を取得し、インデックスに変換
            //int order = data['bookmarkOrder'][index]['order'] as int;
            //int displayIndex = order - 1; // order は 1 から始まるため、1 を引く

            return DragTarget<int>(
              // onWillAccept: (receivedBookId) {
              //   return receivedBookId != bookId; // 同じ位置にはドロップ不可
              // },
              onAccept: (receivedBookId) {
                int oldIndex = bookOrder.indexOf(receivedBookId);
                int newIndex = bookOrder.indexOf(bookId);
                reorderData(oldIndex, newIndex);
              },
              builder: (context, candidateData, rejectedData) {
                return LongPressDraggable<int>(
                  data: bookOrder[index],
                  childWhenDragging: Container(), // ドラッグ中の空のコンテナ
                  onDragCompleted: () {},

                  feedback: Material(
                    //elevation: 4.0,
                    color: Colors.transparent,
                    child: Transform.translate(
                      offset: Offset(0, offsetValue),
                      //child: createBookItem(context, widget.bookCoverUrls, bookOrder[index], isDragging: true),
                      child: createBookItem(context, urls, bookOrder[index], isDragging: true),
                    ),
                  ),
                  child: Transform.translate(
                    offset: Offset(0, offsetValue), 
                    child: createBookItem(context, urls, bookOrder[index]), // 本のアイテムを生成するメソッド
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// 本のアイテムを生成するメソッド
Widget createBookItem(BuildContext context, List<String> urls, int index, {bool isDragging = false}) {
  double width = MediaQuery.of(context).size.width / 3 ;
  double height = width * (3 / 2); // 本のアスペクト比に基づいて高さを計算

  return SizedBox(
    width: width, // ドラッグ時にのみサイズを指定
    height: height,
    child: Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              // タップイベントの処理...
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('本のタイトル'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Image.network(urls[index]), // 本の表紙の画像
                          const SizedBox(height: 10),
                          const Text('タイトル詳細: 素敵な本'), // 本のタイトル
                          const SizedBox(height: 5),
                          const Text('著者: 著名な作家'), // 著者情報
                          const SizedBox(height: 5),
                          const Text('出版社: 出版社名'), // 出版社情報
                          const SizedBox(height: 5),
                          const Text('販売されている本屋: 本屋A, 本屋B, ...'), // 販売本屋情報
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('閉じる'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              );
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(urls[index]),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: isDragging ? [] : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 2,
          color: Colors.brown,
          margin: const EdgeInsets.symmetric(vertical: 10),
        ),
      ],
    ),
  );
}