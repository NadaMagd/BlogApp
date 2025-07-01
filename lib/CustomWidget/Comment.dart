import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blogapp/Service/PostService.dart';


void showCommentsDialog(BuildContext context, String postId) {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => FutureBuilder<List<Map<String, dynamic>>>(
      future: getComments(postId),
      builder: (context, snapshot) {
        final comments = snapshot.data ?? [];

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Comments",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),

              if (comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("No comments yet."),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final username = comment['username'] ?? 'User';
                      final text = comment['text'] ?? '';
                      final time = comment['timestamp'] ?? '';
                      final dateTime = DateTime.tryParse(time);
                      final formattedTime = dateTime != null
                          ? "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} • ${dateTime.day}/${dateTime.month}"
                          : '';

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/anime-moon-landscape.jpg'),
                        ),
                        title: Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(text),
                            const SizedBox(height: 4),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              const Divider(height: 24),

              
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Write a comment...",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.trim().isNotEmpty) {
                    await addCommentToPost(
                      postId: postId,
                      userId: currentUser.uid,
                      username: currentUser.email ?? 'Anonymous',
                      commentText: controller.text.trim(),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Send"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    ),
  );
}
