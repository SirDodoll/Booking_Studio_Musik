import 'package:booking_application/root_screens.dart';
import 'package:booking_application/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/auth/auth_services.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:booking_application/widget/responsive.dart'; // <- Tambahkan ini

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
    if (!_formKey.currentState!.validate()) return;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    double width = MediaQuery.of(context).size.width;
    double paddingSize = getResponsiveSize(context, 0.05);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: getResponsiveSize(context, 0.5),
                  color: primaryColor,
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: getResponsiveSize(context, 0.12),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'imprint',
                    ),
                  ),
                ),
                Container(
                  color: primaryColor,
                  child: Container(
                    padding: EdgeInsets.all(paddingSize),
                    margin: EdgeInsets.only(top: getResponsiveSize(context, 0.08)),
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
                        SizedBox(height: getResponsiveSize(context, 0.05)),
                        Text(
                          "Masuk Sekarang",
                          style: TextStyle(
                            fontSize: getResponsiveSize(context, 0.06),
                            fontFamily: 'Inder',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: getResponsiveSize(context, 0.05)),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            label: SubtitleTextWidget(label: "Email"),
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: getResponsiveSize(context, 0.04)),
                        TextField(
                          controller: _passwordController,
                          obscureText: hidePassword,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            label: const SubtitleTextWidget(label: "Password"),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: getResponsiveSize(context, 0.06)),
                        SizedBox(
                          width: double.infinity,
                          height: getResponsiveSize(context, 0.14),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: login,
                            child: SubtitleTextWidget(
                              label: "Masuk",
                              color: Colors.white,
                              fontSize: getResponsiveSize(context, 0.05),
                            ),
                          ),
                        ),
                        SizedBox(height: getResponsiveSize(context, 0.05)),
                        SizedBox(
                          width: double.infinity,
                          height: getResponsiveSize(context, 0.14),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: login,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/google.png",
                                  width: getResponsiveSize(context, 0.1),
                                  height: getResponsiveSize(context, 0.1),
                                ),
                                SizedBox(width: getResponsiveSize(context, 0.02)),
                                SubtitleTextWidget(
                                  label: "Masuk dengan Google",
                                  color: Colors.white,
                                  fontSize: getResponsiveSize(context, 0.05),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: getResponsiveSize(context, 0.03)),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Inder',
                                fontSize: getResponsiveSize(context, 0.045),
                                color: Colors.black,
                              ),
                              children: const [
                                TextSpan(text: 'Belum Punya akun? '),
                                TextSpan(
                                  text: 'Daftar',
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: getResponsiveSize(context, 0.04)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
