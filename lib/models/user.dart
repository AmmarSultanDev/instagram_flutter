class User {
  final String uid;
  final String email;
  final String username;
  final String bio;
  final String photoUrl;
  final List<String> followers;
  final List<String> following;

  User(
      {required this.email,
      required this.username,
      required this.bio,
      required this.photoUrl,
      required this.followers,
      required this.following,
      required this.uid});

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'username': username,
        'bio': bio,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
      };
}
