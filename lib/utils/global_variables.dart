import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';

const webScreenSize = 600;

const String defaultProfilePic =
    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

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
