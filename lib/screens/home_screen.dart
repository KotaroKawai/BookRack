import 'package:bookrack/components/home/book_panel.dart';
import 'package:bookrack/components/home/book_panel_props.dart';
import 'package:bookrack/model/response_model.dart';
import 'package:flutter/material.dart';
import '../components/api/bookdata_get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Content {
  final String title; //著者
  final String text; //あらすじ
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
  final _controller = PageController(initialPage: 0);
  final _apiService = BookData();
  late final List<BookDataModel> _books;

  void _getBooks() async {
    final result = await _apiService.randomBookSearch() ?? [];

    setState(() {
      _books.addAll(result);
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _books = [];

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        _getBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _books.clear();
          _getBooks();
        });
      },
      child: PageView.builder(
        itemCount: _books.isNotEmpty ? _books.length : 1,
        itemBuilder: (context, snapshot) {
          if (_books.isEmpty) {
            _getBooks();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            body: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              itemCount: _books.length ,
              itemBuilder: (context, index) {
                final bookData = _books[index];
  
                return BookPanel(
                    content: BookPanelProps(
                      title: bookData?.title ?? 'Fuck',
                      text: bookData?.description ?? 'oh no', 
                      authors: bookData?.authors.join(', ') ?? 'lmao', 
                      imageUrl: bookData?.imageLink ?? "https://kinsta.com/wp-content/uploads/2018/08/google-404-error-page-1.png",
                    )
                  );
              },
              )
            );
        }
      ),
    );
  }
}
