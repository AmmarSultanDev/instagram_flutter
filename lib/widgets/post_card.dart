import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.snap});

  final Map<String, dynamic> snap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //header section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage(snap['profileImage'] ?? defaultProfilePic),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snap['username'] ?? 'Username',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          // body section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(snap['postUrl'] ?? defaultPostImage,
                fit: BoxFit.cover),
          ),
          // footer section
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_border,
                  ),
                ),
              ))
            ],
          ),
          // caption section & number of coments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text('${snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: snap['username'] ?? 'Username',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                          text: '${snap['description'] ?? 'Description'}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'View all 200 comments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    DateFormat.yMMMd().format(snap['datePublished'].toDate()) ??
                        'Date',
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
