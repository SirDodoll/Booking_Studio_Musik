import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    void _launchWhatsApp() async {
      final Uri url = Uri.parse("https://wa.me/6287700314206");
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception("Could not launch WhatsApp");
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const SubtitleTextWidget(
          label: "WhatsApp",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SubtitleTextWidget(label: "whatsApp digunakan untuk menghubungi admin studio", textAlign: TextAlign.center,),
                SizedBox(height: 13),
                FaIcon(FontAwesomeIcons.arrowDown),
                SizedBox(height: 16,),
                SizedBox(
                  width: 170,
               height: 46,
               child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ) ,
                    onPressed: (){
                      _launchWhatsApp();
                    },
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 27,),
                  SizedBox(width: 9),
                  SubtitleTextWidget(label: "WhatsApp", color: Colors.white,),
                    ],
                  ),
          ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
