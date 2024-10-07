import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
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
      username: user.username,
      profileImage: user.photoUrl,
      datePublished: DateTime.now(),
      likes: [],
    );

    String res = await FirestoreMethods().postComment(comment);

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
                      : NetworkImage(user.photoUrl),
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
                        hintText: user.username == null
                            ? 'comment as username'
                            : 'comment as ${user.username}',
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
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'Post',
                            style: TextStyle(
                              color: blueColor,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Retrun Text('No comments yet') if there are no comments
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No comments yet'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Dismissible(
                key: Key(snapshot.data!.docs[index].id),
                background: Container(
                  color: Colors.red.withOpacity(0.75),
                  margin: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width * 0.1), // 10%
                ),
                onDismissed: (direction) async {
                  print(snapshot.data!.docs[index].id);
                  if (Comment.fromSnap(snapshot.data!.docs[index]).uid !=
                      user.uid) {
                    showSnackBar(context, 'You can only delete your comments');
                    return;
                  }
                  String res = await FirestoreMethods().deleteComment(
                    widget.snap['postId'],
                    snapshot.data!.docs[index].id,
                  );

                  if (res == 'Success') {
                    showSnackBar(context, 'comment deleted');
                  } else {
                    showSnackBar(context, res);
                  }
                },
                child: CommentCard(
                  comment: Comment.fromSnap(snapshot.data!.docs[index]),
                ),
              ),
            );
          },
        ));
  }
}
