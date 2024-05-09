import 'package:chatlinxs/models/calls.dart';
import 'package:chatlinxs/models/user.dart';

class Call {
  final User user;
  final Calls calls;
  final DateTime dateTime;
  final String numberofCalls;
  final String callId;
  final String uuid;

  Call(this.user, this.calls, this.dateTime, this.numberofCalls, this.callId,
      this.uuid);

  factory Call.fromJson(Map<String, dynamic> data) => Call(
      User.fromJson(data['user']),
      Calls.fromJson(data['calls']),
      DateTime.parse(data['dateTime']),
      data['numberofCalls'],
      data['callId'],
      data['uuid']);

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'calls': calls.toJson(),
        'dateTime': dateTime?.toIso8601String(),
        'numberofCalls': numberofCalls,
        'callId': callId,
        'uuid': uuid
      };
}
