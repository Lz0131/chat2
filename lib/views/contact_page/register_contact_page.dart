import 'package:chatlinxs/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';

class RegisterContactPage extends StatefulWidget {
  const RegisterContactPage({super.key, this.scrollController});
  final ScrollController? scrollController;

  @override
  State<RegisterContactPage> createState() => _RegisterContactPage();
}

class _RegisterContactPage extends State<RegisterContactPage> {
  int selectedGender = 0;

  Widget getBody() {
    return Scaffold(
      backgroundColor: backgroundColor(context),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 26,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        splashRadius: 26,
                        constraints:
                            const BoxConstraints(maxHeight: 27, maxWidth: 27),
                        icon: Icon(
                          LineIcons.arrowLeft,
                          color: blackColor(context).lightShade,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Registro Contacto",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: blackColor(context).darkShade),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            height: 32,
          ),
          const SizedBox(height: 16),
          customListTile("Correo"),
          const SizedBox(height: 16),
          customButtom(),
          const SizedBox(height: 16),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: backgroundColor(context), body: getBody());
  }

  Widget customMultiChoice(String heading, List<String> choices, int selected,
      ValueChanged<int> onSelect) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22.0, bottom: 10),
          child: Row(
            children: [
              Text(
                heading.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: grayColor(context).lightShade),
              )
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 44,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  choices.length,
                  (index) => InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          onSelect(index);
                        },
                        child: Container(
                          width: ((MediaQuery.of(context).size.width - 44) /
                                  choices.length) -
                              10,
                          height: 50,
                          decoration: BoxDecoration(
                              color: selected == index
                                  ? greenColor
                                  : const Color(0xFF262831),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              choices[index].toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: selected == index
                                      ? backgroundColor(context)
                                      : blackColor(context).lightShade),
                            ),
                          ),
                        ),
                      ))),
        ),
      ],
    );
  }

  Widget customButtom() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22.0, bottom: 10),
          child: Row(
            children: [
              Text(
                "Buscar contacto",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: grayColor(context).lightShade),
              )
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Container(
            width: (MediaQuery.of(context).size.width - 44) - 10,
            height: 50,
            decoration: BoxDecoration(
                color: greenColor, borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                "Buscar",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: backgroundColor(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget customListTile(String heading) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22.0, bottom: 10),
          child: Row(
            children: [
              Text(
                heading.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: grayColor(context).lightShade),
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 44,
          height: 50,
          decoration: BoxDecoration(
              color: const Color(0xFF262831),
              borderRadius: BorderRadius.circular(8)),
        ),
      ],
    );
  }
}
