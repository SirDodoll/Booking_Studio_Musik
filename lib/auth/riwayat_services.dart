import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List<Map<String, dynamic>>> fetchRiwayatDataPaginated(DateTime startDate, DateTime endDate, {int page = 0, int limit = 5}) async {
  final from = page * limit;

  final response = await supabase
      .from('bookings')
      .select('*, users(name)')
      .gte('tanggal_booking', startDate.toIso8601String())
      .lte('tanggal_booking', endDate.toIso8601String())
      .order('tanggal_booking', ascending: false)
      .range(from, from + limit - 1);

  return (response as List).cast<Map<String, dynamic>>();
}
