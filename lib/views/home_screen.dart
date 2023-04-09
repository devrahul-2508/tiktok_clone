import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/widgets/custom_widget.dart';

import '../common/constants.dart';
import 'confirm_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int pageIdx = 0;

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pageIdx == 2) {
      pickVideo(ImageSource.gallery, context);
    }
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            onTap: (idx) => setState(() {
                  pageIdx = idx;
                }),
            currentIndex: pageIdx,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  label: "Discover"),
              BottomNavigationBarItem(icon: CustomIcon(), label: " "),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message_outlined,
                    size: 30,
                  ),
                  label: "Inbox"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  label: "Me"),
            ]),
        body: pages[pageIdx]);
  }
}
