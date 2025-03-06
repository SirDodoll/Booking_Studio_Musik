import 'package:booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_application/providers/theme_providers.dart';
import 'package:booking_application/widget/text_field_widget.dart';
import 'package:booking_application/widget/button_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logoutUser() {

  }

  @override
  Widget build(BuildContext context) {
    final String imageProfile = "assets/images/slide.png";
    final String nama = "username";
    final String email = "username123@gmail.com";
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.getIsDarkTheme;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(imageProfile),
                  ),
                  const SizedBox(height: 10,),
                  TitlesTextWidget(label: nama),
                  SizedBox(height: 5),
                  TitlesTextWidget(label: email),
                  const SizedBox(height: 70),
                  TextFieldWidget(
                    icon: Icons.person,
                    hintText: "Nama Lengkap",
                    controller: TextEditingController(text: "Nama User"),
                    readOnly: true,
                  ),
                  const SizedBox(height: 30),
                  TextFieldWidget(
                    icon: Icons.email,
                    hintText: "Email",
                    controller: TextEditingController(text: "user@email.com"),
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Dark Mode",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    onPressed: _logoutUser,
                    text: "Log Out",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    isOutlined: false,
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
