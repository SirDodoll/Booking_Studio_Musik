import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

  final supabase = Supabase.instance.client;

Future<String?> getSettingsValue(String name) async {
  final response = await supabase
      .from('settings')
      .select('value')
      .eq('name', name)
      .maybeSingle();

  return response?['value'];
}
