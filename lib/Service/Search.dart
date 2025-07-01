import 'package:blogapp/CustomWidget/post-card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostSearchDelegate extends SearchDelegate {
  final String currentUserId;

  PostSearchDelegate({required this.currentUserId});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print("🔍 Search query: $query");

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        print("📦 Total posts in Firestore: ${snapshot.data!.docs.length}");

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          print("📝 Post text: ${data['text']}");
        }

        final posts = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final text = (data['text'] ?? '').toString().toLowerCase();
          return text.contains(query.toLowerCase());
        }).toList();

        print("✅ Filtered posts: ${posts.length}");

        if (posts.isEmpty) {
          return const Center(
            child: Text(
              "🔎 No matching posts found.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final doc = posts[index];
            final data = doc.data() as Map<String, dynamic>;

            return PostCard(
              postData: data,
              postId: doc.id,
              currentUserId: currentUserId,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Type something to search..."));
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final filteredPosts = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final text = (data['text'] ?? '').toString().toLowerCase();
          return text.contains(query.toLowerCase());
        }).toList();

        if (filteredPosts.isEmpty) {
          return const Center(child: Text("No matching suggestions."));
        }

        return ListView.builder(
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            final doc = filteredPosts[index];
            final data = doc.data() as Map<String, dynamic>;

            return PostCard(
              postData: data,
              postId: doc.id,
              currentUserId: currentUserId,
            );
          },
        );
      },
    );
  }
}
