class Comment {
  String commentId;
  final String text;
  final String uid;
  final String username;
  final String profileImage;
  DateTime datePublished;
  final List<dynamic> likes;
  final String postId; // Added property

  Comment({
    required this.commentId,
    required this.text,
    required this.uid,
    required this.username,
    required this.profileImage,
    required this.datePublished,
    required this.likes,
    required this.postId, // Added parameter
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      text: map['text'],
      uid: map['uid'],
      username: map['username'],
      profileImage: map['profileImage'],
      datePublished: map['datePublished'].toDate(),
      likes: map['likes'],
      postId: map['postId'], // Added assignment
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'text': text,
      'uid': uid,
      'username': username,
      'profileImage': profileImage,
      'datePublished': datePublished,
      'likes': likes,
      'postId': postId, // Added property
    };
  }
}
