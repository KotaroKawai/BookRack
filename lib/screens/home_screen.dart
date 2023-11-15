import 'package:bookrack/components/home/book_panel.dart';
import 'package:bookrack/components/home/book_panel_props.dart';
import 'package:bookrack/model/response_model.dart';
import 'package:flutter/material.dart';
import '../components/api/bookdata_get.dart';

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

  // TODO: キャッシュと下にスクロールしたら、またAPIを叩く

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiService.randomBookSearch(), 
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final books = snapshot.data as List<BookDataModel?>;

          return Scaffold(
            body: PageView(
              controller: _controller,
              scrollDirection: Axis.vertical,
              children: [
                for (final bookData in books)
                  BookPanel(
                    content: BookPanelProps(
                      title: bookData?.title ?? 'Fuck',
                      text: bookData?.description ?? 'oh no', 
                      authors: bookData?.authors.join(', ') ?? 'lmao', 
                      imageUrl: bookData?.imageLink ?? "https://kinsta.com/wp-content/uploads/2018/08/google-404-error-page-1.png",
                    ),
                  ),
              ]
              )
            );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: const TextStyle(color: Colors.red));
        }

        return const Center(child: CircularProgressIndicator());
      }
    );
  }
}
