import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final bool Open;
  final int bookingHariIni;
  final int totalBooking;
  final int hargaBookingHariIni;

  const BookingCard({
    super.key,
    required this.openTime,
    required this.closeTime,
    required this.Open,
    required this.bookingHariIni,
    required this.totalBooking,
    required this.hargaBookingHariIni,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: primaryColor,
      child: SizedBox(
        width: 350,
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Jam Operasional: ${openTime.format(context)} - ${closeTime.format(context)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12, 
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Open ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      Open ? "Buka" : "Tutup",
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              Text(
                "Rp ${hargaBookingHariIni.toString()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10), 
              const Divider(
                color: Colors.white54, 
                thickness: 1,
                height: 10,
              ),

              const SizedBox(height: 10), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBookingInfo("Booking Hari Ini", bookingHariIni),
                  _buildBookingInfo("Total Booking", totalBooking),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBookingInfo(String label, int value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "$value",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
