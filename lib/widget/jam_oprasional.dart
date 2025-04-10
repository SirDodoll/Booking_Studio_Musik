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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Icon(Icons.access_time, color: Colors.black54, size: 24),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubtitleTextWidget(
                      label: "Jam Operasional",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    SubtitleTextWidget(label:
                      "${buka.format(context)} - ${tutup.format(context)}",
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  SizedBox(width: 5),
                  SubtitleTextWidget(
                   label:  isOpen ? "Buka" : "Tutup",
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15,
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
