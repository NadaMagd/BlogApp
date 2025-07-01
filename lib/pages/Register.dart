import 'package:blogapp/Modules/UserModel.dart';
import 'package:blogapp/Service/AuthService.dart';
import 'package:blogapp/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:blogapp/CustomWidget/TextField.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController job = TextEditingController();
  TextEditingController address = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                  "Welcome Our World !",
                  style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 77, 51, 81),
                      fontWeight: FontWeight.bold,
                      fontFamily: AutofillHints.birthdayYear,
                      decorationStyle: TextDecorationStyle.wavy),
                ),
                const SizedBox(height: 30),
                Form(
                  key: formState,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: username,
                        hintText: 'Username',
                        obsucure: false,
                        icon: const Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'You must enter a name';
                          if (value.length < 6)
                            return 'Name must be at least 6 characters';
                          return null;
                        },
                      ),
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
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!%*?&]{8,}$',
                          );
                          if (!passwordRegex.hasMatch(value)) {
                            return 'Password must include upper/lowercase, number and symbol';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: phone,
                        hintText: "YourPhone",
                        obsucure: false,
                        icon: const Icon(Icons.phone),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          final phoneRegex = RegExp(r'^01[0125][0-9]{8}$');
                          if (!phoneRegex.hasMatch(value.trim())) {
                            return 'Phone Wrong please Write Phone like this 0123456789';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: job,
                        hintText: "YourJob",
                        obsucure: false,
                        icon: const Icon(Icons.work),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your job';
                          }
                          if (value.length < 3) {
                            return 'Please Enter More than 3 Char';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: address,
                        hintText: "YourAddress",
                        obsucure: false,
                        icon: const Icon(Icons.add_home_rounded),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Address';
                          }
                          if (value.length < 3) {
                            return 'Please Enter More than 3 Char';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Your Gender",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 77, 51, 81),
                              fontWeight: FontWeight.w600,
                              fontFamily: AutofillHints.birthdayYear),
                        ),
                      ),
                      Column(
                        children: [
                          RadioListTile(
                            title: Text("Female"),
                            value: "Female",
                            groupValue: gender,
                            onChanged: (val) {
                              setState(() {
                                gender = val;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("Male"),
                            value: "Male",
                            groupValue: gender,
                            onChanged: (val) {
                              setState(() {
                                gender = val;
                              });
                            },
                          ),
                        ],
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
                              Register(
                                email: email.text,
                                password: password.text,
                                user: UserModel(
                                  name: username.text,
                                  email: email.text,
                                  password: password.text,
                                  phone: phone.text,
                                  gender: gender!,
                                  job: job.text,
                                  address: address.text,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            }
                          },
                          child: const Text("SignuP",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/images/download.png',
                            height: 24,
                          ),
                          label: const Text("Sign up with Google"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final user = await signInWithGoogle();
                            if (user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Google Sign-In Failed")),
                              );
                            }
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 123, 124, 125)),
                        ),
                      )
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
