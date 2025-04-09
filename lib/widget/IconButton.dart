import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconbuttonWidget extends StatelessWidget {
  const IconbuttonWidget({super.key, required this.icon, required this.label, required this.color, required this.onPressed});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
        radius: 22,
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: 23,),
          ),
          const SizedBox(height: 6,),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inder')),
        ],
      ),

    );
  }
}
