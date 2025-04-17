import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

  final supabase = Supabase.instance.client;

Future<dynamic> getSettingValue(String key) async {
  final response = await supabase
      .from('settings')
      .select()
      .maybeSingle();

  return response?[key];
}

