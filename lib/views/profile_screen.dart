import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controller/profile_controller.dart';

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
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                              "https://rollingstoneindia.com/wp-content/uploads/2020/02/weekend.jpg"),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.black),
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
