import 'package:blogapp/Service/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blogapp/Modules/UserModel.dart';
import 'package:blogapp/Service/PostService.dart';
import 'package:blogapp/Modules/PostModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> _userFuture;
  late Future<List<PostModel>> _userPosts;
  late Future<int> _postCount;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _userFuture = getUserData(uid);
    _userPosts = getPostsByUserId(uid);
    _postCount = _userPosts.then((posts) => posts.length);
  }

  Future<void> _updateUserField(String field, String newValue) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({field: newValue});

    setState(() {
      _userFuture = getUserData(uid);
    });
  }

  void _showEditBottomSheet(
    BuildContext context,
    String field,
    String initialValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: initialValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit $field",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter new $field'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/images/logo-transparent.png'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(child: Text(user.email)),
                  const Divider(height: 32, thickness: 1),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text("Phone: ${user.phone}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditBottomSheet(context, 'phone', user.phone,
                            (value) {
                          _updateUserField('phone', value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text("Gender: ${user.gender}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditBottomSheet(context, 'gender', user.gender,
                            (value) {
                          _updateUserField('gender', value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: Text("Job: ${user.job}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditBottomSheet(context, 'job', user.job, (value) {
                          _updateUserField('job', value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: Text("Address: ${user.address}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditBottomSheet(context, 'address', user.address,
                            (value) {
                          _updateUserField('address', value);
                        });
                      },
                    ),
                  ),
                  const Divider(height: 32, thickness: 1),
                  FutureBuilder<int>(
                    future: _postCount,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Text("Loading posts...");
                      return Text("Posts: ${snapshot.data}",
                          style: const TextStyle(fontSize: 16));
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("My Posts",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  FutureBuilder<List<PostModel>>(
                    future: _userPosts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text("Error loading posts: ${snapshot.error}");
                      }

                      final posts = snapshot.data!;
                      if (posts.isEmpty) {
                        return const Text("No posts yet.");
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          final imageUrl = (post.imageUrl.isNotEmpty)
                              ? post.imageUrl
                              : 'https://ik.imagekit.io/demo/img/default-image.jpg';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.text),
                                  const SizedBox(height: 8),
                                  if (post.imageUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imageUrl,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Text(
                                                    "⚠️ Failed to load image"),
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.favorite, size: 16),
                                      const SizedBox(width: 4),
                                      Text("${post.likes.length} likes"),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.comment, size: 16),
                                      const SizedBox(width: 4),
                                      Text("${post.commentsCount} comments"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
