import 'dart:io';
import 'package:blogapp/Service/PostService.dart';
import 'package:blogapp/Service/UploadImage.dart';
import 'package:blogapp/pages/Posts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blogapp/Modules/PostModel.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  File? _selectedImage;
  String? _uploadedImageUrl;

  // اختيار صورة من المعرض
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // رفع البوست
  Future<void> _uploadPost() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add some text")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
   
      if (_selectedImage != null) {
        _uploadedImageUrl =
            await ImageUploadService.uploadImageToImageKit(_selectedImage!);
      } else {
        _uploadedImageUrl = ''; // أو صورة افتراضية
      }

      final currentUser = FirebaseAuth.instance.currentUser!;

      final post = PostModel(
        id: '',
        authorId: currentUser.uid,
        authorName: currentUser.email ?? 'Unknown',
        text: _textController.text.trim(),
        imageUrl: _uploadedImageUrl ?? '',
        likes: [],
        comments: [],
        commentsCount: 0,
        timestamp: DateTime.now(),
      );

      await uploadPost(post);

      setState(() {
        _isLoading = false;
        _textController.clear();
        _selectedImage = null;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Posts()),
      );
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
        child: SingleChildScrollView(
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
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Choose Image"),
                  ),
                  const SizedBox(width: 10),
                  if (_selectedImage != null)
                    const Text("✅ Image Selected"),
                ],
              ),
              const SizedBox(height: 20),
              if (_selectedImage != null)
                Image.file(_selectedImage!, height: 100),
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
      ),
    );
  }
}
