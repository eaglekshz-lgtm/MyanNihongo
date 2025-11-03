import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vocabulary_item_model.g.dart';

@HiveType(typeId: 6)
@JsonSerializable()
class ExampleSentenceModel {
  @HiveField(0)
  final String japanese;
  @HiveField(1)
  final String english;
  @HiveField(2)
  final String burmese;

  const ExampleSentenceModel({
    required this.japanese,
    required this.english,
    required this.burmese,
  });

  factory ExampleSentenceModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleSentenceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExampleSentenceModelToJson(this);
}

@HiveType(typeId: 7)
@JsonSerializable()
class TranslationModel {
  @HiveField(0)
  final String english;
  @HiveField(1)
  final String burmese;

  const TranslationModel({required this.english, required this.burmese});

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationModelFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationModelToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class QuizQuestionModel {
  @HiveField(0)
  final String question;
  @HiveField(1)
  final Map<String, bool> options;

  const QuizQuestionModel({required this.question, required this.options});

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuizQuestionModelToJson(this);
}

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class QuizDataModel {
  @HiveField(0)
  @JsonKey(name: 'kanji_to_hiragana')
  final QuizQuestionModel? kanjiToHiragana;
  @HiveField(1)
  @JsonKey(name: 'hiragana_to_kanji')
  final QuizQuestionModel? hiraganaToKanji;

  const QuizDataModel({this.kanjiToHiragana, this.hiraganaToKanji});

  factory QuizDataModel.fromJson(Map<String, dynamic> json) =>
      _$QuizDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuizDataModelToJson(this);
}

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class VocabularyItemModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String word;
  @HiveField(2)
  final String reading;
  @HiveField(3)
  @JsonKey(name: 'part_of_speech')
  final String partOfSpeech;
  @HiveField(4)
  final TranslationModel translations;
  @HiveField(5)
  @JsonKey(name: 'example_sentences')
  final List<ExampleSentenceModel> exampleSentences;
  @HiveField(6)
  final QuizDataModel? quizzes;

  VocabularyItemModel({
    required this.id,
    required this.word,
    required this.reading,
    required this.partOfSpeech,
    required this.translations,
    required this.exampleSentences,
    this.quizzes,
  });

  factory VocabularyItemModel.fromJson(Map<String, dynamic> json) =>
      _$VocabularyItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$VocabularyItemModelToJson(this);
}
