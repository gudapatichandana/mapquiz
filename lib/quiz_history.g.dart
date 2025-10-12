// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizHistoryAdapter extends TypeAdapter<QuizHistory> {
  @override
  final int typeId = 1;

  @override
  QuizHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizHistory(
      id: fields[0] as String,
      subject: fields[1] as String,
      score: fields[2] as int,
      totalQuestions: fields[3] as int,
      timeTaken: fields[4] as Duration,
      totalTime: fields[5] as Duration,
      completedAt: fields[6] as DateTime,
      difficulty: fields[7] as String,
      pointsEarned: fields[8] as int,
      answers: (fields[9] as List?)?.cast<QuizAnswer>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizHistory obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.totalQuestions)
      ..writeByte(4)
      ..write(obj.timeTaken)
      ..writeByte(5)
      ..write(obj.totalTime)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.pointsEarned)
      ..writeByte(9)
      ..write(obj.answers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizAnswerAdapter extends TypeAdapter<QuizAnswer> {
  @override
  final int typeId = 2;

  @override
  QuizAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizAnswer(
      questionId: fields[0] as String,
      questionText: fields[1] as String,
      selectedIndex: fields[2] as int,
      correctIndex: fields[3] as int,
      options: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizAnswer obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.questionText)
      ..writeByte(2)
      ..write(obj.selectedIndex)
      ..writeByte(3)
      ..write(obj.correctIndex)
      ..writeByte(4)
      ..write(obj.options)
      ..writeByte(5)
      ..write(obj.isCorrect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
