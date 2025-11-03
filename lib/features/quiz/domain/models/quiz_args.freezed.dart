// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuizArgs {
  /// Optional JLPT level filter
  String? get level => throw _privateConstructorUsedError;

  /// Number of questions to include in quiz
  int get numberOfQuestions => throw _privateConstructorUsedError;

  /// Create a copy of QuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizArgsCopyWith<QuizArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizArgsCopyWith<$Res> {
  factory $QuizArgsCopyWith(QuizArgs value, $Res Function(QuizArgs) then) =
      _$QuizArgsCopyWithImpl<$Res, QuizArgs>;
  @useResult
  $Res call({String? level, int numberOfQuestions});
}

/// @nodoc
class _$QuizArgsCopyWithImpl<$Res, $Val extends QuizArgs>
    implements $QuizArgsCopyWith<$Res> {
  _$QuizArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = freezed,
    Object? numberOfQuestions = null,
  }) {
    return _then(_value.copyWith(
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfQuestions: null == numberOfQuestions
          ? _value.numberOfQuestions
          : numberOfQuestions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizArgsImplCopyWith<$Res>
    implements $QuizArgsCopyWith<$Res> {
  factory _$$QuizArgsImplCopyWith(
          _$QuizArgsImpl value, $Res Function(_$QuizArgsImpl) then) =
      __$$QuizArgsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? level, int numberOfQuestions});
}

/// @nodoc
class __$$QuizArgsImplCopyWithImpl<$Res>
    extends _$QuizArgsCopyWithImpl<$Res, _$QuizArgsImpl>
    implements _$$QuizArgsImplCopyWith<$Res> {
  __$$QuizArgsImplCopyWithImpl(
      _$QuizArgsImpl _value, $Res Function(_$QuizArgsImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = freezed,
    Object? numberOfQuestions = null,
  }) {
    return _then(_$QuizArgsImpl(
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfQuestions: null == numberOfQuestions
          ? _value.numberOfQuestions
          : numberOfQuestions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$QuizArgsImpl extends _QuizArgs {
  const _$QuizArgsImpl({this.level, required this.numberOfQuestions})
      : super._();

  /// Optional JLPT level filter
  @override
  final String? level;

  /// Number of questions to include in quiz
  @override
  final int numberOfQuestions;

  @override
  String toString() {
    return 'QuizArgs(level: $level, numberOfQuestions: $numberOfQuestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizArgsImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.numberOfQuestions, numberOfQuestions) ||
                other.numberOfQuestions == numberOfQuestions));
  }

  @override
  int get hashCode => Object.hash(runtimeType, level, numberOfQuestions);

  /// Create a copy of QuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizArgsImplCopyWith<_$QuizArgsImpl> get copyWith =>
      __$$QuizArgsImplCopyWithImpl<_$QuizArgsImpl>(this, _$identity);
}

abstract class _QuizArgs extends QuizArgs {
  const factory _QuizArgs(
      {final String? level,
      required final int numberOfQuestions}) = _$QuizArgsImpl;
  const _QuizArgs._() : super._();

  /// Optional JLPT level filter
  @override
  String? get level;

  /// Number of questions to include in quiz
  @override
  int get numberOfQuestions;

  /// Create a copy of QuizArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizArgsImplCopyWith<_$QuizArgsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
