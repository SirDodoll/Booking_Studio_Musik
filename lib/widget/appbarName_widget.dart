import 'package:booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppbarnameWidget extends StatelessWidget {
  const AppbarnameWidget({super.key, this.fontSize = 20,});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Colors.white,
      child: TitlesTextWidget(label: 'ID MUSIC', fontSize: fontSize,),
    );
  }
}

