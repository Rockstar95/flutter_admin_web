// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LearnerSessionModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LearnerSessionModelAdapter extends TypeAdapter<LearnerSessionModel> {
  @override
  final int typeId = 0;

  @override
  LearnerSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LearnerSessionModel(
      sessionID: fields[0] as String,
      userID: fields[1] as String,
      scoID: fields[2] as String,
      attemptNumber: fields[3] as String,
      sessionDateTime: fields[4] as String,
      timeSpent: fields[5] as String,
      siteID: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LearnerSessionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.sessionID)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.scoID)
      ..writeByte(3)
      ..write(obj.attemptNumber)
      ..writeByte(4)
      ..write(obj.sessionDateTime)
      ..writeByte(5)
      ..write(obj.timeSpent)
      ..writeByte(6)
      ..write(obj.siteID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearnerSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
