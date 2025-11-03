// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_quiz_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VocabularyQuizArgs {
  /// JLPT level (N5, N4, N3, N2, N1)
  String get level => throw _privateConstructorUsedError;

  /// Optional word type filter (noun, verb, adjective, etc.)
  String? get wordType => throw _privateConstructorUsedError;

  /// Number of questions in the quiz (must be positive)
  int get numberOfQuestions => throw _privateConstructorUsedError;

  /// Whether to show Burmese meaning during quiz
  bool get showBurmeseMeaning => throw _privateConstructorUsedError;

  /// Quiz type (kanji_to_hiragana or hiragana_to_kanji)
  String get quizType => throw _privateConstructorUsedError;

  /// Create a copy of VocabularyQuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VocabularyQuizArgsCopyWith<VocabularyQuizArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VocabularyQuizArgsCopyWith<$Res> {
  factory $VocabularyQuizArgsCopyWith(
          VocabularyQuizArgs value, $Res Function(VocabularyQuizArgs) then) =
      _$VocabularyQuizArgsCopyWithImpl<$Res, VocabularyQuizArgs>;
  @useResult
  $Res call(
      {String level,
      String? wordType,
      int numberOfQuestions,
      bool showBurmeseMeaning,
      String quizType});
}

/// @nodoc
class _$VocabularyQuizArgsCopyWithImpl<$Res, $Val extends VocabularyQuizArgs>
    implements $VocabularyQuizArgsCopyWith<$Res> {
  _$VocabularyQuizArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VocabularyQuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? wordType = freezed,
    Object? numberOfQuestions = null,
    Object? showBurmeseMeaning = null,
    Object? quizType = null,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      wordType: freezed == wordType
          ? _value.wordType
          : wordType // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfQuestions: null == numberOfQuestions
          ? _value.numberOfQuestions
          : numberOfQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      showBurmeseMeaning: null == showBurmeseMeaning
          ? _value.showBurmeseMeaning
          : showBurmeseMeaning // ignore: cast_nullable_to_non_nullable
              as bool,
      quizType: null == quizType
          ? _value.quizType
          : quizType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VocabularyQuizArgsImplCopyWith<$Res>
    implements $VocabularyQuizArgsCopyWith<$Res> {
  factory _$$VocabularyQuizArgsImplCopyWith(_$VocabularyQuizArgsImpl value,
          $Res Function(_$VocabularyQuizArgsImpl) then) =
      __$$VocabularyQuizArgsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String level,
      String? wordType,
      int numberOfQuestions,
      bool showBurmeseMeaning,
      String quizType});
}

/// @nodoc
class __$$VocabularyQuizArgsImplCopyWithImpl<$Res>
    extends _$VocabularyQuizArgsCopyWithImpl<$Res, _$VocabularyQuizArgsImpl>
    implements _$$VocabularyQuizArgsImplCopyWith<$Res> {
  __$$VocabularyQuizArgsImplCopyWithImpl(_$VocabularyQuizArgsImpl _value,
      $Res Function(_$VocabularyQuizArgsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VocabularyQuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? wordType = freezed,
    Object? numberOfQuestions = null,
    Object? showBurmeseMeaning = null,
    Object? quizType = null,
  }) {
    return _then(_$VocabularyQuizArgsImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      wordType: freezed == wordType
          ? _value.wordType
          : wordType // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfQuestions: null == numberOfQuestions
          ? _value.numberOfQuestions
          : numberOfQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      showBurmeseMeaning: null == showBurmeseMeaning
          ? _value.showBurmeseMeaning
          : showBurmeseMeaning // ignore: cast_nullable_to_non_nullable
              as bool,
      quizType: null == quizType
          ? _value.quizType
          : quizType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$VocabularyQuizArgsImpl implements _VocabularyQuizArgs {
  const _$VocabularyQuizArgsImpl(
      {required this.level,
      this.wordType,
      required this.numberOfQuestions,
      required this.showBurmeseMeaning,
      required this.quizType});

  /// JLPT level (N5, N4, N3, N2, N1)
  @override
  final String level;

  /// Optional word type filter (noun, verb, adjective, etc.)
  @override
  final String? wordType;

  /// Number of questions in the quiz (must be positive)
  @override
  final int numberOfQuestions;

  /// Whether to show Burmese meaning during quiz
  @override
  final bool showBurmeseMeaning;

  /// Quiz type (kanji_to_hiragana or hiragana_to_kanji)
  @override
  final String quizType;

  @override
  String toString() {
    return 'VocabularyQuizArgs(level: $level, wordType: $wordType, numberOfQuestions: $numberOfQuestions, showBurmeseMeaning: $showBurmeseMeaning, quizType: $quizType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VocabularyQuizArgsImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.wordType, wordType) ||
                other.wordType == wordType) &&
            (identical(other.numberOfQuestions, numberOfQuestions) ||
                other.numberOfQuestions == numberOfQuestions) &&
            (identical(other.showBurmeseMeaning, showBurmeseMeaning) ||
                other.showBurmeseMeaning == showBurmeseMeaning) &&
            (identical(other.quizType, quizType) ||
                other.quizType == quizType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, level, wordType,
      numberOfQuestions, showBurmeseMeaning, quizType);

  /// Create a copy of VocabularyQuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VocabularyQuizArgsImplCopyWith<_$VocabularyQuizArgsImpl> get copyWith =>
      __$$VocabularyQuizArgsImplCopyWithImpl<_$VocabularyQuizArgsImpl>(
          this, _$identity);
}

abstract class _VocabularyQuizArgs implements VocabularyQuizArgs {
  const factory _VocabularyQuizArgs(
      {required final String level,
      final String? wordType,
      required final int numberOfQuestions,
      required final bool showBurmeseMeaning,
      required final String quizType}) = _$VocabularyQuizArgsImpl;

  /// JLPT level (N5, N4, N3, N2, N1)
  @override
  String get level;

  /// Optional word type filter (noun, verb, adjective, etc.)
  @override
  String? get wordType;

  /// Number of questions in the quiz (must be positive)
  @override
  int get numberOfQuestions;

  /// Whether to show Burmese meaning during quiz
  @override
  bool get showBurmeseMeaning;

  /// Quiz type (kanji_to_hiragana or hiragana_to_kanji)
  @override
  String get quizType;

  /// Create a copy of VocabularyQuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VocabularyQuizArgsImplCopyWith<_$VocabularyQuizArgsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
