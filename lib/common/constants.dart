import 'package:flutter/widgets.dart';
import 'package:tiktok_clone/views/video_screen.dart';

import '../views/profile_screen.dart';
import '../views/search_screen.dart';

class Constants {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfilePicKey = "USERPROFILEPICKEY";
  static String userIdKey = "USERIDKEY";
}

final pages = [
  VideoScreen(),
  SearchScreen(),
  Text("Video Screen"),
  Text("Inbox Screen"),
  ProfileScreen(),
];
