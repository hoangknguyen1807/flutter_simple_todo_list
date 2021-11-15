// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoItemModelAdapter extends TypeAdapter<ToDoItemModel> {
  @override
  final int typeId = 1;

  @override
  ToDoItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoItemModel(
      fields[0] as String,
      fields[1] as DateTime,
      fields[3] as bool,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ToDoItemModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._title)
      ..writeByte(1)
      ..write(obj._occurTime)
      ..writeByte(2)
      ..write(obj._description)
      ..writeByte(3)
      ..write(obj._isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
