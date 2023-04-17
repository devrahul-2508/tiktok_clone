import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String username;
  String comment;
  final datePublished;
  List likes;
  String videoId;
  String? profilePhoto;
  String uid;
  String? id;

  Comment({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.videoId,
    this.profilePhoto,
    required this.uid,
    this.id,
  });

  Map<String, dynamic> toFirestore() => {
        'username': username,
        'comment': comment,
        'datePublished': datePublished,
        'likes': likes,
        'videoId': videoId,
        'profilePhoto': profilePhoto,
        'uid': uid,
        'id': id,
      };

  factory Comment.fromFirestore(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      username: snapshot['username'],
      comment: snapshot['comment'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      videoId: snapshot['videoId'],
      uid: snapshot['uid'],
      id: snapshot['id'],
    );
  }
}
