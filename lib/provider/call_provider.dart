import 'package:chatlinxs/managers/firestore_manager.dart';
import 'package:chatlinxs/models/call.dart';
import 'package:chatlinxs/models/user.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CallProvider extends ChangeNotifier {
  //user, fecha, numberofCalls, callStatus
  /* String? callId;
  User? outuser;
  User? inuser;
  DateTime? dateTime;
  int numberofCalls = 0;
  bool callStatus = false;*/
  bool isSearch = false;

  TextEditingController controller = TextEditingController();

  FirestoreManager manager = FirestoreManager();

  List<User> statusList = [];

  /*void sendCall(Call call, User sender, User receiver) {
    String generateRandomHex(int length) {
      return const Uuid().v4();
    }

    call.dateTime = DateTime.now();
    callId ??= generateRandomHex(10);
    manager.sendCall(callId!, call, sender!, receiver!);
  }*/

  void toggleIsSearch() {
    isSearch = !isSearch;
    notifyListeners();
  }
}
