import 'package:booking_application/widget/responsive.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class JamOperasionalWidget extends StatelessWidget {
  final TimeOfDay buka;
  final TimeOfDay tutup;
  final bool isOpen;

  const JamOperasionalWidget({
    super.key,
    required this.buka,
    required this.tutup,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getResponsiveSize(context, 0.030),
          horizontal: getResponsiveSize(context, 0.034)
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: getResponsiveSize(context, 0.030),
            horizontal: getResponsiveSize(context, 0.034)
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.black54, size: getResponsiveSize(context, 0.080)),
                SizedBox(width: getResponsiveSize(context, 0.020)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubtitleTextWidget(
                      label: "Jam Operasional",
                        fontSize: getResponsiveFontSize(context, 0.050),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    SubtitleTextWidget(label:
                      "${buka.format(context)} - ${tutup.format(context)}",
                      fontSize: getResponsiveFontSize(context, 0.045),
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveSize(context, 0.022),
                  vertical: getResponsiveSize(context, 0.020)
              ),
              decoration: BoxDecoration(
                color: isOpen ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isOpen ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: getResponsiveSize(context, 0.015)),
                  SubtitleTextWidget(
                   label:  isOpen ? "Buka" : "Tutup",
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: getResponsiveFontSize(context, 0.045),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
