import 'package:flutter/material.dart';

class BookPanelContent extends StatelessWidget {
  final String title;
  final String authors;
  final String description;

  const BookPanelContent({Key? key, required this.title, required this.authors, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(text: TextSpan(
          children: [
            TextSpan(
              text: authors,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ]
        )
      ),
      RichText(text: TextSpan(
        text: description,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white
        )
      ))
      ],
    );
  }
}