import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controller/auth_controller.dart';
import 'package:tiktok_clone/views/home_screen.dart';
import 'package:tiktok_clone/views/login_screen.dart';

import '../common/common.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  signUpUser(BuildContext context, WidgetRef ref, String name, String email,
      String password) async {
    showDialog(
        context: context,
        builder: (_) => Center(
              child: CircularProgressIndicator(color: Colors.black),
            ));
    await ref
        .read(authControllerProvider)
        .registerUser(name, email, password)
        .then((value) {
      if (value == true) {
       
        nextScreenReplace(context, HomeScreen());
      } else {
        showSnackbar(context, Colors.red, value);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
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
                    "Signup into TikTok ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                      controller: usernameController,
                      cursorColor: Colors.black,
                      decoration: textDecoration.copyWith(
                          hintText: "Username",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ))),
                  SizedBox(
                    height: 20,
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
                      signUpUser(context, ref, usernameController.text,
                          emailController.text, passwordController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Text("SignUp"),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text.rich(
                    TextSpan(text: "Already have an account?", children: [
                      TextSpan(
                          text: " Login Here",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreenReplace(context, LoginScreen());
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
