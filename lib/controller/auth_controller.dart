import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/common.dart';
import 'package:tiktok_clone/common/constants.dart';
import 'package:tiktok_clone/helper/preferences.dart';
import 'package:tiktok_clone/model/user.dart' as model;

final authControllerProvider = Provider((ref) => AuthContoller());

class AuthContoller {
  var firestoreDb = FirebaseFirestore.instance;

  Future registerUser(String name, String email, String password) async {
    try {
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (cred != null) {
        model.User user =
            model.User(name: name, email: email, uid: cred.user!.uid);

        await firestoreDb
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toFirestore());

        await Prefs.setEmail(Constants.userEmailKey, email);
        await Prefs.setUsername(Constants.userNameKey, name);
        await Prefs.setLoggedInStatus(Constants.userLoggedInKey, true);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future loginUser(String email, String password) async {
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final userData = await getUserData(userCred.user!.uid);
      print(userData);
      // print(userData!.email);
      // print(userData.name);

      if (userData != null) {
        print("Preferences saved");
        await Prefs.setEmail(Constants.userEmailKey, userData.email);
        await Prefs.setUsername(Constants.userNameKey, userData.name);
        await Prefs.setLoggedInStatus(Constants.userLoggedInKey, true);

        print(Prefs.getEmail(Constants.userEmailKey));
        print(Prefs.getUsername(Constants.userNameKey));
        print(Prefs.getLoggedInStatus(Constants.userLoggedInKey));
      }

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<model.User?> getUserData(String uid) async {
    try {
      DocumentSnapshot userSnapShot =
          await firestoreDb.collection("users").doc(uid).get();

      model.User user = model.User.fromFirestore(
          userSnapShot as DocumentSnapshot<Map<String, dynamic>>);
      print(user.name);
      print(user.email);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
