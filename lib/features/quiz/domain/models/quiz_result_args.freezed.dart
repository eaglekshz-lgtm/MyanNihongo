// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_result_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuizResultArgs {
  /// Total number of questions in the quiz
  int get totalQuestions => throw _privateConstructorUsedError;

  /// Number of questions answered correctly
  int get correctAnswers => throw _privateConstructorUsedError;

  /// Optional JLPT level of the quiz
  String? get level => throw _privateConstructorUsedError;

  /// Create a copy of QuizResultArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizResultArgsCopyWith<QuizResultArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizResultArgsCopyWith<$Res> {
  factory $QuizResultArgsCopyWith(
          QuizResultArgs value, $Res Function(QuizResultArgs) then) =
      _$QuizResultArgsCopyWithImpl<$Res, QuizResultArgs>;
  @useResult
  $Res call({int totalQuestions, int correctAnswers, String? level});
}

/// @nodoc
class _$QuizResultArgsCopyWithImpl<$Res, $Val extends QuizResultArgs>
    implements $QuizResultArgsCopyWith<$Res> {
  _$QuizResultArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizResultArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? level = freezed,
  }) {
    return _then(_value.copyWith(
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizResultArgsImplCopyWith<$Res>
    implements $QuizResultArgsCopyWith<$Res> {
  factory _$$QuizResultArgsImplCopyWith(_$QuizResultArgsImpl value,
          $Res Function(_$QuizResultArgsImpl) then) =
      __$$QuizResultArgsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalQuestions, int correctAnswers, String? level});
}

/// @nodoc
class __$$QuizResultArgsImplCopyWithImpl<$Res>
    extends _$QuizResultArgsCopyWithImpl<$Res, _$QuizResultArgsImpl>
    implements _$$QuizResultArgsImplCopyWith<$Res> {
  __$$QuizResultArgsImplCopyWithImpl(
      _$QuizResultArgsImpl _value, $Res Function(_$QuizResultArgsImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizResultArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? level = freezed,
  }) {
    return _then(_$QuizResultArgsImpl(
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$QuizResultArgsImpl extends _QuizResultArgs {
  const _$QuizResultArgsImpl(
      {required this.totalQuestions, required this.correctAnswers, this.level})
      : super._();

  /// Total number of questions in the quiz
  @override
  final int totalQuestions;

  /// Number of questions answered correctly
  @override
  final int correctAnswers;

  /// Optional JLPT level of the quiz
  @override
  final String? level;

  @override
  String toString() {
    return 'QuizResultArgs(totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResultArgsImpl &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.level, level) || other.level == level));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, totalQuestions, correctAnswers, level);

  /// Create a copy of QuizResultArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResultArgsImplCopyWith<_$QuizResultArgsImpl> get copyWith =>
      __$$QuizResultArgsImplCopyWithImpl<_$QuizResultArgsImpl>(
          this, _$identity);
}

abstract class _QuizResultArgs extends QuizResultArgs {
  const factory _QuizResultArgs(
      {required final int totalQuestions,
      required final int correctAnswers,
      final String? level}) = _$QuizResultArgsImpl;
  const _QuizResultArgs._() : super._();

  /// Total number of questions in the quiz
  @override
  int get totalQuestions;

  /// Number of questions answered correctly
  @override
  int get correctAnswers;

  /// Optional JLPT level of the quiz
  @override
  String? get level;

  /// Create a copy of QuizResultArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizResultArgsImplCopyWith<_$QuizResultArgsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
