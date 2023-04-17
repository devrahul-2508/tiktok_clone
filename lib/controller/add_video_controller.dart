import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/constants.dart';
import 'package:tiktok_clone/helper/preferences.dart';
import 'package:tiktok_clone/model/video.dart';
import 'package:video_compress/video_compress.dart';

final videoControllerProvider =
    StateNotifierProvider<VideoController, List<Video>>(
        (ref) => VideoController([]));

class VideoController extends StateNotifier<List<Video>> {
  VideoController(super.state) {
    _init();
  }
  var firestoreDb = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> _init() async {
    await getVideos();
  }

  void addVideoLocally(Video video) {
    state = [...state, video];
  }

  void updateVideoLocally(Video video) {
    state = [
      for (final t in state)
        if (t.id == video.id) video else t
    ];
  }

  Future<File> _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file!;
  }

  uploadVideoToStorage(String videoPath, Function(dynamic) func) async {
    final videoId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = storageRef.child("Videos").child(videoId);

    final uploadTask = reference.putFile(await _compressVideo(videoPath));

    uploadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          func(progress);
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete

          reference.getDownloadURL().then((downloadUrl) => func(downloadUrl));

          // ...
          break;
      }
    });

    //var videoDownloadURL = await reference.getDownloadURL();

    // return videoDownloadURL;
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

  Future addVideo(String videoUrl, String videoPath, String caption,
      String songName) async {
    try {
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
       
        video.id = documentSnapshot.id;
        addVideoLocally(video);

        firestoreDb
            .collection("videos")
            .doc(documentSnapshot.id)
            .update({"id": documentSnapshot.id}).then((value) {
          ;

          addVideoLocally(video);
        });
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getVideos() async {
    try {
      QuerySnapshot querySnapshot =
          await firestoreDb.collection("videos").get();
      for (var docSnapShot in querySnapshot.docs) {
        Video video = Video.fromFireStore(
            docSnapShot as DocumentSnapshot<Map<String, dynamic>>);
        addVideoLocally(video);
      }
    } catch (e) {
      print("Error thrown");
      print(e);
    }
  }

  Future likeVideo(String id) async {
    DocumentSnapshot snapshot =
        await firestoreDb.collection("videos").doc(id).get();

    Video video =
        Video.fromFireStore(snapshot as DocumentSnapshot<Map<String, dynamic>>);

    var uid = Prefs.getUserId(Constants.userIdKey);
    print(uid);

    if (video.likes.contains(uid)) {
      video.likes.remove(uid);

      updateVideoLocally(video);
      await firestoreDb.collection("videos").doc(id).update({
        "likes": FieldValue.arrayRemove([uid])
      });
    } else {
      video.likes.add(uid);

      updateVideoLocally(video);
      await firestoreDb.collection("videos").doc(id).update({
        "likes": FieldValue.arrayUnion([uid])
      });
    }
  }
}
