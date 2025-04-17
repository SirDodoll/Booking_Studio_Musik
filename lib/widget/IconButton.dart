import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:booking_application/widget/responsive.dart';

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
        radius: getResponsiveSize(context, 0.058),
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: getResponsiveSize(context, 0.072),),
          ),
          SizedBox(height: 6,),
          SubtitleTextWidget(
            label: label,
            fontSize: getResponsiveFontSize(context, 0.040),
            fontWeight: FontWeight.w600,
            fontFamily: 'Inder',
          ),
        ],
      ),

    );
  }
}
