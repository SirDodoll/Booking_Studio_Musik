import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> uploadProfilePicture(String userId) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      final File file = File(image.path);
      final String filePath = 'images/$userId.jpg';

      await supabase.storage.from('images').upload(filePath, file,
          fileOptions: const FileOptions(upsert: true));

      final String publicUrl = supabase.storage.from('images').getPublicUrl(filePath);

      await supabase.from('users').update({'foto': publicUrl}).eq('id', userId);

      return publicUrl;
    } catch (e) {
      print('Gagal mengunggah foto profil: $e');
      return null;
    }
  }

  Future<String?> getProfilePicture(String userId) async {
    try {
      final response = await supabase.from('users').select('foto').eq('id', userId).single();
      return response['foto'];
    } catch (e) {
      print('Gagal mengambil foto profil: $e');
      return null;
    }
  }
}
