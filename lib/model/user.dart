// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String? profilePhoto;
  String email;
  String uid;
  User({
    required this.name,
    this.profilePhoto,
    required this.email,
    required this.uid,
  });

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    
  ) {
    final data = snapshot.data();
    return User(
      name: data?['name'],
      email: data?['email'],
      uid: data?['uid'],
      profilePhoto: data?['profilePhoto'],
      
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (uid != null) "uid": uid,
      "profilePhoto": profilePhoto,
    
    };
  }
}
