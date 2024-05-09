import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:upi_india/upi_india.dart';
import 'package:chatlinxs/constants/enums.dart';
import 'package:chatlinxs/managers/local_db_manager/local_db.dart';
import 'package:chatlinxs/models/message.dart';
import 'package:chatlinxs/models/user.dart';
import 'package:chatlinxs/provider/message_provider.dart';
import 'package:chatlinxs/views/message_page/circular_text_field.dart';
import 'package:chatlinxs/views/message_page/widgets/circular_icon_button.dart';
import 'package:chatlinxs/views/message_page/widgets/header_section.dart';
import 'package:chatlinxs/views/message_page/widgets/message_list_view.dart';
import 'package:chatlinxs/widgets/custom_switcher.dart';
import 'package:chatlinxs/widgets/gradient_icon_button.dart';
import '../../constants/colors.dart';
import '../../models/size_config.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key, required this.user, required this.chatId});

  final User user;
  final String? chatId;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  MessageProvider? provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider!.initialize(widget.user, widget.chatId);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MessageProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: backgroundColor(context),
      body: Column(
        children: [
          HeaderSection(user: widget.user),
          const MessageListScreen(),
          CustomSwitcher(
            cond: provider?.isRecordingStarted ?? false,
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: 80,
            ),
          ),
          CustomSwitcher(
            cond: provider?.isGifClicked ?? false,
            child2: SizedBox(
              width: SizeConfig.screenWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    CircularIconButton(
                      iconData: Icons.gif,
                      onTap: () {
                        provider!.onGifToggle(context);
                      },
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: CircularTextField(
                        controller: provider!.messageController,
                        onFieldSubmitted: (value) {
                          provider!.sendMessage(Message(
                              userSendingMessageUUID: LocalDB.user.uuid,
                              messageType: MessageType.text,
                              message: value));
                          provider!.messageController.clear();
                        },
                        onChanged: (value) {
                          if (value.length < 2) {
                            setState(() {});
                          }
                        },
                        hintText: "Respond...",
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    provider!.messageController.text.isEmpty
                        ? Row(
                            children: [
                              CircularIconButton(
                                iconData: LineIcons.microphone,
                                onLongPressStart: (details) {
                                  provider!.sendMessage(Message(
                                    userSendingMessageUUID: LocalDB.user.uuid,
                                    messageType: MessageType.audio,
                                  ));
                                },
                                onLongPressEnd: (details) {},
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              CircularIconButton(
                                iconData: provider!.isRecordingStarted
                                    ? Icons.delete_outline
                                    : LineIcons.horizontalEllipsis,
                                onTap: () {
                                  showManinMenuBottomSheet(context);
                                },
                              ),
                            ],
                          )
                        : Transform.rotate(
                            angle: 0.01745 * -30,
                            child: CircularIconButton(
                              iconData: Icons.send_outlined,
                              onTap: () {
                                provider!.sendMessage(Message(
                                    userSendingMessageUUID: LocalDB.user.uuid,
                                    messageType: MessageType.text,
                                    message: provider!.messageController.text));
                                provider!.messageController.clear();
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
            child: SizedBox(
              width: SizeConfig.screenWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    CircularIconButton(
                      iconData: Icons.gif,
                      onTap: () {
                        provider!.onGifToggle(context);
                      },
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: CircularTextField(
                        controller: provider!.gifController,
                        onChanged: (value) {
                          if (value.length < 2) {
                            setState(() {});
                          }
                        },
                        hintText: "Search...",
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    CircularIconButton(
                      iconData: LineIcons.search,
                      onTap: () {
                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomSwitcher(
            cond: provider!.isGifClicked,
            child2: const SizedBox(),
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.2,
              child: const Column(
                children: [
                  // aqui estaba el fokin gif pero se quito
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showManinMenuBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80),
          child: Material(
            elevation: 4,
            borderRadius: const BorderRadius.all(Radius.circular(22)),
            child: Container(
              width: SizeConfig.screenWidth,
              height: 380,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: provider!.mainMenus.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => provider!.onMainMenuClicked(
                      context,
                      provider!.mainMenus[index].key,
                      () => showUpiApps(),
                    ),
                    child: GradientIconButton(
                      size: 60,
                      iconData: provider!.mainMenus[index].iconData,
                      text: provider!.mainMenus[index].text,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void showUpiApps() async {
    UpiIndia upiIndia = UpiIndia();
    upiIndia
        .getAllUpiApps(
          allowNonVerifiedApps: false,
          mandatoryTransactionId: false,
        )
        .then((apps) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80),
            child: Container(
              width: SizeConfig.screenWidth,
              height: 340,
              decoration: const BoxDecoration(
                color: Color(0xFF101010),
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: apps.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>
                        provider!.onUpiAppSelected(context, apps[index]),
                    child: GradientIconButton(
                      size: 60,
                      imageBytes: apps[index].icon,
                      text: apps[index].name,
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    });
  }
}

class MainMenu {
  final String text;
  final IconData iconData;
  final String key;

  MainMenu(this.text, this.iconData, this.key);
}
