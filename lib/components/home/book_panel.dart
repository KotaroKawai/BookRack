import 'package:bookrack/components/home/book_panel_button.dart';
import 'package:bookrack/components/home/book_panel_content.dart';
import 'package:bookrack/components/home/book_panel_props.dart';
import 'package:bookrack/user/firestore_book.dart';
import 'package:bookrack/user/firestore_user.dart';
import 'package:flutter/material.dart';

class BookPanel extends StatefulWidget {
  final BookPanelProps content;

  const BookPanel({super.key, required this.content});

  @override
  State<BookPanel> createState() => _BookPanelState();
}

class _BookPanelState extends State<BookPanel> {
  late bool isLiked;
  late bool isBookmarked;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    FirestoreUser.Current().likedBooks.toggleBook(
      FirestoreBook(
        id: widget.content.title,
        title: widget.content.title,
        authors: widget.content.authors,
        imageUrl: widget.content.imageUrl ?? "",
      )
    );
  }

  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });

    FirestoreUser.Current().bookmarkedBooks.toggleBook(
      FirestoreBook(
        id: widget.content.title,
        title: widget.content.title,
        authors: widget.content.authors,
        imageUrl: widget.content.imageUrl ?? "",
      )
    );
  }

  @override
  void initState() {
    super.initState();
    isLiked = false;
    isBookmarked = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => _toggleLike(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.content.imageUrl!),
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
              ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black,
                ]
              )
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FractionallySizedBox(
                        widthFactor: .8,
                        child: BookPanelContent(
                          title: widget.content.title, 
                          authors: widget.content.authors,
                          text: widget.content.text,
                        ),
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: const Alignment(1, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BookPanelButton(icon: isLiked ? Icons.favorite : Icons.favorite_outline_sharp, number: "1.2m", color: isLiked ? Colors.red : Colors.white, onTap: () => _toggleLike()),
                        BookPanelButton(icon: isBookmarked ? Icons.bookmark : Icons.bookmark_outline, number: "1.2m", color: Colors.white, onTap: () => _toggleBookmark()),
                        const BookPanelButton(icon: Icons.share, number: "1.2m", color: Colors.white),
                      ],
                    )
                  )  
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}