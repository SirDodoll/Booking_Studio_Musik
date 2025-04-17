import 'package:booking_application/widget/responsive.dart';
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
  final String time;

  const JadwalCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getResponsiveSize(context, 0.017)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: SizedBox(
          width: getResponsiveSize(context, 0.74),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(getResponsiveSize(context, 0.020)),
                child: CircleAvatar(
                  radius: getResponsiveSize(context, 0.090),
                  backgroundImage: AssetImage(imageUrl),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(getResponsiveSize(context, 0.055)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubtitleTextWidget(
                        label: name,
                        fontWeight: FontWeight.bold,
                        fontSize: getResponsiveSize(context, 0.047),
                      ),
                      SizedBox(height: getResponsiveSize(context, 0.016)),
                      Row(
                        children: [
                          SizedBox(width: getResponsiveSize(context, 0.015)),
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
