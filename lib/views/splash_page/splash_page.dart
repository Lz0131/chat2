import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/managers/local_db_manager/local_db.dart';
import 'package:chatlinxs/managers/navigation_manager/navigation_manager.dart';
import 'package:chatlinxs/models/size_config.dart';
import 'package:chatlinxs/widgets/gradient_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      if (LocalDB.isUserLoggedIn) {
        NavigationManager.navigate(context, Routes.rootScreen);
      } else {
        NavigationManager.navigate(context, Routes.onboardingScreen);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: backgroundColor(context),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 100.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GradientWidget(
                  gradient: LinearGradient(colors: [
                    greenGradient.lightShade,
                    greenGradient.darkShade,
                  ]),
                  child: const Text(
                    "Chatlinxs",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'from',
                style: TextStyle(
                    color: grayColor(context).lightShade.withOpacity(0.4),
                    fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LineIcons.infinity,
                    size: 32,
                    color: greenColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Meta",
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: grayColor(context).lightShade),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.12,
              )
            ],
          )
        ],
      ),
    );
  }
}
