import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<Map<String, dynamic>>getBookingsData() async{
  final response = await supabase
      .from("bookings")
      .select()
      .single();

  return {
    "harga": response['harga'] ?? 0,
    "perJam": response['perJam'] ?? 0,
  };
}