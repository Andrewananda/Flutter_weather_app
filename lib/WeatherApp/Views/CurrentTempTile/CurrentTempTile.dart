import 'package:flutter/material.dart';


class CurrentTempTile extends StatelessWidget {

  const CurrentTempTile({super.key, required this.itemIcon, required this.title, required this.value});

  final IconData itemIcon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(itemIcon, size: 20, color: Colors.white),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}
