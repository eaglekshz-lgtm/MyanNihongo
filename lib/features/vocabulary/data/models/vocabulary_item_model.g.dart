// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExampleSentenceModelAdapter extends TypeAdapter<ExampleSentenceModel> {
  @override
  final int typeId = 6;

  @override
  ExampleSentenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExampleSentenceModel(
      japanese: fields[0] as String,
      english: fields[1] as String,
      burmese: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExampleSentenceModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.japanese)
      ..writeByte(1)
      ..write(obj.english)
      ..writeByte(2)
      ..write(obj.burmese);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExampleSentenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranslationModelAdapter extends TypeAdapter<TranslationModel> {
  @override
  final int typeId = 7;

  @override
  TranslationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslationModel(
      english: fields[0] as String,
      burmese: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TranslationModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.english)
      ..writeByte(1)
      ..write(obj.burmese);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizQuestionModelAdapter extends TypeAdapter<QuizQuestionModel> {
  @override
  final int typeId = 2;

  @override
  QuizQuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizQuestionModel(
      question: fields[0] as String,
      options: (fields[1] as Map).cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizQuestionModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizQuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizDataModelAdapter extends TypeAdapter<QuizDataModel> {
  @override
  final int typeId = 1;

  @override
  QuizDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizDataModel(
      kanjiToHiragana: fields[0] as QuizQuestionModel?,
      hiraganaToKanji: fields[1] as QuizQuestionModel?,
    );
  }

  @override
  void write(BinaryWriter writer, QuizDataModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.kanjiToHiragana)
      ..writeByte(1)
      ..write(obj.hiraganaToKanji);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VocabularyItemModelAdapter extends TypeAdapter<VocabularyItemModel> {
  @override
  final int typeId = 0;

  @override
  VocabularyItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VocabularyItemModel(
      id: fields[0] as int,
      word: fields[1] as String,
      reading: fields[2] as String,
      partOfSpeech: fields[3] as String,
      translations: fields[4] as TranslationModel,
      exampleSentences: (fields[5] as List).cast<ExampleSentenceModel>(),
      quizzes: fields[6] as QuizDataModel?,
    );
  }

  @override
  void write(BinaryWriter writer, VocabularyItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.reading)
      ..writeByte(3)
      ..write(obj.partOfSpeech)
      ..writeByte(4)
      ..write(obj.translations)
      ..writeByte(5)
      ..write(obj.exampleSentences)
      ..writeByte(6)
      ..write(obj.quizzes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExampleSentenceModel _$ExampleSentenceModelFromJson(
        Map<String, dynamic> json) =>
    ExampleSentenceModel(
      japanese: json['japanese'] as String,
      english: json['english'] as String,
      burmese: json['burmese'] as String,
    );

Map<String, dynamic> _$ExampleSentenceModelToJson(
        ExampleSentenceModel instance) =>
    <String, dynamic>{
      'japanese': instance.japanese,
      'english': instance.english,
      'burmese': instance.burmese,
    };

TranslationModel _$TranslationModelFromJson(Map<String, dynamic> json) =>
    TranslationModel(
      english: json['english'] as String,
      burmese: json['burmese'] as String,
    );

Map<String, dynamic> _$TranslationModelToJson(TranslationModel instance) =>
    <String, dynamic>{
      'english': instance.english,
      'burmese': instance.burmese,
    };

QuizQuestionModel _$QuizQuestionModelFromJson(Map<String, dynamic> json) =>
    QuizQuestionModel(
      question: json['question'] as String,
      options: Map<String, bool>.from(json['options'] as Map),
    );

Map<String, dynamic> _$QuizQuestionModelToJson(QuizQuestionModel instance) =>
    <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
    };

QuizDataModel _$QuizDataModelFromJson(Map<String, dynamic> json) =>
    QuizDataModel(
      kanjiToHiragana: json['kanji_to_hiragana'] == null
          ? null
          : QuizQuestionModel.fromJson(
              json['kanji_to_hiragana'] as Map<String, dynamic>),
      hiraganaToKanji: json['hiragana_to_kanji'] == null
          ? null
          : QuizQuestionModel.fromJson(
              json['hiragana_to_kanji'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizDataModelToJson(QuizDataModel instance) =>
    <String, dynamic>{
      'kanji_to_hiragana': instance.kanjiToHiragana?.toJson(),
      'hiragana_to_kanji': instance.hiraganaToKanji?.toJson(),
    };

VocabularyItemModel _$VocabularyItemModelFromJson(Map<String, dynamic> json) =>
    VocabularyItemModel(
      id: (json['id'] as num).toInt(),
      word: json['word'] as String,
      reading: json['reading'] as String,
      partOfSpeech: json['part_of_speech'] as String,
      translations: TranslationModel.fromJson(
          json['translations'] as Map<String, dynamic>),
      exampleSentences: (json['example_sentences'] as List<dynamic>)
          .map((e) => ExampleSentenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      quizzes: json['quizzes'] == null
          ? null
          : QuizDataModel.fromJson(json['quizzes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VocabularyItemModelToJson(
        VocabularyItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'reading': instance.reading,
      'part_of_speech': instance.partOfSpeech,
      'translations': instance.translations.toJson(),
      'example_sentences':
          instance.exampleSentences.map((e) => e.toJson()).toList(),
      'quizzes': instance.quizzes?.toJson(),
    };
