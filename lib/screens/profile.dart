import 'dart:io';
import 'package:booking_application/screens/sign_in.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:booking_application/auth/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String? _uploadedImageUrl;
  bool isPicking = false;

  Future pickImage() async {
    if (isPicking) return;
    isPicking = true;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (!mounted) return;

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _uploadedImageUrl = null;
        });
      }
    } catch (e) {
      print('Image picking error: $e');
    } finally {
      isPicking = false;
    }
  }


  // Upload Image
  Future uploadImage() async {
    if (_imageFile == null) return;

    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final path = 'upload/$fileName.jpg';

    try {
      await Supabase.instance.client.storage
          .from('images')
          .upload(path, _imageFile!, fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

      final urlResponse = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(path);

      setState(() {
        _uploadedImageUrl = urlResponse;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload Success")),
        );
      }
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload Gagal")),
      );
    }
  }



  final authService = AuthService();
  final SupabaseClient supabase = Supabase.instance.client;
  String? _email;
  String? _name;
  String? _telepon;

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
    });
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
                        backgroundImage: _uploadedImageUrl != null
                            ? NetworkImage(_uploadedImageUrl!)
                            : _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                            : null,
                        child: _uploadedImageUrl == null && _imageFile == null
                        ? const Icon(Icons.person, size: 50)
                        :null,
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                     child:  IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        onPressed: pickImage,
                      ),
                      )
                    ],
                  ),

                  const SizedBox(height: 16),
                  if (_imageFile != null)
                    ElevatedButton.icon(
                      onPressed: uploadImage,
                      icon: const Icon(Icons.upload),
                      label: const SubtitleTextWidget(label: "save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 10),
                  SubtitleTextWidget(fontWeight: FontWeight.bold, label: _name ?? "Loading..."),
                  const SizedBox(height: 5),
                  SubtitleTextWidget(fontWeight: FontWeight.bold, label: _email ?? "Loading..."),
                  const SizedBox(height: 50),
                  TextField(
                    controller: TextEditingController(text: _name ?? ""),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _email ?? ""),
                    readOnly: true,
                  ),
                  SizedBox(height: 30),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _telepon ?? ""),
                    readOnly: true,
                  ),
                      const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: logout,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: SubtitleTextWidget(
                      label: "Log Out",
                      color: Colors.white),
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
