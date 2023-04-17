import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controller/search_controller.dart';

import '../model/user.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  List<User> users = [];

  searchUsers(String name, WidgetRef ref) async {
    users = await ref.read(searchControllerProvider).searchUsers(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 231, 231, 231),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  onChanged: (value) {
                    searchUsers(value, ref);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: "Search Users",
                      border: InputBorder.none),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://rollingstoneindia.com/wp-content/uploads/2020/02/weekend.jpg"),
                        ),
                        title: Text(
                          users[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: const Text(
                            "Follow",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
