import 'package:blogapp/Service/PostService.dart';
import 'package:blogapp/pages/Posts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blogapp/Modules/PostModel.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  Future<void> _uploadPost() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add some text")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser!;

      final post = PostModel(
        id: '',
        authorId: currentUser.uid,
        authorName: currentUser.email ?? 'Unknown',
        text: _textController.text.trim(),
        likes: [],
        comments: [],
        commentsCount: 0,
        timestamp: DateTime.now(),
      );

      await uploadPost(post);

      setState(() {
        _isLoading = false;
        _textController.clear();
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Posts()));
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadPost,
                    child: const Text("Post"),
                  ),
          ],
        ),
      ),
    );
  }
}
