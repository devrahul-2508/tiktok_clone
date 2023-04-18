import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/constants.dart';
import 'package:tiktok_clone/helper/preferences.dart';

final profileControllerProvider = Provider((ref) => ProfileController());

class ProfileController {
  final firestoreDb = FirebaseFirestore.instance;

  getUserData(String uid) async {
    List<String> thumbnails = [];

    var myVideos = await firestoreDb
        .collection("videos")
        .where("uid", isEqualTo: uid)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await firestoreDb.collection("users").doc(uid).get();

    final userData = userDoc.data() as dynamic;

    String name = userData['name'];
    String? profilePhoto = userData['profilePhoto'];
    int posts = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    var followerDoc = await firestoreDb
        .collection("users")
        .doc(uid)
        .collection("followers")
        .get();

    var followingDoc = await firestoreDb
        .collection("users")
        .doc(uid)
        .collection("following")
        .get();

    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firestoreDb
        .collection("users")
        .doc(uid)
        .collection("followers")
        .doc(Prefs.getUserId(Constants.userIdKey))
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    final user = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'posts': thumbnails.length,
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };

    return user;
  }
}
