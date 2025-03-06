import 'package:flutter/material.dart';
import 'package:booking_application/theme/theme_data.dart';
import 'package:booking_application/root_screens.dart';
import 'package:booking_application/providers/theme_providers.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider(),),
    ],
      child: Consumer<ThemeProvider>(
          builder: (context,themeProviders, child){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'flutter demo',
              theme: Styles.themeData(
                  isDarkTheme: themeProviders.getIsDarkTheme, context: context),
              home: RootScreen(),
            );
          }),
    );
  }
}