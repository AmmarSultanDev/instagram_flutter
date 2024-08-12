import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';

const webScreenSize = 600;

const String defaultProfilePic =
    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

const String defaultPostImage =
    'https://plus.unsplash.com/premium_photo-1720380988344-1fce88bc53a6?q=80&w=2148&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

const homeScreenItems = [
  Center(
    child: Text('Home'),
  ),
  Center(
    child: Text('Search'),
  ),
  AddPostScreen(),
  Center(
    child: Text('Favorite'),
  ),
  Center(
    child: Text('Profile'),
  ),
];
