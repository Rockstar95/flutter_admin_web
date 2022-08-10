// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResEventTrackTabs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResEventTrackTabsListAdapter extends TypeAdapter<ResEventTrackTabsList> {
  @override
  final int typeId = 0;

  @override
  ResEventTrackTabsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResEventTrackTabsList(
      (fields[0] as List).cast<ResEventTrackTabs>(),
    );
  }

  @override
  void write(BinaryWriter writer, ResEventTrackTabsList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tabList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResEventTrackTabsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResEventTrackTabsAdapter extends TypeAdapter<ResEventTrackTabs> {
  @override
  final int typeId = 1;

  @override
  ResEventTrackTabs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResEventTrackTabs(
      tabName: fields[0] as String,
      tabId: fields[1] as int,
      tabidName: fields[2] as String,
      glossaryhtml: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ResEventTrackTabs obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tabName)
      ..writeByte(1)
      ..write(obj.tabId)
      ..writeByte(2)
      ..write(obj.tabidName)
      ..writeByte(3)
      ..write(obj.glossaryhtml);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResEventTrackTabsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
