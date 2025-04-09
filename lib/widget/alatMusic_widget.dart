import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class MusicInstruments extends StatelessWidget {
  final List<Map<String, String>> instruments = [
    {"name": "Bass", "image": "assets/images/guitar.jpeg"},
    {"name": "Drum", "image": "assets/images/drum.jpeg"},
    {"name": "Guitar", "image": "assets/images/bass.jpeg"},
    {"name": "Keyboard", "image": "assets/images/keyboard.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: SubtitleTextWidget(
            label: "Alat-alat Musik",
            fontSize: 18, fontWeight: FontWeight.bold
            ),
        ),
        SizedBox(
          height: 180,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: instruments.map((instrument) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.6),
                  child: InstrumentCard(
                    name: instrument["name"]!,
                    image: instrument["image"]!,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class InstrumentCard extends StatelessWidget {
  final String name;
  final String image;

  InstrumentCard({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 145,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.black.withOpacity(0.8),
                      insetPadding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: InteractiveViewer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(1.5),
              child: SubtitleTextWidget(
                label: name,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
              ),
          ],
        ),
      ),
    );
  }
}
