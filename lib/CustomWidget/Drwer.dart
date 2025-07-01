import 'package:blogapp/pages/Login.dart';
import 'package:blogapp/pages/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<String> getUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['name'] ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 163, 31, 154),
                  Color.fromARGB(255, 72, 25, 76),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(
                      'assets/images/e7fc7b0a-1da9-43b7-910c-a33195b696a9.jpg',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder<String>(
                  future: getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: Colors.white);
                    } else if (snapshot.hasError) {
                      return const Text('Error', style: TextStyle(color: Colors.white));
                    } else {
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text("Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
  leading: const Icon(Icons.logout, color: Colors.redAccent),
  title: const Text("Logout"),
  onTap: () async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  },
),

        ],
      ),
    );
  }
}
