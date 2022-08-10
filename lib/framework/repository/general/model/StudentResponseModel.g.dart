// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StudentResponseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentResponseModelAdapter extends TypeAdapter<StudentResponseModel> {
  @override
  final int typeId = 0;

  @override
  StudentResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentResponseModel(
      siteId: fields[0] as String,
      scoId: fields[1] as int,
      userId: fields[2] as int,
      questionid: fields[3] as int,
      assessmentattempt: fields[4] as int,
      questionattempt: fields[5] as int,
      attemptdate: fields[6] as String,
      studentresponses: fields[7] as String,
      attachfilename: fields[8] as String,
      attachfileid: fields[9] as String,
      attachedfilepath: fields[10] as String,
      optionalNotes: fields[11] as String,
      result: fields[12] as String,
      rindex: fields[13] as int,
      capturedVidFileName: fields[14] as String,
      capturedVidId: fields[15] as String,
      capturedVidFilepath: fields[16] as String,
      capturedImgFileName: fields[17] as String,
      capturedImgId: fields[18] as String,
      capturedImgFilepath: fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentResponseModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.siteId)
      ..writeByte(1)
      ..write(obj.scoId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.questionid)
      ..writeByte(4)
      ..write(obj.assessmentattempt)
      ..writeByte(5)
      ..write(obj.questionattempt)
      ..writeByte(6)
      ..write(obj.attemptdate)
      ..writeByte(7)
      ..write(obj.studentresponses)
      ..writeByte(8)
      ..write(obj.attachfilename)
      ..writeByte(9)
      ..write(obj.attachfileid)
      ..writeByte(10)
      ..write(obj.attachedfilepath)
      ..writeByte(11)
      ..write(obj.optionalNotes)
      ..writeByte(12)
      ..write(obj.result)
      ..writeByte(13)
      ..write(obj.rindex)
      ..writeByte(14)
      ..write(obj.capturedVidFileName)
      ..writeByte(15)
      ..write(obj.capturedVidId)
      ..writeByte(16)
      ..write(obj.capturedVidFilepath)
      ..writeByte(17)
      ..write(obj.capturedImgFileName)
      ..writeByte(18)
      ..write(obj.capturedImgId)
      ..writeByte(19)
      ..write(obj.capturedImgFilepath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
