import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controller/auth_controller.dart';
import 'package:tiktok_clone/views/home_screen.dart';
import 'package:tiktok_clone/views/signup_screen.dart';
import '../model/user.dart' as model;

import '../common/common.dart';
import '../common/constants.dart';
import '../helper/preferences.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  saveUserData(model.User user) async {
    await Prefs.setEmail(Constants.userEmailKey, user.email);
    await Prefs.setUsername(Constants.userNameKey, user.name);
    await Prefs.setLoggedInStatus(Constants.userLoggedInKey, true);
  }

  loginUser(WidgetRef ref, BuildContext context, String email,
      String password) async {
    showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        });
    await ref
        .read(authControllerProvider)
        .loginUser(email, password)
        .then((value) {
      if (value == true) {
        Navigator.pop(context);
        nextScreenReplace(context, HomeScreen());
      } else {
        showSnackbar(context, Colors.red, value);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login into TikTok ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                      controller: emailController,
                      cursorColor: Colors.black,
                      decoration: textDecoration.copyWith(
                          hintText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ))),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                      controller: passwordController,
                      cursorColor: Colors.black,
                      decoration: textDecoration.copyWith(
                          hintText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ))),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      loginUser(ref, context, emailController.text,
                          passwordController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Text("Login"),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text.rich(
                    TextSpan(text: "Don't have an account?", children: [
                      TextSpan(
                          text: " Register Here",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreenReplace(context, SignUpScreen());
                            },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))
                    ]),
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
