import 'package:flutter/widgets.dart';
import 'package:tiktok_clone/views/add_video_screen.dart';
import 'package:tiktok_clone/views/video_screen.dart';

class Constants {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfilePicKey = "USERPROFILEPICKEY";
}

const pages = [
  VideoScreen(),
  Text("Discover Screen"),
  Text("Video Screen"),
  Text("Inbox Screen"),
  Text("Profile Screen"),
];
