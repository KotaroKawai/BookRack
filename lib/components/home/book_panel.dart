import 'package:bookrack/components/home/book_panel_button.dart';
import 'package:bookrack/components/home/book_panel_content.dart';
import 'package:bookrack/components/home/book_panel_props.dart';
import 'package:flutter/material.dart';

class BookPanel extends StatelessWidget {
  final BookPanelProps content;

  const BookPanel({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(content.imageUrl!),
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
                        title: content.title, 
                        authors: content.authors,
                        text: content.text,
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  alignment: const Alignment(1, 1),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BookPanelButton(icon: Icons.favorite_outline_sharp, number: "1.2m", color: Colors.white),
                      BookPanelButton(icon: Icons.bookmark_outline, number: "1.2m", color: Colors.white),
                      BookPanelButton(icon: Icons.share, number: "1.2m", color: Colors.white,),
                    ],
                  )
                )  
              )
            ],
          ),
        ),
      ),
    );
  }
}