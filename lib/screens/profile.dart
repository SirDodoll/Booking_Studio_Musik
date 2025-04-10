import 'dart:io';
import 'package:booking_application/screens/sign_in.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:booking_application/providers/theme_providers.dart';
import 'package:booking_application/widget/text_field_widget.dart';
import 'package:booking_application/widget/button_widget.dart';
import 'package:booking_application/auth/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:booking_application/theme/theme_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService();
  final SupabaseClient supabase = Supabase.instance.client;
  String? _email;
  String? _name;
  String? _telepon;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  Future<void> _fetchUserData() async {
    final userData = await authService.getUserData();

    setState(() {
      _email = userData?['email'] ?? "Tidak ada email";
      _name = userData?['name'] ?? "Pengguna";
      _telepon = userData?['telepon'] ?? "tidak ada telepon";
      _profileImageUrl = userData?['foto'];
    });
  }
  Future<void> _uploadProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final File file = File(image.path);
      final String userId = supabase.auth.currentUser!.id;
      final String filePath = 'images/$userId.jpg';

      await supabase.storage.from('images').upload(filePath, file,
          fileOptions: const FileOptions(upsert: true));

      final String publicUrl = supabase.storage.from('images').getPublicUrl(filePath);

      await supabase.from('users').update({'foto': publicUrl}).eq('id', userId);

      setState(() {
        _profileImageUrl = publicUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto profil berhasil diperbarui!')),
      );
    } catch (e) {
      print('Gagal mengunggah foto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah foto')),
      );
    }
  }

  void logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: SubtitleTextWidget(label: 'Konfirmasi'),
          content: SubtitleTextWidget(label: 'Apakah anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Ya'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await authService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
              (route) => false,
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.getIsDarkTheme;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage("assets/images/profile.jpeg") as ImageProvider,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                     child:  IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        onPressed: _uploadProfilePicture,
                      ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SubtitleTextWidget(fontWeight: FontWeight.bold, label: _name ?? "Loading..."),
                  const SizedBox(height: 5),
                  SubtitleTextWidget(fontWeight: FontWeight.bold, label: _email ?? "Loading..."),
                  const SizedBox(height: 50),
                  TextFieldWidget(
                    icon: Icons.person,
                    hintText: "Nama",
                    controller: TextEditingController(text: _name ?? ""),
                    readOnly: true,
                  ),
                  const SizedBox(height: 30),
                  TextFieldWidget(
                    icon: Icons.email,
                    hintText: "Email",
                    controller: TextEditingController(text: _email ?? ""),
                    readOnly: true,
                  ),
                  SizedBox(height: 30),
                  TextFieldWidget(
                    icon: Icons.email,
                    hintText: "No Telepon",
                    controller: TextEditingController(text: _telepon ?? ""),
                    readOnly: true,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                  const Text(
                    "Dark Mode",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Inder"),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
                    ],
                  ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: logout,
                          text: SubtitleTextWidget(label: "Log Out", color: Colors.white,),
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          isOutlined: false,
                        ),
                      ),
                ],
              ),
            ),
          ),
                const SizedBox(height: 20),
              ],
            ),
          ),
      ),
      ),
    );
  }
}
