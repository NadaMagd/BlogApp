import 'package:blogapp/CustomWidget/Drwer.dart';
import 'package:blogapp/Service/Search.dart';
import 'package:blogapp/pages/AddPost.dart';
import 'package:blogapp/pages/MyPosts.dart';
import 'package:blogapp/pages/Posts.dart';
import 'package:blogapp/pages/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OutakVibs",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 25),
        ),
        backgroundColor: Color.fromARGB(255, 80, 40, 84),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, color: Colors.white),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Main",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.white),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "My Posts",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, color: Colors.white),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "CreatePost",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(
                    currentUserId: FirebaseAuth.instance.currentUser!.uid),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer (),
      body: TabBarView(
        controller: _tabController,
        children: [
          Posts(),
          MyPostsPage(),
          AddPost(),
        ],
      ),
    );
  }
}
