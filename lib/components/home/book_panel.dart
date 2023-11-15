import 'package:bookrack/components/home/book_panel_button.dart';
import 'package:bookrack/components/home/book_panel_content.dart';
import 'package:bookrack/components/home/book_panel_props.dart';
import 'package:bookrack/screens/home_screen.dart';
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
                alignment: Alignment.bottomLeft,
                  child: FractionallySizedBox(
                    heightFactor: .4,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: FractionallySizedBox(
                            widthFactor: .9,
                            alignment: const Alignment(-1, -1),
                            child: BookPanelContent(
                              title: content.title, 
                              authors: content.authors, 
                              description: content.text
                            ),
                          )
                        ),
                      )
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  alignment: const Alignment(1, 1),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BookPanelButton(icon: Icons.favorite, number: "1.2m", color: Colors.red),
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