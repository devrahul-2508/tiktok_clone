import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/common.dart';
import 'package:tiktok_clone/common/constants.dart';
import 'package:tiktok_clone/controller/comment_controller.dart';
import 'package:tiktok_clone/helper/preferences.dart';
import 'package:tiktok_clone/widgets/circle_animation.dart';
import 'package:tiktok_clone/widgets/video_player_item.dart';

import '../controller/add_video_controller.dart';
import '../model/video.dart';

class VideoScreen extends ConsumerWidget {
  VideoScreen({super.key});

  final TextEditingController _commentController = TextEditingController();
  Stream<QuerySnapshot>? comments;

  Widget _buildMessageComposer(
      BuildContext context, WidgetRef ref, Video video) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                    controller: _commentController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "Add a comment",
                        hintStyle: TextStyle(color: Colors.grey),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none))))),
        ButtonBar(
          children: [
            IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {
                sendComment(video, ref);
              },
            ),
          ],
        )
      ]),
    );
  }

  sendComment(Video video, WidgetRef ref) {
    ref
        .read(commentControllerProvider)
        .addComment(video.id!, _commentController.text);

    _commentController.clear();

    video.commentCount += 1;

    ref.read(videoControllerProvider.notifier).updateVideoLocally(video);
  }

  Widget showCommentBottomSheet(
      BuildContext context, WidgetRef ref, Video video) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 1,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                  color: Color(0xffbf5f5f4),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                children: [
                  StreamBuilder(
                    stream: comments,
                    builder: (context, snapshot) {
                      return (snapshot.hasData)
                          ? Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, int index) {
                                  return (snapshot.data!.docs.isNotEmpty)
                                      ? ListTile(
                                          leading: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: (snapshot.data!.docs[index]
                                                        ['profilePhoto'] ==
                                                    null)
                                                ? Center(
                                                    child: Text(
                                                      snapshot
                                                          .data!
                                                          .docs[index]
                                                              ["username"]
                                                          .substring(0, 1),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    child: Image.network(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['profilePhoto']),
                                                  ),
                                          ),
                                          title: Text(
                                            snapshot.data!.docs[index]
                                                ["username"],
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ["comment"],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "22h",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () => ref
                                                    .read(
                                                        commentControllerProvider)
                                                    .likeComment(
                                                        video.id!,
                                                        snapshot.data!
                                                            .docs[index]["id"]),
                                                child: (snapshot.data!
                                                        .docs[index]["likes"]
                                                        .contains(Prefs
                                                            .getUserId(Constants
                                                                .userIdKey)))
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        color: Colors.black,
                                                      ),
                                              ),
                                              Text(
                                                snapshot.data!
                                                    .docs[index]["likes"].length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ))
                                      : Container(
                                          child: Center(
                                          child: Text("No comments till now"),
                                        ));
                                },
                              ),
                            )
                          : Container(
                              child: Center(
                              child: Text("No comments till now"),
                            ));
                    },
                  ),
                  _buildMessageComposer(context, ref, video!)
                ],
              ),
            );
          }),
    );
  }

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
                buildBottomDetails(
                    video.username, video.caption, video.songName),
                Positioned(
                  right: 0,
                  top: size.height * 0.3,
                  child: Container(
                    width: 100,
                    height: size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildProfile(video.profilePhoto, video.username),
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
                              onTap: () {
                                comments = ref
                                    .watch(commentControllerProvider)
                                    .getComments(video.id!);
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        showCommentBottomSheet(
                                            context, ref, video));
                              },
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
                                video.profilePhoto, video.username))
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget buildBottomDetails(String username, String caption, String songname) {
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
                  "@${username}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  caption,
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
                songname,
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

  buildProfile(String? profilePhoto, String username) {
    return SizedBox(
      height: 70,
      width: 60,
      child: Stack(children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(100)),
          child: (profilePhoto == null)
              ? Center(
                  child: Text(
                    username.substring(0, 1),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              : ClipRRect(
                  child: Image.network(profilePhoto),
                ),
        ),
        Positioned(
          bottom: 0,
          left: 20,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 13,
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String? profilePhoto, String username) {
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
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)),
                child: (profilePhoto == null)
                    ? Center(
                        child: Text(
                          username.substring(0, 1),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image(
                          image: NetworkImage(profilePhoto),
                          fit: BoxFit.cover,
                        ),
                      ),
              ))
        ],
      ),
    );
  }
}
