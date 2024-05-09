import 'dart:math';
import 'package:chatlinxs/managers/local_db_manager/local_db.dart';
import 'package:chatlinxs/models/call.dart';
import 'package:chatlinxs/provider/call_provider.dart';
import 'package:chatlinxs/widgets/custom_loader.dart';
import 'package:chatlinxs/widgets/no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/constants/enums.dart';
import 'package:chatlinxs/constants/persons.dart';
import 'package:chatlinxs/models/user.dart';
import 'package:chatlinxs/views/home_page/widgets/search_bar.dart';
import 'package:chatlinxs/views/home_page/widgets/status_bar.dart';
import 'package:chatlinxs/widgets/custom_listtile.dart';
import 'package:chatlinxs/widgets/gradient_icon_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CallListPage extends StatefulWidget {
  const CallListPage({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  _CallListPageState createState() => _CallListPageState();
}

class _CallListPageState extends State<CallListPage> {
  bool isSearch = false;
  CallProvider? provider;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(context),
      floatingActionButton: Consumer<CallProvider>(
        builder: (context, provider, child) => FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          child: const GradientIconButton(
              size: 55, iconData: Icons.phone_forwarded),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Consumer<CallProvider>(builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Llamadas",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: blackColor(context).darkShade),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Transform.rotate(
                        angle: isSearch ? pi * (90 / 360) : 0,
                        child: IconButton(
                          icon: Icon(isSearch ? Icons.add : Icons.search,
                              size: 32),
                          splashRadius: 20,
                          onPressed: () {
                            provider.toggleIsSearch();
                            provider.controller.clear();
                          },
                          color: greenColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                provider.isSearch
                    ? SearchBarWidget(controller: provider.controller)
                    : StatusBar(
                        addWidget: false,
                        seeAllWidget: false,
                        statusList: provider.statusList),
              ],
            );
          }),
          /*
          */
          Consumer<CallProvider>(
            builder: (context, provider, child) => Expanded(
              child: provider.controller.text.trim().isNotEmpty
                  ? const Center(
                      child: CustomLoader(),
                    )
                  : FutureBuilder(
                      future: provider.manager.getUserCalls(LocalDB.user.uuid),
                      builder: (context, data) {
                        if (data.hasData &&
                            data.connectionState == ConnectionState.done) {
                          return StreamBuilder(
                            stream: data.data,
                            builder: (context, data) {
                              if (data.data != null) {
                                List<Call> call = data.data!.docs
                                    .map((e) => Call.fromJson(e.data()))
                                    .toList();
                                if (call.isEmpty) {
                                  return const Center(child: NoDataFound());
                                }
                                return ListView.separated(
                                  padding: const EdgeInsets.only(top: 10),
                                  controller: widget.scrollController,
                                  itemCount: call.length,
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      thickness: 0.3,
                                    );
                                  },
                                  itemBuilder: (context, index) => Slidable(
                                    key: UniqueKey(),
                                    child: CustomListTile(
                                        imageUrl: call[index].user.picture ??
                                            "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                        participants: const [],
                                        title: call[index].user.name,
                                        subTitle:
                                            call[index].dateTime.toString(),
                                        onTap: () {},
                                        numberOfCalls: int.tryParse(call[index]
                                            .numberofCalls
                                            .toString()),
                                        customListTileType:
                                            CustomListTileType.call,
                                        callStatus: CallStatus.accepted),
                                  ),
                                );
                              } else if (data.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(child: CustomLoader());
                              } else {
                                return const Center(child: NoDataFound());
                              }
                            },
                          );
                        } else {
                          return const Center(child: NoDataFound());
                        }
                      }),
            ),
          )
        ],
      )),
    );
  }
}
