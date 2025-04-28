import 'package:booking_application/screens/booking.dart';
import 'package:booking_application/screens/chat.dart';
import 'package:booking_application/screens/faq.dart';
import 'package:booking_application/widget/appbarName_widget.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/widget/alatMusic_widget.dart' show MusicInstruments;
import 'package:booking_application/widget/jam_oprasional.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:booking_application/widget/IconButton.dart';
import 'package:booking_application/providers/app_constans.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:booking_application/auth/settings_services.dart';
import 'package:booking_application/widget/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? urlLokasi;
  String? urlIg;
  TimeOfDay? jamBuka;
  TimeOfDay? jamTutup;

  bool isStudioOpen() {
    final now = TimeOfDay.now();
    if (jamBuka == null || jamTutup == null) return false;
    return now.hour >= jamBuka!.hour && now.hour < jamTutup!.hour;
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final ig = await getSettingValue('instagram');
    final lokasi = await getSettingValue('lokasi');
    final buka = await getJam("jamBuka");
    final tutup = await getJam("jamTutup");

    if (!mounted) return;
    setState(() {
      urlIg = ig;
      urlLokasi = lokasi;
      jamBuka = buka;
      jamTutup = tutup;
    });
  }

  Future<TimeOfDay?> getJam(String key) async {
    final value = await getSettingValue(key);
    if (value == null) return null;

    final parts = value.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> launchLokasi() async {
    final lokasiUrl = await getSettingValue('lokasi');
    if (lokasiUrl == null) throw Exception("Lokasi tidak ditemukan");

    final Uri url = Uri.parse(lokasiUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Gagal Membuka lokasi");
    }
  }

  Future<void> launchInstagram() async {
    final igUrl = await getSettingValue('instagram');
    if (igUrl == null) throw Exception("Instagram tidak ditemukan");

    final Uri url = Uri.parse(igUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Gagal Membuka Instagram");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final isOpen = isStudioOpen();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(getResponsiveSize(context, 0.19)),
        child: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo2.png',
                height: getResponsiveSize(context, 0.07),
              ),
              SizedBox(width: 10),
              AppbarnameWidget(),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: GestureDetector(
                onTap: () {
                  launchLokasi();
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
                      const Icon(Icons.location_on, color: Colors.white, size: 20),
                      const SizedBox(width: 5),
                      const SubtitleTextWidget(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 7),
              JamOperasionalWidget(
                buka: jamBuka ?? TimeOfDay(hour: 0, minute: 0),
                tutup: jamTutup ?? TimeOfDay(hour: 0, minute: 0),
                isOpen: isOpen,
              ),
              const SizedBox(height: 7),

              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: getResponsiveSize(context, 0.96),
                    height: getResponsiveSize(context, 0.61),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Swiper(
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const BookingScreen()),
                                );
                              } else if (index == 1 && urlLokasi != null) {
                                final uri = Uri.parse(urlLokasi!);
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
                          builder: DotSwiperPaginationBuilder(
                            activeColor: secondaryColor,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Wrap(
                  spacing: 70,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    IconbuttonWidget(
                      icon: FontAwesomeIcons.whatsapp,
                      label: "WhatsApp",
                      color: Colors.green,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatScreen()),
                        );
                      },
                    ),
                    IconbuttonWidget(
                      icon: FontAwesomeIcons.instagram,
                      label: "Instagram",
                      color: Colors.purple,
                      onPressed: launchInstagram,
                    ),
                    IconbuttonWidget(
                      icon: FontAwesomeIcons.questionCircle,
                      label: "FAQ",
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FAQScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              MusicInstruments(),
            ],
          ),
        ),
      ),
    );
  }
}
