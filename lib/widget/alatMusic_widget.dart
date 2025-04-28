import 'package:flutter/material.dart';
import 'package:booking_application/widget/subtitle_text.dart';

class MusicInstruments extends StatelessWidget {
  final List<Map<String, String>> instruments = [
    {"name": "Guitar", "image": "assets/images/guitar.jpeg"},
    {"name": "Drum", "image": "assets/images/drum.jpeg"},
    {"name": "Bass", "image": "assets/images/bass.jpeg"},
    {"name": "Keyboard", "image": "assets/images/keyboard.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.6;
        final imageHeight = cardWidth * 0.9;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: SubtitleTextWidget(
                label: "Alat-alat Musik",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: imageHeight + 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: instruments.length,
                itemBuilder: (context, index) {
                  final instrument = instruments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: InstrumentCard(
                      name: instrument["name"]!,
                      image: instrument["image"]!,
                      width: cardWidth,
                      imageHeight: imageHeight,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class InstrumentCard extends StatelessWidget {
  final String name;
  final String image;
  final double width;
  final double imageHeight;

  const InstrumentCard({
    required this.name,
    required this.image,
    required this.width,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: imageHeight,
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: SubtitleTextWidget(
                label: name,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
