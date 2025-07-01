import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void toggleLike(String postId, String userId, List<dynamic> currentLikes) async {
  final isLiked = currentLikes.contains(userId);
  await FirebaseFirestore.instance.collection('posts').doc(postId).update({
    'likes': isLiked
        ? FieldValue.arrayRemove([userId])
        : FieldValue.arrayUnion([userId])
  });
}

  void confirmDelete(BuildContext context, String postId) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Text("Delete Post"),
      content: const Text("Are you sure?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance.collection('posts').doc(postId).delete();

            
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
