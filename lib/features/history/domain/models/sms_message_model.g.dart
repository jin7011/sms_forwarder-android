// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmsMessageModelAdapter extends TypeAdapter<SmsMessageModel> {
  @override
  final int typeId = 2;

  @override
  SmsMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmsMessageModel(
      id: fields[0] as String,
      sender: fields[1] as String,
      body: fields[2] as String,
      receivedAt: fields[3] as DateTime,
      forwardedAt: fields[4] as DateTime?,
      status: fields[5] as ForwardStatus,
      errorMessage: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SmsMessageModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sender)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.receivedAt)
      ..writeByte(4)
      ..write(obj.forwardedAt)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ForwardStatusAdapter extends TypeAdapter<ForwardStatus> {
  @override
  final int typeId = 1;

  @override
  ForwardStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ForwardStatus.pending;
      case 1:
        return ForwardStatus.success;
      case 2:
        return ForwardStatus.failed;
      default:
        return ForwardStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ForwardStatus obj) {
    switch (obj) {
      case ForwardStatus.pending:
        writer.writeByte(0);
        break;
      case ForwardStatus.success:
        writer.writeByte(1);
        break;
      case ForwardStatus.failed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForwardStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
