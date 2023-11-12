import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class Content {
  final String title;
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

  //late final Content _selectedContent;
  late Content _selectedContent = _contentOptions[0];
  //Content? _selectedContent;
  Timer? _timer;
  int _currentIndex = 0;

  void _startRolling() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _contentOptions.length;
        _selectedContent = _contentOptions[_currentIndex];
      });
    });
  }


  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _selectedContent = _contentOptions[_currentIndex];
    _startRolling();  
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _selectedContent.imageUrl ?? 'https://dummyimage.com/600x400/000/fff',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedContent?.title ?? '',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Center(
                    // Display the text in a scrollable view to handle long texts
                    child: SingleChildScrollView(
                      child: Text(
                        _selectedContent?.text ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18.0,color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
