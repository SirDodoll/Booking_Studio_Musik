import 'package:booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppbarnameWidget extends StatelessWidget {
  AppbarnameWidget({super.key, this.fontSize});
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveFontSize = fontSize ?? screenWidth * 0.061;

    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Colors.white,
      child: TitlesTextWidget(
        label: 'ID MUSIC',
        fontSize: effectiveFontSize,
      ),
    );
  }
}


