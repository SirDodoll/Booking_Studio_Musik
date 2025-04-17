import 'package:flutter/material.dart';

double getResponsiveFontSize(BuildContext context, double scaleFactor) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * scaleFactor;
}

double getResponsiveSize(BuildContext context, double scaleFactor) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * scaleFactor;
}
double getResponsiveRadius(BuildContext context, double scaleFactor) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * scaleFactor;
}
