import 'package:flutter/material.dart';

class BookPanelContent extends StatefulWidget {
  final String title;
  final String authors;
  final String text;

  const BookPanelContent({super.key, required this.title, required this.authors, required this.text});

  @override
  State<BookPanelContent> createState() => _BookPanelContentState();
}

class _BookPanelContentState extends State<BookPanelContent> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          widget.title,
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
              text: widget.authors,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ]
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: isExpanded ? 20 : 3,
          text: TextSpan(
              text: widget.text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              )
            )
          ),
      )
      ],
    );
  }
}