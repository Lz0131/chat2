import 'package:flutter/material.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/models/user.dart';
import 'package:chatlinxs/widgets/custom_circular_image.dart';

class ProfileCircularWidget extends StatefulWidget {
  final User user;

  const ProfileCircularWidget({super.key, required this.user});

  @override
  State<ProfileCircularWidget> createState() => _ProfileCircularWidgetState();
}

class _ProfileCircularWidgetState extends State<ProfileCircularWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomCircularImage(size: 50, user: widget.user),
        Positioned(
          bottom: -5,
          right: -5,
          child: Container(
            decoration: BoxDecoration(
                color: !context.isDarkMode() ? Colors.white : Colors.black,
                border: Border.all(
                    width: 3,
                    color: !context.isDarkMode() ? Colors.white : Colors.black),
                shape: BoxShape.circle),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(Icons.circle, size: 14, color: greenColor),
            ),
          ),
        )
      ],
    );
  }
}
