import 'package:booking_application/screens/booking.dart';
import 'package:booking_application/screens/chat.dart';
import 'package:booking_application/screens/faq.dart';
import 'package:booking_application/widget/appbarName_widget.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/widget/alatMusic_widget.dart' show MusicInstruments;
import 'package:booking_application/widget/infoJadwal.dart';
import 'package:booking_application/widget/jam_oprasional.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:booking_application/widget/IconButton.dart';
import 'package:booking_application/screens/chat.dart';
import 'package:booking_application/providers/app_constans.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TimeOfDay openTime = const TimeOfDay(hour: 9, minute: 0);
  final TimeOfDay closeTime = const TimeOfDay(hour: 22, minute: 0);
  bool isStudioOpen() {
    final now = TimeOfDay.now();
    return now.hour >= openTime.hour && now.hour < closeTime.hour;
  }

  Future<void> launchMapsUrl() async {
    const mapsUrl = 'https://maps.app.goo.gl/d4uX1DVWLUAxZ4m77';
    final uri = Uri.parse(mapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka $mapsUrl';
    }
  }

  Future<void> launchInstagram() async{
    final Uri url= Uri.parse("https://www.instagram.com/rz.kiw");

    if(!await launchUrl(url, mode: LaunchMode.externalApplication)){
      throw Exception("Gagal Membuka Instagram");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final isOpen = isStudioOpen();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo2.png',
                height: 27,
              ),
              const SizedBox(width: 10,),
              const AppbarnameWidget(),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: GestureDetector(
                onTap: () {
                 launchMapsUrl();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 20),
                      SizedBox(width: 5),
                      SubtitleTextWidget(
                        label: "Lokasi",
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child : SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 7),
              JamOperasionalWidget(
                openTime: openTime,
                closeTime: closeTime,
                isOpen: isOpen,
              ),
              SizedBox(height: 7),
              // Swiper Card
              SizedBox(
                height: 210,
                width: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (index == 0){
                            Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => BookingScreen(),
                            ),
                            );
                          }else if( index == 1){
                            const mapsUrl = 'https://maps.app.goo.gl/d4uX1DVWLUAxZ4m77';
                            final uri = Uri.parse(mapsUrl);
                            launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Image.asset(
                        AppConstants.bannersImages[index],
                        fit: BoxFit.fill,
                      ),
                      );
                    },
                    itemCount: AppConstants.bannersImages.length,
                    pagination: SwiperPagination(
                      // alignment: Alignment.center,
                      builder: DotSwiperPaginationBuilder(
                          activeColor: secondaryColor,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconbuttonWidget(
                      icon: FontAwesomeIcons.whatsapp,
                      label: "WhatsApp",
                      color: Colors.green,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(),
                          ),
                        );
                      },
                    ),
                    IconbuttonWidget(
                      icon: FontAwesomeIcons.instagram,
                      label: "Instagram",
                      color: Colors.purple,
                      onPressed: () {
                        launchInstagram();
                      },
                    ),
                    IconbuttonWidget(
                      icon: FontAwesomeIcons.questionCircle,
                      label: "FAQ",
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FAQScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 7),
              // Widget Music
              MusicInstruments(),
              SizedBox(height: 7),
              // Widget Info Jadwal Booking
              InfoJadwalWidget(
                bookings: [
                  {
                    'imageUrl': 'assets/images/profile.jpeg',
                    'name': 'nama',
                    'date': '07-03-2025',
                    'time': '09:00 - 12:00',
                  },
                  {
                    'imageUrl': 'assets/images/profile.jpeg',
                    'name': 'Orang',
                    'date': '07-03-2025',
                    'time': '13:00 - 15:00',
                  },
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
  }