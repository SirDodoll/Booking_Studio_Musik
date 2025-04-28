import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<Map<String, dynamic>>getBookingsData() async{
  final response = await supabase
      .from("settings")
      .select()
      .single();

  return {
    "harga": response['harga'] ?? 0,
  };
}

Future<List<Map<String, dynamic>>> getTodayBookings() async {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  final response = await supabase
      .from('bookings')
      .select('*, users(*)')
      .gte('tanggal', startOfDay.toIso8601String())
      .lt('tanggal', endOfDay.toIso8601String())
      .order('tanggal');

  return List<Map<String, dynamic>>.from(response);
}
