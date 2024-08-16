import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, this.user});

  User? user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user == null) {
      widget.user = Provider.of<UserProvider>(context, listen: false).getUser;
    }
    //widget.user ??= Provider.of<UserProvider>(context).getUser;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: user?.uid == widget.user!.uid
            ? Text(user!.username)
            : Text(widget.user!.username),
        actions: user?.uid == widget.user!.uid
            ? [
                IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      AuthMethods().logOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }),
              ]
            : [],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          Image.asset('assets/defaultProfileImage.png').image,
                      radius: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStateColumn(0, 'Posts'),
                              buildStateColumn(0, 'Followers'),
                              buildStateColumn(0, 'Following'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FollowButton(
                                  backgroundColor: mobileBackgroundColor,
                                  borderColor: Colors.grey,
                                  text: 'EditProfile',
                                  textColor: primaryColor)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    'username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    'bio',
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label.toString(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
