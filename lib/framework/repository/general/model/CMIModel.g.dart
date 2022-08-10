// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CMIModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CMIModelAdapter extends TypeAdapter<CMIModel> {
  @override
  final int typeId = 0;

  @override
  CMIModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CMIModel(
      percentageCompleted: fields[25] as String,
      parentObjTypeId: fields[26] as String,
      parentContentId: fields[27] as String,
      parentScoId: fields[28] as String,
      contentId: fields[29] as String,
      showStatus: fields[30] as String,
      Id: fields[0] as int,
      siteId: fields[1] as String,
      scoId: fields[2] as int,
      userId: fields[3] as int,
      location: fields[4] as String,
      status: fields[5] as String,
      suspenddata: fields[6] as String,
      isupdate: fields[7] as String,
      sitrurl: fields[8] as String,
      objecttypeid: fields[9] as String,
      datecompleted: fields[10] as String,
      noofattempts: fields[11] as int,
      score: fields[12] as String,
      seqNum: fields[13] as String,
      startdate: fields[14] as String,
      timespent: fields[15] as String,
      attemptsleft: fields[16] as String,
      coursemode: fields[17] as String,
      scoremin: fields[18] as String,
      scoremax: fields[19] as String,
      submittime: fields[20] as String,
      trackscoid: fields[21] as int,
      qusseq: fields[22] as String,
      pooledqusseq: fields[23] as String,
      textResponses: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CMIModel obj) {
    writer
      ..writeByte(31)
      ..writeByte(0)
      ..write(obj.Id)
      ..writeByte(1)
      ..write(obj.siteId)
      ..writeByte(2)
      ..write(obj.scoId)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.suspenddata)
      ..writeByte(7)
      ..write(obj.isupdate)
      ..writeByte(8)
      ..write(obj.sitrurl)
      ..writeByte(9)
      ..write(obj.objecttypeid)
      ..writeByte(10)
      ..write(obj.datecompleted)
      ..writeByte(11)
      ..write(obj.noofattempts)
      ..writeByte(12)
      ..write(obj.score)
      ..writeByte(13)
      ..write(obj.seqNum)
      ..writeByte(14)
      ..write(obj.startdate)
      ..writeByte(15)
      ..write(obj.timespent)
      ..writeByte(16)
      ..write(obj.attemptsleft)
      ..writeByte(17)
      ..write(obj.coursemode)
      ..writeByte(18)
      ..write(obj.scoremin)
      ..writeByte(19)
      ..write(obj.scoremax)
      ..writeByte(20)
      ..write(obj.submittime)
      ..writeByte(21)
      ..write(obj.trackscoid)
      ..writeByte(22)
      ..write(obj.qusseq)
      ..writeByte(23)
      ..write(obj.pooledqusseq)
      ..writeByte(24)
      ..write(obj.textResponses)
      ..writeByte(25)
      ..write(obj.percentageCompleted)
      ..writeByte(26)
      ..write(obj.parentObjTypeId)
      ..writeByte(27)
      ..write(obj.parentContentId)
      ..writeByte(28)
      ..write(obj.parentScoId)
      ..writeByte(29)
      ..write(obj.contentId)
      ..writeByte(30)
      ..write(obj.showStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CMIModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
