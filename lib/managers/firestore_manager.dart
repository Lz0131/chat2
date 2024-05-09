import 'package:chatlinxs/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatlinxs/constants/enums.dart';
import 'package:chatlinxs/managers/local_db_manager/local_db.dart';
import 'package:chatlinxs/models/chat.dart';
import 'package:chatlinxs/models/message.dart';
import 'package:chatlinxs/models/user.dart';

class Collections {
  static const String chats = 'chats';
  static const String users = 'users';
  static const String calls = 'calls';
  static const String messages = 'messages';
}

class ChatAndUser {
  final Chat? chat;
  final User? user;

  ChatAndUser({this.chat, this.user});
}

class FirestoreManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUserExist({String? email, String? uuid}) async {
    print("________________________");
    if (email == null && uuid == null) {
      print("el correo es 1:  $email");
      throw Exception('Email and uuid both can\'t be null');
    }
    final QuerySnapshot<Map<String, dynamic>> userSnapshot;
    if (email != null) {
      print("el correo es 2:  $email");
      userSnapshot = await _firestore
          .collection(Collections.users)
          .where(User.emailKey, isEqualTo: email)
          .get();
      print("${userSnapshot.docs}");
    } else {
      userSnapshot = await _firestore
          .collection(Collections.users)
          .where(User.uuidKey, isEqualTo: uuid)
          .get();
    }
    return userSnapshot.docs.isNotEmpty;
  }

  Future<void> registerUser(User user) async {
    await _firestore.collection(Collections.users).add(user.toJson());
  }

  Future<User> getUser(email) async {
    final userSnapshot = await _firestore
        .collection(Collections.users)
        .where(User.emailKey, isEqualTo: email)
        .get();
    return User.fromJson(userSnapshot.docs.first.data());
  }

  Future<ChatAndUser> getChat(String email) async {
    User? user;
    Chat? chat;

    final userSnapshot = await _firestore
        .collection(Collections.users)
        .where(User.emailKey, isEqualTo: email)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userDocRef = userSnapshot.docs.first.reference;
      user = User.fromJson(userSnapshot.docs.first.data());
      try {
        final chatData = (await userDocRef
                .collection(Collections.chats)
                .where('uuid', isEqualTo: LocalDB.user.uuid)
                .get())
            .docs
            .first;
        if (chatData.exists) {
          chat = Chat.fromJson(chatData.data());
        }
      } catch (_) {}
    }
    return ChatAndUser(chat: chat, user: user);
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserChats(
      String userId) async {
    final userSnapshot = (await _firestore
        .collection(Collections.users)
        .where('uuid', isEqualTo: LocalDB.user.uuid)
        .get());
    final chatsSnapshot = _firestore
        .collection(Collections.users)
        .doc(userSnapshot.docs.first.id)
        .collection(Collections.chats)
        .snapshots();
    return chatsSnapshot;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserCalls(
      String userId) async {
    final userSnapshot = (await _firestore
        .collection(Collections.users)
        .where('uuid', isEqualTo: LocalDB.user.uuid)
        .get());
    final callSnapshot = _firestore
        .collection(Collections.users)
        .doc(userSnapshot.docs.first.id)
        .collection(Collections.calls)
        .snapshots();
    return callSnapshot;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(String chatId) {
    final messagesSnapshot = _firestore
        .collection(Collections.chats)
        .doc(chatId)
        .collection(Collections.messages)
        .orderBy(Message.dateTimeKey)
        .snapshots();
    return messagesSnapshot;
  }

  Future<void> createNewUser(User newUser) async {
    // Se comprueba si el usuario ya existe en la colección "Users"
    final userSnapshot =
        await _firestore.collection(Collections.users).doc(newUser.uuid).get();

    // Si el usuario no existe, se crea uno nuevo
    if (!userSnapshot.exists) {
      await _firestore
          .collection(Collections.users)
          .doc(newUser.uuid)
          .set(newUser.toJson());
    } else {
      // El usuario ya existe, puedes manejar esta situación de acuerdo a tus requerimientos
      print('El usuario ya existe en la base de datos.');
    }
  }

  Future<void> createCall(Call call) async {
    final callSnapshot =
        await _firestore.collection(Collections.calls).doc(call.uuid).get();

    if (!callSnapshot.exists) {
      await _firestore
          .collection(Collections.calls)
          .doc(call.uuid)
          .set(call.toJson());
    }
  }

  Future<void> sendCall(
      String callId, Call call, User sender, User receiver) async {
    // Guardar la llamada en la colección de llamadas en Firestore
    await _firestore
        .collection(Collections.calls)
        .doc(callId)
        .set(call.toJson());

    // Obtener una referencia al documento del usuario que realiza la llamada
    final senderSnapshot = await _firestore
        .collection(Collections.users)
        .where(User.uuidKey, isEqualTo: sender.uuid)
        .get();
    final senderDocRef = senderSnapshot.docs.first.reference;

    // Verificar si ya existe una conversación entre el remitente y el receptor de la llamada
    bool senderCallExists =
        (await senderDocRef.collection(Collections.calls).doc(callId).get())
            .exists;

    // Actualizar o crear una entrada en la colección de llamadas del remitente
    if (senderCallExists) {
      await senderDocRef
          .collection(Collections.calls)
          .doc(callId)
          .update(call.toJson());
    } else {
      await senderDocRef
          .collection(Collections.calls)
          .doc(callId)
          .set(call.toJson());
    }

    // Repetir el mismo proceso para el receptor de la llamada
    final receiverSnapshot = await _firestore
        .collection(Collections.users)
        .where(User.uuidKey, isEqualTo: receiver.uuid)
        .get();
    final receiverDocRef = receiverSnapshot.docs.first.reference;
    bool receiverCallExists =
        (await receiverDocRef.collection(Collections.calls).doc(callId).get())
            .exists;
    if (receiverCallExists) {
      await receiverDocRef
          .collection(Collections.calls)
          .doc(callId)
          .update(call.toJson());
    } else {
      await receiverDocRef
          .collection(Collections.calls)
          .doc(callId)
          .set(call.toJson());
    }
  }

  Future<void> sendChatMessage(
      String chatId, Message message, User user) async {
    _firestore
        .collection(Collections.chats)
        .doc(chatId)
        .collection(Collections.messages)
        .add(message.toJson());

    final userSnapshot = await _firestore
        .collection(Collections.users)
        .where(User.uuidKey, isEqualTo: LocalDB.user.uuid)
        .get();
    final userDocRef = userSnapshot.docs.first.reference;
    bool exists1 =
        (await userDocRef.collection(Collections.chats).doc(chatId).get())
            .exists;
    if (exists1) {
      await userDocRef.collection(Collections.chats).doc(chatId).update(Chat(
              user,
              ChatType.message,
              message,
              0,
              DateTime.now(),
              chatId,
              user.uuid)
          .toJson());
    } else {
      await userDocRef.collection(Collections.chats).doc(chatId).set(Chat(user,
              ChatType.message, message, 0, DateTime.now(), chatId, user.uuid)
          .toJson());
    }

    final userSnapshot2 = await _firestore
        .collection(Collections.users)
        .where(User.uuidKey, isEqualTo: user.uuid)
        .get();
    final userDocRef2 = userSnapshot2.docs.first.reference;
    bool exists2 =
        (await userDocRef2.collection(Collections.chats).doc(chatId).get())
            .exists;
    if (exists2) {
      await userDocRef2.collection(Collections.chats).doc(chatId).update(Chat(
              LocalDB.user,
              ChatType.message,
              message,
              0,
              DateTime.now(),
              chatId,
              LocalDB.user.uuid)
          .toJson());
    } else {
      await userDocRef2.collection(Collections.chats).doc(chatId).set(Chat(
              LocalDB.user,
              ChatType.message,
              message,
              0,
              DateTime.now(),
              chatId,
              LocalDB.user.uuid)
          .toJson());
    }
  }
}

// static sendNotificationRequestToFriendToAcceptCall(
//     String roomId, User user) async {
//   var data = jsonEncode({
//     "uuid": user.uuid,
//     "caller_id": user.phoneNumber,
//     "caller_name": user.name,
//     "caller_id_type": "number",
//     "has_video": "false",
//     "room_id": roomId,
//     "fcm_token": user.firebaseToken
//   });
//   var r = await http.post(Uri.parse("$apiUrl/send-notification"),
//       body: data, headers: {"Content-Type": "application/json"});
//   print(r.body);
// }
