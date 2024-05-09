import 'package:flutter/material.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/models/size_config.dart';
import 'package:chatlinxs/models/user.dart';
import 'package:chatlinxs/widgets/custom_circular_image.dart';

class StoryWidget extends StatelessWidget {
  final double size;
  final bool showGreenStrip;
  final User user;

  const StoryWidget({
    super.key,
    required this.size,
    this.showGreenStrip = false,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: showGreenStrip || user.picture == null
                  ? null
                  : DecorationImage(
                      image: NetworkImage(user.picture!),
                      fit: BoxFit.cover,
                    ),
              border: showGreenStrip
                  ? Border.all(color: greenColor, width: 2)
                  : null,
            ),
            child: showGreenStrip
                ? Padding(
                    padding: EdgeInsets.all(showGreenStrip ? 2.2 : 0),
                    child: CustomCircularImage(
                      size: size,
                      user: user,
                    ))
                : null,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: size,
            child: Center(
              child: Text(
                "${user.firstName} ${user.lastName ?? ""}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: grayColor(SizeConfig.cntxt).lightShade,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
