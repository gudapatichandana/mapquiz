// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      name: fields[2] as String,
      totalPoints: fields[3] as int,
      quizzesCompleted: fields[4] as int,
      quizHistory: (fields[5] as List?)?.cast<QuizHistory>(),
      subjectScores: (fields[6] as Map?)?.cast<String, int>(),
      achievements: (fields[7] as List?)?.cast<String>(),
      createdAt: fields[8] as DateTime?,
      lastLoginAt: fields[9] as DateTime?,
      profilePicture: fields[10] as String?,
      currentStreak: fields[11] as int,
      bestStreak: fields[12] as int,
      lastQuizDate: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.totalPoints)
      ..writeByte(4)
      ..write(obj.quizzesCompleted)
      ..writeByte(5)
      ..write(obj.quizHistory)
      ..writeByte(6)
      ..write(obj.subjectScores)
      ..writeByte(7)
      ..write(obj.achievements)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.lastLoginAt)
      ..writeByte(10)
      ..write(obj.profilePicture)
      ..writeByte(11)
      ..write(obj.currentStreak)
      ..writeByte(12)
      ..write(obj.bestStreak)
      ..writeByte(13)
      ..write(obj.lastQuizDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
