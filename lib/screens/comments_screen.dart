import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key, required this.snap});

  final Map<String, dynamic> snap;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  bool isCommenting = false;

  void _postComment(User? user) async {
    setState(() {
      isCommenting = true;
    });

    Comment comment = Comment(
      commentId: '',
      postId: widget.snap['postId'],
      text: _commentController.text,
      uid: user!.uid,
      username: user!.username,
      profileImage: user!.photoUrl,
      datePublished: DateTime.now(),
      likes: [],
    );

    String res =
        await FirestoreMethods().postComment(widget.snap['postId'], comment);

    setState(() {
      isCommenting = false;
    });

    if (res == 'Success') {
      _commentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: user!.photoUrl == null
                    ? const NetworkImage(defaultProfilePic)
                    : NetworkImage(user!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 8.0,
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: user!.username == null
                          ? 'comment as username'
                          : 'comment as ${user!.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => _postComment(user),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: isCommenting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text(
                          'Post',
                          style: TextStyle(
                            color: blueColor,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
      body: CommentCard(
        snap: widget.snap,
      ),
    );
  }
}
