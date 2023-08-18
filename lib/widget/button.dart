
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Dimensions/dimensions.dart';


class Button extends StatelessWidget {
  final IconData? iconData;
  final String title;
  final double width;
  final bool disable;
  final Function() onPressed;

  Button({Key? key,
    required this.onPressed,
    required this.title,
    required this.width,
    required this.disable,
    this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Dimensions.primarycolor,
            foregroundColor: Colors.white
        ),
        onPressed:disable?null:onPressed,
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(width: 8,),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
