import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:chatlinxs/constants/enums.dart';
import 'package:chatlinxs/provider/contact_provider.dart';
import 'package:chatlinxs/views/message_page/message_page.dart';
import 'package:chatlinxs/widgets/custom_listtile.dart';
import 'package:chatlinxs/widgets/custom_loader.dart';
import 'package:chatlinxs/widgets/no_data_found.dart';

class ContactsListView extends StatefulWidget {
  final ContactProvider provider;

  const ContactsListView({super.key, required this.provider});

  @override
  State<ContactsListView> createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> {
  ContactProvider get provider => widget.provider;

  bool get isLoadingFinished => provider.isLoadingFinished;

  List<Contact> get contacts => provider.contacts;

  List<Contact> get selectedContacts => provider.selectedContacts;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoadingFinished && contacts.isEmpty
          ? const Center(
              child: NoDataFound(),
            )
          : contacts.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  // controller: widget.scrollController,
                  itemCount: contacts.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 0.3,
                    );
                  },
                  itemBuilder: (context, index) {
                    Contact contact = contacts[index];
                    return CustomListTile(
                        imageBytes: contact.photoOrThumbnail,
                        participants: const [],
                        imageUrl:
                            "https://raw.githubusercontent.com/pixelastic/fakeusers/master/pictures/men/38.jpg",
                        isSelected: provider.isContactSelected(contact),
                        title: contact.displayName,
                        subTitle: contact.phones.first.number,
                        showImage: false,
                        messageCounter: null,
                        onTap: () {
                          if (selectedContacts.isNotEmpty) {
                            setState(() {
                              if (provider.isContactSelected(contact)) {
                                selectedContacts.removeWhere((contact) =>
                                    contact.phones
                                        .contains(contact.phones.first.number));
                              } else {
                                selectedContacts.add(contact);
                              }
                            });
                          } else {
                            print(contact.phones.first.number);
                            String phone =
                                contact.phones.first.number.split(' ')[1];
                            print(phone);
                            provider.manager.getChat(phone).then((chatAndUser) {
                              if (chatAndUser.user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'The user does not have app installed')));
                                return;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MessagePage(
                                            user: chatAndUser.user!,
                                            chatId: chatAndUser.chat?.chatId,
                                          )));
                            });
                          }
                        },
                        onLongPress: () {
                          setState(() {
                            if (provider.isContactSelected(contact)) {
                              selectedContacts.removeWhere((contact) =>
                                  contact.phones
                                      .contains(contact.phones.first.number));
                            } else {
                              selectedContacts.add(contact);
                            }
                          });
                        },
                        customListTileType: CustomListTileType.contact,
                        timeFrame: "");
                  })
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CustomLoader()],
                ),
    );
  }
}
