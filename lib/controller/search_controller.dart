import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/model/user.dart';

final searchControllerProvider = Provider((ref) => SearchController());

class SearchController {
  final firestoreDb = FirebaseFirestore.instance;

  searchUsers(String name) async {
    QuerySnapshot<Map<String, dynamic>> snapshots = await firestoreDb
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: name)
        .get();

    List<User> users = [];

    for (final snapshot in snapshots.docs) {
      users.add(User.fromFirestore(snapshot));
    }
    print(users.first.name);

    return users;
  }
}
