import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/helper/preferences.dart';
import 'package:tiktok_clone/model/comment.dart';

import '../common/constants.dart';

final commentControllerProvider = Provider((ref) => CommentController());

class CommentController {
  final firestoreDb = FirebaseFirestore.instance;

  getComments(String videoId) {
    try {
      return firestoreDb
          .collection("videos")
          .doc(videoId)
          .collection("comments")
          .orderBy("datePublished", descending: true)
          .snapshots();
    } catch (e) {
      print(e);
      
    }
  }

  Future addComment(String videoId, String comment) async {
    final uid = Prefs.getUserId(Constants.userIdKey);
    try {
      final username = Prefs.getUsername(Constants.userNameKey);

      var allDocs = await firestoreDb
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .get();
      int len = allDocs.docs.length;
      Comment data = Comment(
          username: username,
          comment: comment,
          datePublished: DateTime.now(),
          likes: [],
          videoId: videoId,
          uid: uid);

      await firestoreDb
          .collection("videos")
          .doc(videoId)
          .collection("comments")
          .add(data.toFirestore())
          .then((value) {
        firestoreDb
            .collection("videos")
            .doc(videoId)
            .collection("comments")
            .doc(value.id)
            .update({"id": value.id});
      });

      await firestoreDb
          .collection("videos")
          .doc(videoId)
          .update({"commentCount": len + 1});
    } catch (e) {
      print(e);
    }
  }

  Future likeComment(String videoId, String commentId) async {
    DocumentSnapshot document = await firestoreDb
        .collection("videos")
        .doc(videoId)
        .collection("comments")
        .doc(commentId)
        .get();

    Comment comment = Comment.fromFirestore(document);
    print(comment.username);
    print(comment.comment);

    final userId = Prefs.getUserId(Constants.userIdKey);

    if (comment.likes.contains(userId)) {
      firestoreDb
          .collection("videos")
          .doc(videoId)
          .collection("comments")
          .doc(commentId)
          .update({
        "likes": FieldValue.arrayRemove([userId])
      });
    } else {
      firestoreDb
          .collection("videos")
          .doc(videoId)
          .collection("comments")
          .doc(commentId)
          .update({
        "likes": FieldValue.arrayUnion([userId])
      });
    }
  }
}
