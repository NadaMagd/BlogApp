import 'dart:io';
import 'package:blogapp/CustomWidget/Comment.dart';
import 'package:blogapp/CustomWidget/post-utils.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> postData;
  final String postId;
  final String currentUserId;

  const PostCard({
    super.key,
    required this.postData,
    required this.postId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final author = postData['authorName'] ?? 'Unknown';
    final text = postData['text'] ?? '';
    final imageUrl = postData['imageUrl'] ?? '';
    final likes = List<String>.from(postData['likes'] ?? []);
    final commentsCount = postData['commentsCount'] ?? 0;
    final isLiked = likes.contains(currentUserId);
    final isOwner = postData['authorId'] == currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isOwner)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => confirmDelete(context, postId),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(text),
            const SizedBox(height: 8),
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.startsWith('http') || imageUrl.startsWith('https')
                    ? Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text("⚠️ Failed to load image"),
                      )
                    : File(imageUrl).existsSync()
                        ? Image.file(
                            File(imageUrl),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : const Text("⚠️ Image not found"),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => toggleLike(postId, currentUserId, likes),
                ),
                Text("${likes.length} Likes"),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () => showCommentsDialog(context, postId),
                ),
                Text("$commentsCount Comments"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
