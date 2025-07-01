import 'package:blogapp/CustomWidget/TextField.dart';
import 'package:blogapp/Service/AuthService.dart';
import 'package:blogapp/pages/Home.dart';

import 'package:blogapp/pages/Register.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage("assets/images/logo-transparent.png"),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Again Outak!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 77, 51, 81),
                      fontFamily: AutofillHints.birthdayYear,
                      decorationStyle: TextDecorationStyle.wavy),
                ),
                const SizedBox(height: 70),
                Form(
                  key: formState,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: email,
                        hintText: 'Email',
                        icon: const Icon(Icons.mail),
                        obsucure: false,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'You must enter an email';
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value))
                            return 'Invalid email format';
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: password,
                        hintText: 'Password',
                        icon: const Icon(Icons.password),
                        obsucure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter a password';
                          final passwordRegex = RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                          );
                          if (!passwordRegex.hasMatch(value)) {
                            return 'Password must include upper/lowercase, number and symbol';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 80, 40, 84),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (formState.currentState!.validate()) {
                              LoginUser(
                                  email: email.text, password: password.text);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }
                          },
                          child: const Text("Login",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          child: Text("Don't have an account? Sign up",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 123, 124, 125)))),
                    ],
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
