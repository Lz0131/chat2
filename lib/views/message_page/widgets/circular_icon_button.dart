import 'package:flutter/material.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/models/size_config.dart';

class CircularIconButton extends StatelessWidget {
  final IconData iconData;
  final GestureTapCallback? onTap;
  final ValueChanged<LongPressStartDetails>? onLongPressStart;
  final ValueChanged<LongPressEndDetails>? onLongPressEnd;

  const CircularIconButton({
    super.key,
    required this.iconData,
    this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: blackColor(SizeConfig.cntxt).lightShade.withOpacity(0.5),
          ),
        ),
        child: Center(
          child: Icon(
            iconData,
            size: 25,
            color: blackColor(SizeConfig.cntxt).lightShade.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
