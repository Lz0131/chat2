import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:chatlinxs/models/size_config.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/loader.json',
        width: SizeConfig.screenWidth * 0.3);
  }
}
