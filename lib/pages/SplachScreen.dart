import 'package:blogapp/pages/Login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo-transparent.png"),
            const Text(
              "Welcome in our Outaki World",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Color.fromARGB(255, 92, 92, 92),
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
