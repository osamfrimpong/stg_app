// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubItem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubItemAdapter extends TypeAdapter<SubItem> {
  @override
  final int typeId = 1;

  @override
  SubItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubItem(
      id: fields[2] as int,
      title: fields[0] as String,
      address: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
