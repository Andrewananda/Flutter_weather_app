import 'package:flutter/material.dart';

import '../../utilities/view/extensions/ColorExtension.dart';



class TodayWeatherTile extends StatelessWidget {
  const TodayWeatherTile({super.key, required this.percentage, required this.image, required this.time});

  final String percentage;
  final IconData image;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: HexColor.fromHex("#0847F1"),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(percentage, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),
              Icon(image, color: Colors.white, size: 50),
              Text(time, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400))
            ],
          ),
        ),
      ),
    );
  }
}
