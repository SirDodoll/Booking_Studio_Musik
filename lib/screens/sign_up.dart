import 'package:flutter/material.dart';
import 'package:booking_application/widget/text_field_widget.dart';
import 'package:booking_application/widget/button_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool sembunyi = true;
  bool loading = false;

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
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Masuk Sekarang",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  icon: Icons.person,
                  hintText: "Nama Lengkap",
                  controller: nameController,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  icon: Icons.email,
                  hintText: "Email",
                  controller: mailController,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  icon: Icons.lock,
                  hintText: "Password",
                  controller: passwordController,
                  obscureText: sembunyi,
                  toggleObscureText: () {
                    setState(() => sembunyi = !sembunyi);
                  },
                ),
                const SizedBox(height: 30),
                CustomButton(
                  onPressed: signIn,
                  text: "Daftar",
                  backgroundColor: Colors.purple,
                  textColor: Colors.white,
                  isLoading: loading,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: signUpWithGoogle,
                  text: "Daftar dengan Google",
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
