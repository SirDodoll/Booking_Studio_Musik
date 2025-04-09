import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class InfoJadwalWidget extends StatelessWidget {
  final List<Map<String, String>> bookings;

  const InfoJadwalWidget({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: SubtitleTextWidget(
            label: "Booking Hari Ini",
            fontSize: 18, fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return JadwalCard(
                imageUrl: booking['imageUrl']!,
                name: booking['name']!,
                date: booking['date']!,
                time: booking['time']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class JadwalCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String date;
  final String time;

  const JadwalCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: SizedBox(
          width: 270,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(imageUrl),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubtitleTextWidget(
                        label: name,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SubtitleTextWidget(label: date, fontSize: 12
                          ),
                          const SizedBox(width: 8),
                          SubtitleTextWidget(label: time, fontSize: 12
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
