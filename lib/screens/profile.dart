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
      _telepon = userData?['telepon'] ?? "Tidak ada telepon";
    });
  }

  Future pickImage() async {
    if (isPicking) return;
    isPicking = true;
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (!mounted) return;

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _uploadedImageUrl = null;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      isPicking = false;
    }
  }

  Future uploadImage() async {
    if (_imageFile == null) return;
    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final path = 'upload/$fileName.jpg';

    try {
      await Supabase.instance.client.storage
          .from('images')
          .upload(path, _imageFile!, fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

      final url = Supabase.instance.client.storage.from('images').getPublicUrl(path);

      setState(() {
        _uploadedImageUrl = url;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload Berhasil")),
        );
      }
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload Gagal")),
      );
    }
  }

  void logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const SubtitleTextWidget(label: 'Konfirmasi'),
          content: const SubtitleTextWidget(label: 'Apakah anda yakin ingin logout?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Tidak')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
          ],
        );
      },
    );

    if (confirm == true) {
      await authService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: primaryColor,
          title: SubtitleTextWidget(label: "Profile", color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
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
                                    : null,
                              ),
                              // Positioned(
                              //   child: IconButton(
                              //     icon: Icon(Icons.camera_alt, color: primaryColor),
                              //     onPressed: pickImage,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // if (_imageFile != null)
                        //   ElevatedButton.icon(
                        //     onPressed: uploadImage,
                        //     icon: const Icon(Icons.upload),
                        //     label: const Text("Upload"),
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: primaryColor,
                        //       foregroundColor: Colors.white,
                        //     ),
                        //   ),
                        const SizedBox(height: 50),
                        _buildTextField(Icons.person, _name),
                        const SizedBox(height: 30),
                        _buildTextField(Icons.email, _email),
                        const SizedBox(height: 30),
                        _buildTextField(Icons.phone, _telepon),
                        const SizedBox(height: 130),
                        ElevatedButton(
                          onPressed: logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: Size(screenWidth, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const SubtitleTextWidget(label: "Log Out", color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String? value) {
    return TextField(
      controller: TextEditingController(text: value ?? ""),
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
