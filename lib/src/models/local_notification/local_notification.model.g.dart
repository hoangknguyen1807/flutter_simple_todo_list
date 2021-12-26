// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalNotificationModelAdapter
    extends TypeAdapter<LocalNotificationModel> {
  @override
  final int typeId = 2;

  @override
  LocalNotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalNotificationModel(
      id: fields[0] as int,
      title: fields[1] as String,
      body: fields[2] as String,
      scheduledTime: fields[3] as DateTime,
      isRead: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LocalNotificationModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.scheduledTime)
      ..writeByte(4)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalNotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
