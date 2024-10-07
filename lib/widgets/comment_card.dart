import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.comment});
  final Comment comment;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: widget.comment.profileImage == null
                ? Image.asset('assets/defaultProfileImage.png').image
                : NetworkImage(widget.comment.profileImage),
            radius: 18,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.comment.username ?? 'username',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.comment.text != null
                              ? '    ${widget.comment.text}'
                              : '    comment',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(widget.comment.datePublished) ??
                          '14 Aug 2024',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () async {
                FirestoreMethods().likeComment(
                  widget.comment.postId,
                  widget.comment.commentId,
                  Provider.of<UserProvider>(context, listen: false)
                      .getUser!
                      .uid,
                  widget.comment.likes,
                );
              },
              icon: Icon(
                widget.comment.likes.contains(
                        Provider.of<UserProvider>(context, listen: false)
                            .getUser!
                            .uid)
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
