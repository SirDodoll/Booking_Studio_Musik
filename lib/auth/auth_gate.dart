import 'package:booking_application/root_screens.dart';
import 'package:booking_application/screens/home.dart';
import 'package:booking_application/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/sign_up.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,

      builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }
          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session!=null){
            return RootScreen();
          }else{
            return SignInScreen();
          }
      },
    );
  }
}
