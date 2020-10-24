// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HTML_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HTMLItemAdapter extends TypeAdapter<HTMLItem> {
  @override
  final int typeId = 3;

  @override
  HTMLItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HTMLItem(
      id: fields[2] as int,
      address: fields[0] as String,
      content: fields[1] as String,
      title: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HTMLItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HTMLItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
