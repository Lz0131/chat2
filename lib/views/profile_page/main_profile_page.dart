import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:chatlinxs/constants/enums.dart';
import 'package:chatlinxs/managers/local_db_manager/local_db.dart';
import 'package:chatlinxs/managers/navigation_manager/navigation_manager.dart';
import 'package:chatlinxs/models/size_config.dart';
import 'package:chatlinxs/main.dart';
import 'package:chatlinxs/views/profile_page/profile_page.dart';
import 'package:chatlinxs/views/profile_page/settings_page.dart';
import '../../constants/colors.dart';
import 'main_profile_page_widgets.dart';
import 'package:chatlinxs/models/user.dart' as model;

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  bool toggle = true;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  model.User? us;

  @override
  void initState() {
    // TODO: implement initState
    us = infoUser();
    super.initState();
  }

  model.User infoUser() {
    model.User us = model.User(
        name: LocalDB.user.name,
        email: LocalDB.user.email,
        password: LocalDB.user.password,
        phoneNumber: LocalDB.user.phoneNumber,
        picture: LocalDB.user.picture,
        firstName: LocalDB.user.firstName,
        uuid: LocalDB.user.uuid,
        firebaseToken: LocalDB.user.firebaseToken);
    return us;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor(context),
        body: SafeArea(
            child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              profileWidget(
                  user: us!,
                  onLogoutClick: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 25, right: 25, bottom: 70),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(
                                color: context.isDarkMode()
                                    ? Colors.black26
                                    : Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Estas seguro que quieres cerrar la sesión?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: blackColor(context).darkShade,
                                      fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ButtonBar(
                                  buttonPadding: EdgeInsets.zero,
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          fixedSize: MaterialStateProperty.all(
                                              const Size(300, 30)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  greenColor)),
                                      onPressed: () async {
                                        await LocalDB.setUser(null);
                                        NavigationManager.navigate(
                                            context, Routes.splashScreen,
                                            replace: true);
                                      },
                                      child: const Text(
                                        'Si cerrar sesión!!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          fixedSize: MaterialStateProperty.all(
                                              const Size(300, 30)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  backgroundColor(context)),
                                          side: MaterialStateProperty.all(
                                              const BorderSide(
                                                  color: greenColor))),
                                      onPressed: () {},
                                      child: const Text('Cancelar',
                                          style: TextStyle(color: greenColor)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ProfilePage(
                              user: us!,
                              profilePageStatus: ProfilePageStatus.personal,
                            )));
                  }),
              const SizedBox(
                height: 26,
              ),
              Divider(
                thickness: 0.3,
                indent: 100,
                endIndent: 100,
                color: grayColor(context).darkShade.withOpacity(0.6),
              ),
              const SizedBox(
                height: 10,
              ),
              settingTile(
                  title: "No molestar",
                  settingTrailing: SettingTrailing.toggle,
                  onToggle: (value) {
                    setState(() {
                      toggle = value;
                    });
                  },
                  toggle: toggle,
                  iconData: Icons.do_not_disturb),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "ADMINISTRAR",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: grayColor(context).lightShade),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.45,
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 2,
                  // hoverThickness: 4, checar esto
                  interactive: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        settingTile(
                            title: "Ajustes",
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => const SettingsPage()));
                            },
                            settingTrailing: SettingTrailing.arrow,
                            iconData: LineIcons.cog),
                        settingTile(
                            title: "Privacidad",
                            settingTrailing: SettingTrailing.arrow,
                            iconData: LineIcons.userSecret),
                        settingTile(
                            title: "Compartir",
                            settingTrailing: SettingTrailing.arrow,
                            onTap: () {
                              Share.share(
                                  "Unete a nuestra comunidad y facilita tus interacciones entre amigos, compañeros y maestros https://ChatLinx.com/dl/");
                            },
                            iconData: LineIcons.share),
                        settingTile(
                            title: "Actualizar Contraseña",
                            settingTrailing: SettingTrailing.arrow,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        PasscodeScreen(
                                      title: const Text(
                                        'Introduce tu contraseña',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 28),
                                      ),
                                      passwordEnteredCallback:
                                          (String enteredPassword) {
                                        bool isValid =
                                            '1234' == enteredPassword;
                                        _verificationNotifier.add(isValid);
                                      },
                                      cancelButton: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                        semanticsLabel: 'Cancel',
                                      ),
                                      deleteButton: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                        semanticsLabel: 'Delete',
                                      ),
                                      backgroundColor:
                                          Colors.black.withOpacity(0.8),
                                      cancelCallback: () {
                                        Navigator.pop(context);
                                      },
                                      passwordDigits: 4,
                                      shouldTriggerVerification:
                                          _verificationNotifier.stream,
                                    ),
                                  ));
                            },
                            iconData: LineIcons.lock),
                        settingTile(
                            title: "Preguntas Frecuentes",
                            settingTrailing: SettingTrailing.arrow,
                            iconData: Icons.question_answer_outlined),
                        settingTile(
                            title: "Ayuda",
                            settingTrailing: SettingTrailing.arrow,
                            iconData: Icons.help_outline),
                        settingTile(
                            title: "Invita a un amigo",
                            settingTrailing: SettingTrailing.arrow,
                            iconData: LineIcons.users),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'from',
                        style: TextStyle(
                            color:
                                grayColor(context).lightShade.withOpacity(0.8),
                            fontSize: 13),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            LineIcons.laptopCode,
                            size: 24,
                            color: greenColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "ITC",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: backgroundColor(context, invert: true)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
