class Calls {
  static const String dateTimeKey = 'dateTime';
  static const String durationKey = 'duration';
  static const String userSendingCallsUUIDKey = 'userSendingCallsUUID';
  static const String callStatusKey = 'callStatus';

  DateTime? dateTime;
  final String? duration;
  final String? userSendingCallsUUID;
  final String? callStatus;

  DateTime get callDateTime => dateTime ?? DateTime.now();

  Calls(
      {this.dateTime,
      this.duration,
      this.callStatus,
      required this.userSendingCallsUUID});

  factory Calls.fromJson(Map<String, dynamic> data) => Calls(
      userSendingCallsUUID: data[userSendingCallsUUIDKey],
      dateTime: data[dateTimeKey] != null
          ? DateTime.parse(data[dateTimeKey])
          : DateTime.now(),
      callStatus: data[callStatusKey],
      duration: data[durationKey]);

  Map<String, dynamic> toJson() => {
        dateTimeKey: dateTime?.toIso8601String(),
        durationKey: duration,
        callStatusKey: callStatus,
        userSendingCallsUUIDKey: userSendingCallsUUID
      };
}
