import 'package:booking_application/root_screens.dart';
import 'package:booking_application/screens/home.dart';
import 'package:booking_application/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/auth/auth_services.dart';
import 'package:booking_application/widget/subtitle_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool loading = false;

  void login() async {
    if (!_formKey.currentState!.validate())
      return;

    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() => loading = true);

    try {
      final response = await authService.signInWithEmailPassword(email, password);

      if (response.user != null) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RootScreen()),
              (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login gagal. Periksa kembali email dan password Anda.")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
    setState(() => loading = false);
  }


  void signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    setState(() => loading = false);
  }

  void signUpWithGoogle() async {
    setState(() => loading = true);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
        child: SizedBox(
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
                        fontFamily: 'imprint',
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
                          const Text(
                            "Masuk Sekarang",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Inder',
                              fontWeight: FontWeight.bold,
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
                            controller: _passwordController,
                            obscureText: hidePassword,
                            focusNode: _focusNode,
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
                              onPressed: login,
                              child: const SubtitleTextWidget(label: "Masuk",
                                  color: Colors.white,
                                  fontSize: 22,
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
                              onPressed: login,
                              child: Row(
                                children: [
                                  Image.asset("assets/images/google.png", width: 37, height: 37,
                                  ),
                              SizedBox(width: 5),
                              SubtitleTextWidget(label: "Masuk dengan Google",
                               color: Colors.white,
                                ),
                                ],
                              ),

                              ),
                            ),
                            const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),
                            )),
                            child: RichText(text: TextSpan(
                                style: TextStyle(fontFamily: 'Inder', fontSize: 15, color: Colors.black),
                                children: [
                                  TextSpan(text: 'Belum Punya akun?'),
                                  TextSpan(text: 'Daftar', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                  ),
                                ]
                            )
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
        );
  }
}
