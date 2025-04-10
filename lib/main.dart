import 'package:booking_application/screens/home.dart';
import 'package:booking_application/screens/sign_in.dart';
import 'package:booking_application/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/theme/theme_data.dart';
import 'package:booking_application/root_screens.dart';
import 'package:booking_application/providers/theme_providers.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jzqgehgnhlljfmhdfrto.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6cWdlaGduaGxsamZtaGRmcnRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNTE4ODgsImV4cCI6MjA1NzkyNzg4OH0.YnLyoOCb81P2EpSfA2dz4JDEPzNKRCP2DdiiUDc5DZs',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProviders, child) {
          final session = Supabase.instance.client.auth.currentSession;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ID MUSIC   ',
            theme: Styles.themeData(
                isDarkTheme: themeProviders.getIsDarkTheme,
                context: context
            ),
            home: session != null ? RootScreen() : SignInScreen(),
          );
        },
      ),
    );
  }
}
