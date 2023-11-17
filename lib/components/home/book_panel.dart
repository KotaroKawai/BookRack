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
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.1), BlendMode.darken
              )
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
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FractionallySizedBox(
                    heightFactor: .6,
                    widthFactor: .9,
                    child: Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: RichText(
                          text: TextSpan(
                            text: content.text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.white,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ),
              Align(
                alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FractionallySizedBox(
                      widthFactor: .8,
                      child: BookPanelContent(
                        title: content.title, 
                        authors: content.authors, 
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