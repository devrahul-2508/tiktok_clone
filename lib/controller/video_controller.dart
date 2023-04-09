import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/constants.dart';
import 'package:tiktok_clone/helper/preferences.dart';
import 'package:tiktok_clone/model/video.dart';
import 'package:video_compress/video_compress.dart';

final videoControllerProvider = Provider((ref) => VideoController());

class VideoController {
  var firestoreDb = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  Future<File> _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file!;
  }

  Future<String> uploadVideoToStorage(String videoPath) async {
    final videoId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = storageRef.child("Videos").child(videoId);

    await reference.putFile(await _compressVideo(videoPath));

    var videoDownloadURL = await reference.getDownloadURL();

    return videoDownloadURL;
  }

  Future<File> _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> uploadThumbnailToStorage(String videoPath) async {
    final thumbnailId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = storageRef.child("Thumbnail").child(thumbnailId);

    await reference.putFile(await _getThumbnail(videoPath));

    var thumbnailUrl = await reference.getDownloadURL();

    return thumbnailUrl;
  }

  Future addVideo(String videoPath, String caption, String songName) async {
    try {
      final videoUrl = await uploadThumbnailToStorage(videoPath);

      final thumbnailUrl = await uploadThumbnailToStorage(videoPath);

      final username = await Prefs.getUsername(Constants.userNameKey);
      final video = Video(
          username: username,
          uid: FirebaseAuth.instance.currentUser!.uid,
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnail: thumbnailUrl);

      await firestoreDb
          .collection("videos")
          .add(video.toFireStore())
          .then((documentSnapshot) {
        firestoreDb
            .collection("videos")
            .doc(documentSnapshot.id)
            .update({"id": documentSnapshot.id});
      });
    } catch (e) {
      print(e);
      return false;
    }
  }
}
