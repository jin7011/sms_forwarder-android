import 'package:hive/hive.dart';

part 'sms_message_model.g.dart';

@HiveType(typeId: 1)
enum ForwardStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  success,
  @HiveField(2)
  failed,
}

@HiveType(typeId: 2)
class SmsMessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sender;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime receivedAt;

  @HiveField(4)
  DateTime? forwardedAt;

  @HiveField(5)
  ForwardStatus status;

  @HiveField(6)
  String? errorMessage;

  SmsMessageModel({
    required this.id,
    required this.sender,
    required this.body,
    required this.receivedAt,
    this.forwardedAt,
    this.status = ForwardStatus.pending,
    this.errorMessage,
  });
}
