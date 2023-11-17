import 'package:flutter/material.dart';

class BookPanelButton extends StatelessWidget {
  final icon;
  final String number;
  final Color color;
  final void Function()? onTap;

  const BookPanelButton({Key? key, required this.icon, required this.number, required this.color, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(icon, size: 40, color: color,),
              Text(number, style: TextStyle(color: Colors.white))
            ]),
        ),
    );
  }
}