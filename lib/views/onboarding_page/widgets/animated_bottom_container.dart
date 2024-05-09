import 'dart:math';

import 'package:chatlinxs/models/user.dart' as model;
import 'package:chatlinxs/provider/new_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/models/onboarding_page.dart';
import 'package:chatlinxs/models/size_config.dart';
import 'package:chatlinxs/widgets/gradient_icon_button.dart';
import 'package:uuid/uuid.dart';

class AnimatedBottomContainer extends StatefulWidget {
  final bool showForm;
  final bool onOTPage;
  final OnBoardingPageModel page;
  final int selectedPageIndex;
  final Function() onLeftArrowClicked;
  final Function() onRightArrowClicked;
  final Function() onLeftArrowReset;
  final Function(String, String, BuildContext, Function(bool)) onSendOtpClicked;
  final Function(model.User) onOtpSubmit;

  const AnimatedBottomContainer(
      {super.key,
      required this.showForm,
      required this.onOTPage,
      required this.page,
      required this.selectedPageIndex,
      required this.onLeftArrowClicked,
      required this.onRightArrowClicked,
      required this.onLeftArrowReset,
      required this.onSendOtpClicked,
      required this.onOtpSubmit});

  @override
  State<AnimatedBottomContainer> createState() =>
      _AnimatedBottomContainerState();
}

class _AnimatedBottomContainerState extends State<AnimatedBottomContainer> {
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final NameController = TextEditingController();
  final PhoneController = TextEditingController();
  final birthDateController = TextEditingController();
  final PictureController = TextEditingController();

  late List<TextEditingController> otpControllers;
  RegExp regex = RegExp(r'^[\w-\.]+@itcelaya.edu.mx$');

  @override
  void initState() {
    otpControllers = List.generate(6, (index) => TextEditingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0.8),
      child: AnimatedContainer(
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 800),
        width: SizeConfig.screenWidth * 0.9,
        height: widget.showForm
            ? SizeConfig.screenHeight * 0.7 //tamaño
            : SizeConfig.screenHeight * 0.46,
        child: Card(
          elevation: 3,
          shadowColor: blackColor(context).lightShade.withOpacity(0.3),
          color: backgroundColor(context),
          child: !widget.showForm
              ? Column(
                  children: [
                    const SizedBox(
                      height: 26,
                    ),
                    Text(
                      widget.page.heading,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: blackColor(context).darkShade,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 14),
                      child: Text(
                        widget.page.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: blackColor(context).lightShade),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.onLeftArrowClicked();
                            },
                            child: GradientIconButton(
                                size: 40,
                                iconData: LineIcons.arrowLeft,
                                isEnabled: widget.selectedPageIndex != 0),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onRightArrowClicked();
                            },
                            child: const GradientIconButton(
                                size: 40, iconData: LineIcons.arrowRight),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : !widget.onOTPage
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        widget.onLeftArrowReset();
                                      },
                                      icon: Icon(
                                        LineIcons.arrowLeft,
                                        color: blackColor(context).darkShade,
                                      )),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Iniciar sesión",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: blackColor(context).darkShade,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "Hola, bienvenido!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: blackColor(context).lightShade,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                border: Border.all(
                                    color: blackColor(context).lightShade,
                                    width: 1.5)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: blackColor(context).lightShade,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 8),
                                  child: Container(
                                    width: 1.5,
                                    height: 46,
                                    color: blackColor(context).lightShade,
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: EmailController,
                                    style: TextStyle(
                                        color: blackColor(context).darkShade),
                                    keyboardType: TextInputType.emailAddress,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: TextStyle(
                                            color:
                                                blackColor(context).lightShade),
                                        hintText: "Correo"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                border: Border.all(
                                    color: blackColor(context).lightShade,
                                    width: 1.5)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.password,
                                          color: blackColor(context).lightShade,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 8),
                                  child: Container(
                                    width: 1.5,
                                    height: 46,
                                    color: blackColor(context).lightShade,
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: PasswordController,
                                    style: TextStyle(
                                        color: blackColor(context).darkShade),
                                    keyboardType: TextInputType.visiblePassword,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: TextStyle(
                                            color:
                                                blackColor(context).lightShade),
                                        hintText: "Contraseña"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                gradient: LinearGradient(colors: [
                                  greenGradient.darkShade,
                                  greenGradient.lightShade,
                                ])),
                            child: ElevatedButton(
                              onPressed: () {
                                print("entra");
                                if (regex.hasMatch(EmailController.text)) {
                                  widget.onSendOtpClicked(
                                    EmailController.text,
                                    PasswordController.text,
                                    context,
                                    (isOnOTPage) {
                                      setState(() {});
                                    },
                                  );
                                } else {
                                  print("Correo no valido");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent),
                              child: Container(
                                height: 45.0,
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Iniciar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      widget.onLeftArrowReset();
                                    },
                                    icon: Icon(
                                      LineIcons.arrowLeft,
                                      color: blackColor(context).darkShade,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Registro",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: blackColor(context).darkShade,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "Nos alegra que quieras unirte\nRegistra tus datos",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: blackColor(context).lightShade,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                color: blackColor(context).lightShade,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: blackColor(context).lightShade,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 8),
                                  child: Container(
                                    width: 1.5,
                                    height: 46,
                                    color: blackColor(context).lightShade,
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: EmailController,
                                    style: TextStyle(
                                      color: blackColor(context).darkShade,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle: TextStyle(
                                        color: blackColor(context).lightShade,
                                      ),
                                      hintText: "Correo",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                color: blackColor(context).lightShade,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.password,
                                          color: blackColor(context).lightShade,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 8),
                                  child: Container(
                                    width: 1.5,
                                    height: 46,
                                    color: blackColor(context).lightShade,
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: PasswordController,
                                    style: TextStyle(
                                      color: blackColor(context).darkShade,
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle: TextStyle(
                                        color: blackColor(context).lightShade,
                                      ),
                                      hintText: "Contraseña",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                color: blackColor(context).lightShade,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: blackColor(context).lightShade,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 8),
                                  child: Container(
                                    width: 1.5,
                                    height: 46,
                                    color: blackColor(context).lightShade,
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: NameController,
                                    style: TextStyle(
                                      color: blackColor(context).darkShade,
                                    ),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle: TextStyle(
                                        color: blackColor(context).lightShade,
                                      ),
                                      hintText: "Nombre",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                color: blackColor(context).lightShade,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: blackColor(context).lightShade,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 8),
                                  child: Container(
                                    width: 1.5,
                                    height: 46,
                                    color: blackColor(context).lightShade,
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: PhoneController,
                                    style: TextStyle(
                                      color: blackColor(context).darkShade,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle: TextStyle(
                                        color: blackColor(context).lightShade,
                                      ),
                                      hintText: "Teléfono",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                color: blackColor(context).lightShade,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.photo,
                                          color: blackColor(context).lightShade,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 8),
                                  child: Container(
                                    width: 1.5,
                                    height: 46,
                                    color: blackColor(context).lightShade,
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: PictureController,
                                    style: TextStyle(
                                      color: blackColor(context).darkShade,
                                    ),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(255),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle: TextStyle(
                                        color: blackColor(context).lightShade,
                                      ),
                                      hintText: "Foto (URL)",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              gradient: LinearGradient(
                                colors: [
                                  greenGradient.darkShade,
                                  greenGradient.lightShade,
                                ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                model.User user = model.User(
                                    name: NameController.text,
                                    email: EmailController.text,
                                    password: PasswordController.text,
                                    phoneNumber: EmailController.text,
                                    picture: PictureController.text,
                                    firstName: "",
                                    uuid: "",
                                    firebaseToken: "");

                                widget.onOtpSubmit(user);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Container(
                                height: 45.0,
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Registro",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  String generateRandomHex(int length) {
    return const Uuid().v4();
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();
    final String cleanText = newValue.text.replaceAll('/', '');
    if (cleanText.length <= 2) {
      newText.write(cleanText.substring(0, min(2, cleanText.length)));
      if (cleanText.length > 2) {
        newText.write('/');
      }
    } else if (cleanText.length <= 4) {
      newText.write(cleanText.substring(0, 2) + '/');
      newText.write(cleanText.substring(2, min(4, cleanText.length)));
      if (cleanText.length > 4) {
        newText.write('/');
      }
    } else {
      newText.write(cleanText.substring(0, 2) + '/');
      newText.write(cleanText.substring(2, 4) + '/');
      newText.write(cleanText.substring(4, min(8, cleanText.length)));
    }
    return newValue.copyWith(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
