import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Video {
  String username;
  String uid;
  String? id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  String? profilePhoto;
  Video({
    required this.username,
    required this.uid,
    this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    this.profilePhoto,
  });

  

  Map<String, dynamic> toFireStore() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'id': id,
      'likes': likes,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'songName': songName,
      'caption': caption,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'profilePhoto': profilePhoto,
    };
  }

  factory Video.fromFireStore(
        DocumentSnapshot<Map<String, dynamic>> snapshot,

  ) {
        final data = snapshot.data();

    return Video(
      username: data?['username'] as String,
      uid: data?['uid'] as String,
      id: data?['id'] as String,
      likes: List.from(data?['likes'] as List),
      commentCount: data?['commentCount'] as int,
      shareCount: data?['shareCount'] as int,
      songName: data?['songName'] as String,
      caption: data?['caption'] as String,
      videoUrl: data?['videoUrl'] as String,
      thumbnail: data?['thumbnail'] as String,
      profilePhoto: data?['profilePhoto'],
    );
  }

}
