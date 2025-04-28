import 'package:flutter/material.dart';

double getResponsiveSize(BuildContext context, double scale) {
  return MediaQuery.of(context).size.width * scale;
}
