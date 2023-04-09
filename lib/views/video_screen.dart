import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tiktok_clone/widgets/circle_animation.dart';
import 'package:tiktok_clone/widgets/video_player_item.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView.builder(
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                // VideoPlayerItem(videoUrl: videoUrl),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black,
                ),
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
                        buildIcons(Icons.favorite, "33.3k"),
                        buildIcons(Icons.comment, "15k"),
                        buildIcons(Icons.reply, "1k"),
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
