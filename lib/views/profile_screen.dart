import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            "the_weekend",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
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
              "@the_weekend",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      "38.2k",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Followers",
                      style:
                          TextStyle(color: Color.fromARGB(255, 185, 185, 185)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "14",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Following",
                      style:
                          TextStyle(color: Color.fromARGB(255, 185, 185, 185)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "20",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Posts",
                      style:
                          TextStyle(color: Color.fromARGB(255, 185, 185, 185)),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                      borderSide: BorderSide(color: Colors.black, width: 1)),
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
              child: const TabBarView(
                children: [
                  Icon(Icons.directions_car),
                  Icon(Icons.directions_transit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
