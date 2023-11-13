import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../components/api/bookData.dart';

class Content {
  final String title;//著者
  final String text;
  final String? imageUrl; // Can be null for now, you might add images later
  final String? url; // Can be null for now, you might add URLs later

  Content({required this.title, required this.text, this.imageUrl, this.url});
}


class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Create a list of Content objects
  final List<Content> _contentOptions = [
    Content(title: 'Title 1', text: 'あいうえお string.\n\nIt has multiple paragraphs for demonstration.', imageUrl: 'https://picsum.photos/id/1/400/300'),
    Content(title: 'Title 2', text: 'かきくhe second option.\n\nIt also has several paragraphs to illustrate the point.', imageUrl: 'https://picsum.photos/id/2/400/300'),
    Content(title: 'Title 3', text: 'さしすせそlooks like this.\n\nParagraphs are split for readability.', imageUrl: 'https://picsum.photos/id/3/400/300'),
    Content(title: 'Title 4', text: 'たちつてと number four comes here.\n\nAgain, notice the paragraph separation.', imageUrl: 'https://picsum.photos/id/4/400/300'),
    Content(title: 'Title 5', text: 'はひふへほxt string is presented here.\n\nThis concludes the set of examples.', imageUrl: 'https://picsum.photos/id/5/400/300'),
  ];

  // Randomly select a Content object
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
      _currentIndex = _currentIndex == 0 ? _contentOptions.length - 1 : _currentIndex - 1;
      _selectedContent = _contentOptions[_currentIndex];
    });
  }
  
  void _onSwipeDown() {
    setState(() {
      _isSwipingUp = false;
      _currentIndex = (_currentIndex + 1) % _contentOptions.length;
      _selectedContent = _contentOptions[_currentIndex];

      addRandomBookToContentOptions();
      //_contentOptions.add(Content(title: '新しいタイトル', text: '新しいテキスト', imageUrl: 'https://picsum.photos/id/6/400/300'));
    });
  }

  void addRandomBookToContentOptions() async {
    var bookData = await BookData().randomBookSearch();
    // BookDataModelから必要な情報を抽出してContentオブジェクトを作成
    var newContent = Content(
      title: bookData.title,  // 本のタイトル
      text: bookData.description,  // 本の紹介文
      imageUrl: bookData.imageLink  // 画像リンク
    );
    // Contentオブジェクトをリストに追加
    _contentOptions.add(newContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector( // スワイプ検出のためのGestureDetectorを追加
        // onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1), // Set a duration for the transition
          transitionBuilder: (Widget child, Animation<double> animation) {
            // final inAnimation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(animation);
            // final outAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(animation);
            final inAnimation = Tween<Offset>(
              begin: Offset(0, _isSwipingUp ? 1 : -1), 
              end: Offset.zero
            ).animate(animation);

            final outAnimation = Tween<Offset>(
              begin: Offset(0, _isSwipingUp ? -1 : 1),
              end: Offset.zero
            ).animate(animation);

            return SlideTransition(
              position: ( child.key == ValueKey(_currentIndex) ) ? inAnimation : outAnimation,
              child: child,
            );
          },
          child: Stack(
            key: ValueKey<int>(_currentIndex),
            fit: StackFit.expand,
            children: [
              Image.network(//background image
                _selectedContent.imageUrl ?? 'https://dummyimage.com/600x400/000/fff',
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.white.withOpacity(0.25),
              ),
              Container(//semi-transparent overlay
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
                            padding: const EdgeInsets.all(8.0), // テキストの周りにパディングを追加
                            decoration: BoxDecoration(
                              color: Colors.grey, // 背景色
                              borderRadius: BorderRadius.circular(10.0), // 角を丸くする
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
              Positioned(//the buttons for bookmark, like, and share
                bottom: 16.0,
                right: 16.0,
                child: Column(
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(// Bookmark button
                        icon: const Icon(Icons.bookmark),
                        //color: Colors.black,
                        color: Colors.black.withOpacity(0.7),
                        onPressed: () {// TODO: Bookmark action
                          
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(// Like button
                        icon: const Icon(Icons.favorite),
                        //color: Colors.black,
                        color: Colors.black.withOpacity(0.7),
                        onPressed: () {// TODO: Like action
                          
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(// Share button
                        icon: const Icon(Icons.share),
                        //color: Colors.black,
                        color: Colors.black.withOpacity(0.7),
                        onPressed: () {// TODO: Share action
                          
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
