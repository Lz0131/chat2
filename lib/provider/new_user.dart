import 'package:chatlinxs/managers/firestore_manager.dart';
import 'package:chatlinxs/models/user.dart';
import 'package:uuid/uuid.dart';

class newUser {
  User? user;
  String? userId;
  FirestoreManager manager = FirestoreManager();

  void sendUser(User newuser) {
    String generateRandomHex(int length) {
      return const Uuid().v4();
    }

    userId ??= generateRandomHex(10);
    manager.createNewUser(newuser);
  }
}
