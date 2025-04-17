import 'package:booking_application/screens/booking.dart';
import 'package:booking_application/screens/chat.dart';
import 'package:booking_application/screens/home.dart';
import 'package:booking_application/screens/profile.dart';
import 'package:booking_application/screens/riwayat.dart';
import 'package:booking_application/widget/responsive.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/theme/theme_data.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  int currentScreen = 0;


  List<Widget> screens = [
    HomeScreen(),
    BookingScreen(),
    RiwayatScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
       navigationBarTheme:  NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
           TextStyle(
            fontFamily: 'Inder',
            fontSize: getResponsiveSize(context, 0.035),
          ),
        ),
      ),
        ),
      child: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        height: kBottomNavigationBarHeight,
        elevation: 2,
        onDestinationSelected: (value) {
          controller.jumpToPage(value);
          setState(() {
            currentScreen = value;
          });
        },
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home,),
            label: "home",
          ),
          // NavigationDestination(
          //   selectedIcon: Icon(IconlyBold.chat),
          //   icon: Icon(IconlyLight.chat),
          //   label: "chat",
          // ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.calendar),
            icon: Icon(IconlyLight.calendar),
            label: "booking",
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.timeCircle),
            icon: Icon(IconlyLight.timeCircle),
            label: "riwayat",
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: "profile",
          ),
        ],
      ),
      )
    );
  }
}
