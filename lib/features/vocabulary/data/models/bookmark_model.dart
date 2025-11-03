import 'package:hive/hive.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 3)
class BookmarkModel {
  @HiveField(0)
  final String vocabularyId;

  @HiveField(1)
  final DateTime bookmarkedAt;

  BookmarkModel({
    required this.vocabularyId,
    required this.bookmarkedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkModel &&
          runtimeType == other.runtimeType &&
          vocabularyId == other.vocabularyId;

  @override
  int get hashCode => vocabularyId.hashCode;
}
