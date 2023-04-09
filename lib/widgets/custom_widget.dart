import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 45,
      child: Stack(children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          width: 38,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 45, 100),
              borderRadius: BorderRadius.circular(7)),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 38,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 32, 211, 234),
              borderRadius: BorderRadius.circular(7)),
        ),
        Center(
          child: Container(
            height: double.infinity,
            width: 38,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(7)),
            child: Center(
              child: Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
