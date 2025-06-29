// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScenarioAdapter extends TypeAdapter<Scenario> {
  @override
  final int typeId = 0;

  @override
  Scenario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Scenario(
      id: fields[0] as String,
      categoryId: fields[1] as String,
      titleAr: fields[2] as String,
      titleEn: fields[3] as String,
      steps: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Scenario obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.titleAr)
      ..writeByte(3)
      ..write(obj.titleEn)
      ..writeByte(4)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScenarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
