import 'package:booking_application/widget/responsive.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class InfoJadwalWidget extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;

  const InfoJadwalWidget({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bookings.map((booking) {
        final user = booking['users'] ?? {};
        final name = user['name'] ?? 'Tidak diketahui';
        final tanggal = DateTime.parse(booking['tanggal']);
        final startTime = booking['jam_mulai'];
        final endTime = booking['jam_selesai'];

        return ListTile(
          title: Text(name),
          subtitle: Text(
            '${tanggal.day}/${tanggal.month}/${tanggal.year} • $startTime - $endTime',
          ),
        );
      }).toList(),
    );
  }
}

