import 'package:cloud_firestore/cloud_firestore.dart';
import '../Modules/PostModel.dart';

//===================== Upload Post ==========================
Future<PostModel> uploadPost(PostModel post) async {
  final docRef = FirebaseFirestore.instance.collection('posts').doc();

  final newPost = PostModel(
    id: docRef.id,
    authorId: post.authorId,
    authorName: post.authorName,
    text: post.text,
    likes: post.likes,
    comments: post.comments,
    commentsCount: post.commentsCount,
    timestamp: post.timestamp,
  );

  await docRef.set(newPost.toMap());

  return newPost;
}

//===================== Get Posts by User ID ==========================
Future<List<PostModel>> getPostsByUserId(String userId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('posts')
      .where('authorId', isEqualTo: userId)
      .orderBy('timestamp', descending: true)
      .get();

  return querySnapshot.docs.map((doc) {
    return PostModel.fromMap(doc.data(), id: doc.id);
  }).toList();
}

//===================== Get All Posts ==========================
Future<List<PostModel>> getAllPosts() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .get();

  return querySnapshot.docs.map((doc) {
    return PostModel.fromMap(doc.data(), id: doc.id);
  }).toList();
}

//===================== Update Post ==========================
Future<void> updatePost(PostModel post) async {
  if (post.id == null) {
    throw Exception("Post ID is required for update.");
  }
  await FirebaseFirestore.instance
      .collection('posts')
      .doc(post.id)
      .update(post.toMap());
}

//===================== Delete Post ==========================
Future<void> deletePost(String postId) async {
  await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
}
//=============================like====================================
Future<void> toggleLike(String postId, String userId) async {
  final docRef = FirebaseFirestore.instance.collection('posts').doc(postId);
  final snapshot = await docRef.get();
  final likes = List<String>.from(snapshot['likes']);

  if (likes.contains(userId)) {
    likes.remove(userId);
  } else {
    likes.add(userId);
  }

  await docRef.update({'likes': likes});
}
