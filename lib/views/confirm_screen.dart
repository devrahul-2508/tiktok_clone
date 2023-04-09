import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/common.dart';
import 'package:tiktok_clone/controller/video_controller.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends ConsumerStatefulWidget {
  const ConfirmScreen(
      {super.key, required this.videoFile, required this.videoPath});

  final File videoFile;
  final String videoPath;

  @override
  ConsumerState<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends ConsumerState<ConfirmScreen> {
  late VideoPlayerController _controller;
  final captionController = TextEditingController();
  final songController = TextEditingController();

  uploadVideo() async {
    await ref
        .read(videoControllerProvider)
        .addVideo(widget.videoPath, captionController.text, songController.text)
        .then((value) {
      if (value != false) {
        Navigator.pop(context);
      } else {
        showSnackbar(context, Colors.red, "Video upload failed");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = VideoPlayerController.file(widget.videoFile);
    });
    _controller.initialize();
    _controller.setVolume(10);
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: VideoPlayer(_controller),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: captionController,
                  decoration: InputDecoration(
                      hintText: "Enter Caption",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: songController,
                  decoration: InputDecoration(
                      hintText: "Enter Song name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  uploadVideo();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Upload Video",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}