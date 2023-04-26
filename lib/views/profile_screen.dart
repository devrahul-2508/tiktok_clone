import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/constants.dart';
import 'package:tiktok_clone/controller/profile_controller.dart';

import '../helper/preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  String uid;
  ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  var user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    user = await ref.read(profileControllerProvider).getUserData(widget.uid);
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserDetails(),
        builder: (context, snapshot) {
          return (user == null)
              ? Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      leading: const Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Colors.black,
                      ),
                      actions: const [
                        Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                        ),
                      ],
                      title: Text(
                        "@${user["name"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      centerTitle: true,
                      elevation: 0.5,
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100)),
                          child: (user["profilePhoto"] == null)
                              ? Center(
                                  child: Text(
                                    user["name"].substring(0, 1),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image(
                                    image: NetworkImage(user["profilePhoto"]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "@${user["name"]}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  user["followers"].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 185, 185, 185)),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  user["following"].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 185, 185, 185)),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  user["posts"].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Posts",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 185, 185, 185)),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        (widget.uid == Prefs.getUserId(Constants.userIdKey))
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  ref
                                      .read(profileControllerProvider)
                                      .followUser(widget.uid);

                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: (user["isFollowing"] == false)
                                          ? Colors.white
                                          : Colors.black,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: (user["isFollowing"] == false)
                                      ? Text(
                                          "Follow",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : Text(
                                          "Following",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                        SizedBox(
                          height: 50,
                          child: AppBar(
                            backgroundColor: Colors.white,
                            elevation: 0.0,
                            bottom: TabBar(
                              indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1)),
                              tabs: [
                                Tab(
                                    icon: Icon(
                                  Icons.menu,
                                  color: Colors.grey,
                                )),
                                Tab(
                                    icon: Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.grey,
                                )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              buildPosts(),
                              Icon(Icons.directions_transit),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }

  Widget buildPosts() {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: user["thumbnails"].length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1, crossAxisSpacing: 5),
        itemBuilder: (context, index) {
          String thumbnail = user["thumbnails"][index];
          return CachedNetworkImage(
            imageUrl: thumbnail,
            fit: BoxFit.cover,
          );
        });
  }
}
