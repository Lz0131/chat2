import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/models/size_config.dart';

class SelectedContactWidget extends StatelessWidget {
  final double size;
  final Contact user;

  const SelectedContactWidget({
    super.key,
    required this.size,
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
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: greenColor),
            child: const Center(
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: size,
            child: Center(
              child: Text(
                user.displayName,
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
