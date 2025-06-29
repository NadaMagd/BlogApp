class PostModel {
  final String? id;
  final String authorId;
  final String authorName;
  final String text;

  final String imageUrl; 
  final List<String> likes;
  final List<String> comments;
  final int commentsCount;
  final DateTime timestamp;

  PostModel({
    this.id,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.imageUrl, 

    required this.likes,
    required this.comments,
    required this.commentsCount,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'text': text,
      'imageUrl': imageUrl, 

      'likes': likes,
      'comments': comments,
      'commentsCount': commentsCount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return PostModel(
      id: id,
      authorId: map['authorId'],
      authorName: map['authorName'],
      text: map['text'],
      imageUrl: map['imageUrl'], 

      likes: List<String>.from(map['likes']),
      comments: List<String>.from(map['comments']),
      commentsCount: map['commentsCount'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
