import 'package:booking_application/auth/settings_services.dart';
import 'package:booking_application/root_screens.dart';
import 'package:booking_application/screens/sign_in.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/auth/auth_services.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponeController =TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool hideConfirm = true;

  // Sign in Google
  void initState() {
    _setupAuthListener();
    super.initState();
  }
  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RootScreen(),
          ),
        );
      }
    });
  }
  Future<AuthResponse> _googleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId = '1093587091479-0jkhdhm4pthpfeagi4qddnoskv6hssd1.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = 'my-ios.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      // clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  void SignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final telepon = _teleponeController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPassword.text.trim();

    if (password !=confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Tidak Sesuai")));
      return;
    }

    try{
      await authService.signUpWithEmailPassword(name, email, password, telepon);

      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 210,
                    color: const Color(0xFF6539A2),
                    alignment: Alignment.center,
                    child: const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Imprint',
                      ),
                    ),
                  ),
                  Container(
                    color: const Color(0xFF6539A2),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(top: 40),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const SubtitleTextWidget(
                            label: "Daftar Sekarang",
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              label: SubtitleTextWidget(label: "Nama"),
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              label: SubtitleTextWidget(label: "Email"),
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            keyboardType: TextInputType.phone,
                            controller: _teleponeController,
                            decoration: const InputDecoration(
                              label: SubtitleTextWidget(label: "No Telepon"),
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: hidePassword,
                            focusNode: _passwordFocus,
                            decoration: InputDecoration(
                              label: SubtitleTextWidget(label: "Password"),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    hidePassword ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _confirmPassword,
                            obscureText: hideConfirm,
                            focusNode: _confirmFocus,
                            decoration: InputDecoration(
                              label: SubtitleTextWidget(label: "Konfirmasi Password"),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    hideConfirm ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    hideConfirm = !hideConfirm;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6539A2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: SignUp,
                              child: const SubtitleTextWidget(label: "Daftar",
                                  color: Colors.white,
                                  fontSize: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _googleSignIn,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/google.png",
                                    width: 37,
                                    height: 37,
                                  ),
                                  SizedBox(width: 5),
                                  SubtitleTextWidget(label: "Masuk dengan google",
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),
                            )),
                            child: Center(
                                child: RichText(text: TextSpan(
                                  style: TextStyle(fontFamily: 'Inder', fontSize: 15, color: Colors.black),
                                  children: [
                                    TextSpan(text: 'Sudah Punya akun?'),
                                    TextSpan(text: 'Masuk', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                    ),
                                  ]
                                )
                                )
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
