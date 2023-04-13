import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/constants.dart';
import 'package:tiktok_clone/helper/preferences.dart';
import 'package:tiktok_clone/widgets/circle_animation.dart';
import 'package:tiktok_clone/widgets/video_player_item.dart';

import '../controller/add_video_controller.dart';
import '../model/video.dart';

class VideoScreen extends ConsumerWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final videos = ref.watch(videoControllerProvider);
    return Scaffold(
      body: PageView.builder(
          itemCount: videos.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            Video video = videos[index];
            print(video.videoUrl);
            return Stack(
              children: [
                VideoPlayerItem(videoUrl: video.videoUrl),
                buildBottomDetails(),
                Positioned(
                  right: 0,
                  top: size.height * 0.3,
                  child: Container(
                    width: 100,
                    height: size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildProfile(
                            "https://rollingstoneindia.com/wp-content/uploads/2020/02/weekend.jpg"),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                ref
                                    .read(videoControllerProvider.notifier)
                                    .likeVideo(video.id!);
                              },
                              child: Icon(
                                Icons.favorite,
                                color: (video.likes.contains(
                                        Prefs.getUserId(Constants.userIdKey)))
                                    ? Colors.red
                                    : Colors.white,
                                size: 40,
                              ),
                            ),
                            Text(
                              video.likes.length.toString(),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.comment,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            Text(
                              video.commentCount.toString(),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.reply,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            Text(
                              video.shareCount.toString(),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        CircleAnimation(
                            child: buildMusicAlbum(
                                "https://rollingstoneindia.com/wp-content/uploads/2020/02/weekend.jpg"))
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget buildBottomDetails() {
    return Positioned(
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@craig_love",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "The most satisfying job #idk #ffmr",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon(
                Icons.music_note,
                color: Colors.white,
              ),
              Text(
                "Reminder * The Weekend",
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  buildIcons(IconData icon, String number) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 40,
        ),
        Text(
          "33.3k",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      height: 70,
      width: 60,
      child: Stack(children: [
        CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(profilePhoto),
        ),
        Positioned(
          bottom: 0,
          left: 20,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(100)),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }
}
